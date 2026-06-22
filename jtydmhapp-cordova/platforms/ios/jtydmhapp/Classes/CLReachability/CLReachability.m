//
//  CLReachability.m
//  jtydmh
//
//  Created by eccl on 2021/6/22.
//

#import "CLReachability.h"
#import "RealReachability.h"
#import "PingHelper.h"
#import "CLNetworkStatusTipView.h"
#import "SDKWrapper.h"
#import "CLNotificationInstance.h"
#import "CLAPIClient.h"

@interface CLReachability () <NSURLSessionDelegate>

@property (nonatomic, strong) PingHelper *pingHelper;
@property (nonatomic, copy) NSString *pingHost;
@property (nonatomic, strong) NSTimer *timer;
/// 用网络请求代替不可用的ping，网络请求回调
@property (nonatomic, copy) void(^pingCompletion)(BOOL success);

@end

@implementation CLReachability

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)reachabilityWithPingHost:(NSString *)pingHost {
    [GLobalRealReachability startNotifier];
    self.pingHost = pingHost;
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        DLog(@"网络切换 ~~~~~~~~~~ status: %ld", (long)status);
        switch (status) {
            case RealStatusUnknown:
            case RealStatusNotReachable: {
                DLog(@"网络不可用 show");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [[CLNetworkStatusTipView sharedInstance] show:status];
//                });
                break;
            }
            default:
                break;
        }
    }];
}

- (void)stopNotifier {
    [self stopPing];
    [GLobalRealReachability stopNotifier];
}

- (void)tryPingHost:(void(^)(BOOL isSuccess, NSTimeInterval latency))callback {
    if (!self.pingHelper) {
        self.pingHelper = [[PingHelper alloc] init];
    }
    DLog(@"网络切换 try ping host %@", self.pingHost);
    self.pingHelper.host = self.pingHost;
    [self timerSchedule:callback];
}

- (void)timerSchedule:(void(^)(BOOL isSuccess, NSTimeInterval latency))callback {
    WS(weakSelf)
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        DLog(@"网络切换 timer schedule");
        [weakSelf.pingHelper pingWithBlock:callback];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stopPing {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.pingHelper) {
        self.pingHelper = nil;
    }
}

- (void)loginVPN {
    [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnecting];
    NSString *userCode = [CLNotificationInstance sharedInstance].userCode;
    NSString *vpn_password = [CLNotificationInstance sharedInstance].vpn_password;
    if (IsAvailableString(userCode) && IsAvailableString(vpn_password)) {
        NSDictionary *param = @{
            @"vpn_host": kVPNHost,
            @"vpn_port": kVPNPort,
            @"auth_server": kVPNServer,
            @"auth_username": userCode,
            @"auth_password": vpn_password,
            @"auth_mode": @0,
            @"auth_autologin": @1
        };
        WS(weakSelf)
        [[SDKWrapper getInstance] runWithParams:param responseHandler:^(BOOL result, NSString *_Nullable errorMessage) {
            if(result) {
                DLog(@"网络切换 VPN Login Succees");
                [self newPingToGuoShenLANHostWithCompletion:^(BOOL success) {
                    if (success) {
                        DLog(@"ping 通 国神内网，修改界面");
                        [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnected];
                    } else {
                        DLog(@"ping 不通 国神内网，重新登录vpn");
                        [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnected];
                        [[SDKWrapper getInstance] stop];
                        [weakSelf performSelector:@selector(loginVPN)];
                    }
                }];
//                [self tryPingHost:^(BOOL isSuccess, NSTimeInterval latency) {
//                    NSLog(@"ping is Success: %d, latency: %f", isSuccess, latency);
//                    if (isSuccess) {
//                        NSLog(@"ping 通 国神内网");
//                        [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnected];
//                    } else {
//                        NSLog(@"ping 不通 国神内网，重试");
//                        [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnected];
//                        [[SDKWrapper getInstance] stop];
//                        [weakSelf performSelector:@selector(loginVPN)];
//                    }
//                }];
            } else {
                DLog(@"VPN Login Fail");
                [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNConnectFail];
            }
        }];
    } else {
        DLog(@"vpn 的用户名或密码为空");
    }
}

#pragma mark - NSNotification

- (void)networkChanged:(NSNotification *)notification {
    if (![CLNotificationInstance sharedInstance].isLogin) {
        return;
    }
    RealReachability *reachability = (RealReachability *)notification.object;
    /*
     RealStatusUnknown = -1,
     RealStatusNotReachable = 0,
     RealStatusViaWWAN = 1,
     RealStatusViaWiFi = 2
     */
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    DLog(@"网络切换 networkChanged!!! currentStatus: %@, previousStatus: %@", @(status), @(previousStatus));
    DLog(@"网络状态切换，show 界面");
    [[CLNetworkStatusTipView sharedInstance] show:status];
    switch (status) {
        case RealStatusUnknown: {
            DLog(@"未知网络");
//            [self stopPing];
            return;
        }
            
        case RealStatusNotReachable: {
            DLog(@"网络不可用");
//            [self stopPing];
            return;
        }
            
        case RealStatusViaWWAN: {
            DLog(@"移动数据网络");
            if (previousStatus == RealStatusViaWiFi) {
                // 断开vpn
                [[SDKWrapper getInstance] stop];
            }
            break;
        }
            
        case RealStatusViaWiFi: {
            DLog(@"WiFi 网络");
            if (previousStatus == RealStatusViaWWAN) {
                // 断开vpn
                [[SDKWrapper getInstance] stop];
            }
            break;
        }
            
        default:
            break;
    }
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"网络环境监测");
        CLAPIClient *client = [CLAPIClient sharedInstanceShortTimeOut];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        [client GET:CLAPIBaseGuoShenLANURL baseURLType:CLAPIBaseGuoShenLANURL parameters:nil animated:NO success:^(NSDictionary * _Nullable responseObject) {
            DLog(@"https://mgscheck.sgeg.chnenergy.com.cn 结果: %@", responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSData class]] && ((NSData *)responseObject).length > 0) {
                DLog(@"国神内网，修改界面");
                [[CLNetworkStatusTipView sharedInstance] checkNetworkEnvironmentStatus:CLNetworkGuoShenLAN];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DLog(@"监测vpn状态，修改界面");
                    [[SDKWrapper getInstance] stop];
                    [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNDisconnect];
                });
                
            } else {
                DLog(@"互联网，修改界面");
                if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable || GLobalRealReachability.currentReachabilityStatus == RealStatusUnknown) {
                    DLog(@"网络切换 无网络，ping 不通, %ld", (long)GLobalRealReachability.currentReachabilityStatus);
                } else {
                    [[CLNetworkStatusTipView sharedInstance] checkNetworkEnvironmentStatus:CLNetworkWLAN];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DLog(@"登录vpn");
                        [weakSelf loginVPN];
                    });
                }
            }
        } failure:^(NSError * _Nonnull error) {
            DLog(@"https://mgscheck.sgeg.chnenergy.com.cn 错误: %@", error);
            DLog(@"互联网，修改界面");
            if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable || GLobalRealReachability.currentReachabilityStatus == RealStatusUnknown) {
                DLog(@"网络切换 无网络，ping 不通, %ld", (long)GLobalRealReachability.currentReachabilityStatus);
            } else {
                [[CLNetworkStatusTipView sharedInstance] checkNetworkEnvironmentStatus:CLNetworkWLAN];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DLog(@"登录vpn");
                    [weakSelf loginVPN];
                });
            }
        }];
      /*
        [self tryPingHost:^(BOOL isSuccess, NSTimeInterval latency) {
            DLog(@"网络切换 ping 回调 %d, latency: %f", isSuccess, latency);
            [weakSelf stopPing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    [[CLNetworkStatusTipView sharedInstance] checkNetworkEnvironmentStatus:CLNetworkGuoShenLAN];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[SDKWrapper getInstance] stop];
                        [[CLNetworkStatusTipView sharedInstance] changeVPNStatus:CLVPNDisconnect];
                    });
                } else {
                    if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable || GLobalRealReachability.currentReachabilityStatus == RealStatusUnknown) {
                        NSLog(@"网络切换 无网络，ping 不通, %ld", (long)GLobalRealReachability.currentReachabilityStatus);
                    } else {
                        [[CLNetworkStatusTipView sharedInstance] checkNetworkEnvironmentStatus:CLNetworkWLAN];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf loginVPN];
                        });
//                        [weakSelf performSelector:@selector(loginVPN) withObject:nil afterDelay:1.5];
                    }
                }
            });
        }];
       */
    });
}

/// 使用请求接口的方式代替不能使用的ping
- (void)newPingToGuoShenLANHostWithCompletion:(void(^)(BOOL success))completion {
    self.pingCompletion = completion;
    NSString *host = kPingGuoShenLANHost;
    NSString *prefix = @"https://";
    if (![host hasPrefix:prefix]) {
        host = [prefix stringByAppendingString:host];
    }
    NSURL *url = [NSURL URLWithString:host];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *proxyConfigDic = nil;
    NSInteger proxyPort = [[SDKWrapper getInstance] queryHttpProxyPort];
    if(proxyPort) {
        NSString *host = @"127.0.0.1";
        proxyConfigDic = @{(NSString*)kCFStreamPropertyHTTPProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPProxyPort: @(proxyPort),
                           (NSString*)kCFNetworkProxiesHTTPEnable:@YES,
                           (NSString*)kCFStreamPropertyHTTPSProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPSProxyPort:@(proxyPort)
        };
    }
    NSURLSessionDataTask *sessionTask = [self createSessionWithRequest:request withProxyConfig:proxyConfigDic];
    [sessionTask resume];
}

- (NSURLSessionDataTask *)createSessionWithRequest:(NSURLRequest*)aRequest withProxyConfig:(NSDictionary*)proxyConfigDic {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = proxyConfigDic;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask* sessionTask = [session dataTaskWithRequest:aRequest];
    return sessionTask;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    DLog(@"changed network when vpn login success check ping response: %@", response);
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    DLog(@"网络切换后 登录vpn，检测是否可通国神内网 request data: %@", data);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    DLog(@"完成 error: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pingCompletion) {
            self.pingCompletion(error == nil ? YES : NO);
        }
    });
}

@end
