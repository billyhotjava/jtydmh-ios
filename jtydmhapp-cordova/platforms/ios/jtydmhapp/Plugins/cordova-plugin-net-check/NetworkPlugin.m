//
//  NetworkPlugin.m
//  CordovaTest
//
//  Created by eccl on 2022/1/4.
//

#import "NetworkPlugin.h"
#import "RealReachability.h"
#import "PingHelper.h"
#import "CLAPIClient.h"

@interface NetworkPlugin ()

@property (nonatomic, strong) PingHelper *pingHelper;
@property (nonatomic, copy) NSString *pingHost;
@property (nonatomic, strong) NSTimer *timer;

// 准入 callbackId
@property (nonatomic, copy) NSString *accessCallbackId;
// 检查更新
@property (nonatomic, copy) NSString *checkUpdateCallbackId;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
//@property (nonatomic, strong) NSDictionary *param;

@end

@implementation NetworkPlugin

/// 检测网络是否为国神内网
- (void)netType:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== 检测国神网络 ====");
            WS(weakSelf)
            CLAPIClient *client = [CLAPIClient sharedInstanceShortTimeOut];
            client.responseSerializer = [AFHTTPResponseSerializer serializer];
            [client.requestSerializer setValue:@"0" forHTTPHeaderField:@"If-Modified-Since"];
            [client.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
            [client GET:CLAPIBaseNewGuoShenLANURL baseURLType:CLAPIBaseNewGuoShenLANURL parameters:@{@"timestamp": @([[NSDate date] timeIntervalSince1970])} animated:NO success:^(NSDictionary * _Nullable responseObject) {
                DLog(@"https://mgs.sgeg.chnenergy.com.cn 结果: %@", responseObject);
                if (responseObject && [responseObject isKindOfClass:[NSData class]] && ((NSData *)responseObject).length > 0) {
                    NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                    DLog(@"https://mgs.sgeg.chnenergy.com.cn data: %@", response);
                    if ([response containsString:@"<script>"]) {
                        // <html><meta charset='utf-8'/><style>body{background:white}</style><script>self.location='/user-login-Lw==.html';\
                        \
                        </script>
                        NSLog(@"https://mgs.sgeg.chnenergy.com.cn 可能公司WiFi 外网 得到网页 <script> 不准确");
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
                        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    } else {
                        // 内网
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0"];
                        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                } else {
//                    NSLog(@"https://mgs.sgeg.chnenergy.com.cn 外网 返回 1");
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            } failure:^(NSError * _Nonnull error) {
//                NSLog(@"https://mgs.sgeg.chnenergy.com.cn 错误: %@", error);
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
                [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
            
//            [self tryPingHost:^(BOOL isSuccess, NSTimeInterval latency) {
//                [weakSelf stopPing];
//                NSLog(@"ping 回调 %d, latency: %f", isSuccess, latency);
//                if (isSuccess) {
//                    NSLog(@"==== 国神内网 ====");
//                    // 国神内网
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0"];
//                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                } else {
//                    NSLog(@"==== 互联网 ====");
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
//                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                }
//            }];
        });
    }];
}

- (void)tryPingHost:(void(^)(BOOL isSuccess, NSTimeInterval latency))callback {
    if (!self.pingHelper) {
        self.pingHelper = [[PingHelper alloc] init];
    }
//    NSLog(@"try ping host %@", kPingHostAddress);
    self.pingHelper.host = kPingHostAddress;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerSchedule) userInfo:nil repeats:YES];
    [self timerSchedule:callback];
}

- (void)timerSchedule:(void(^)(BOOL isSuccess, NSTimeInterval latency))callback {
    WS(weakSelf)
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer schedule");
        [weakSelf.pingHelper pingWithBlock:callback];
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"ping 超时");
//        [weakSelf stopPing];
//        [weakSelf requestAccessCheck:CLAPIBaseGuoShenWLANURL param:weakSelf.param];
//    });
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//- (void)timerSchedule {
//    WS(weakSelf)
//    [self.pingHelper pingWithBlock:^(BOOL isSuccess, NSTimeInterval latency) {
//        NSLog(@"ping 回调 %d, latency: %f", isSuccess, latency);
//        if (isSuccess) {
//            [weakSelf stopPing];
//            // 国神内网
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0"];
//            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:self.netTypeCallbackId];
//        } else {
//            if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable || GLobalRealReachability.currentReachabilityStatus == RealStatusUnknown) {
//                [weakSelf stopPing];
//            }
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
//            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:self.netTypeCallbackId];
//        }
//    }];
//}

- (void)stopPing {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.pingHelper) {
        self.pingHelper = nil;
    }
}

/// 检测是否有网络
- (void)checkNetworkAvailable:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        if (GLobalRealReachability.currentReachabilityStatus == RealStatusViaWWAN || GLobalRealReachability.currentReachabilityStatus == RealStatusViaWiFi) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

/// 准入管理，需忽略准入内网服务的自签证书，并请求返回数据给前端
/// @param command  Cordova 入参
/// deviceType
/// uniqueCode
/// employeeCode
- (void)access:(CDVInvokedUrlCommand *)command {
    self.accessCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            if (args && args.count >= 3) {
                NSString *deviceType = args.firstObject;
                NSString *uniqueCode = args[1];
                NSString *userCode = args[2];
//                self.param = @{
                NSDictionary *param = @{
                    @"deviceType": deviceType,
                    @"uniqueCode": uniqueCode,
                    @"userCode": userCode
                };
//                NSLog(@"准入 入参 %@", param);
                [self requestAccessCheck:CLAPIBaseGuoShenWLANURL param:param];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数个数不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (void)requestAccessCheck:(CLAPIBaseURL)hostUrl param:(NSDictionary *)param {
    [[CLAPIClient sharedInstance] POST:@"/accessManage/accessCheck" baseURLType:hostUrl parameters:param animated:NO success:^(NSDictionary * _Nullable responseObject) {
//        NSLog(@"准入接口 %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d", [responseObject[@"object"] intValue]]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"准入校验失败，请重新登录"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
        }
    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"准入接口 Error %@", error.localizedDescription);
//        NSLog(@"准入失败，先放行");
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
//        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"准入校验失败，请重新登录"];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
    }];
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        CGFloat width = 30.0;
        _activityIndicatorView.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width) / 2, (CGRectGetHeight([UIScreen mainScreen].bounds) - width) / 2, width, width);
        [[UIApplication sharedApplication].keyWindow addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (void)showActivity {
    [self.activityIndicatorView startAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
}

- (void)hideActivity {
    [self.activityIndicatorView stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
}

/// 检查更新，需忽略检查更新内网服务的自签证书，并请求返回数据给前端
/// @param command  Cordova 入参
/// deviceType
/// needDialog
- (void)update:(CDVInvokedUrlCommand *)command {
    self.checkUpdateCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            if (args && args.count >= 2) {
                NSString *deviceType = args.firstObject;
                BOOL needDialog = [args[1] boolValue];
                NSDictionary *param = @{
                    @"deviceType": deviceType
                };
//                NSLog(@"检查更新 %@", param);
                if (needDialog) {
                    [self showActivity];
                }
                [self requestCheckUpdate:CLAPIBaseGuoShenWLANURL param:param needDialog:needDialog];
//                if (GLobalRealReachability.currentReachabilityStatus == RealStatusViaWiFi) {
//                    WS(weakSelf)
//                    [self tryPingHost:^(BOOL isSuccess, NSTimeInterval latency) {
//                        NSLog(@"ping 回调 %d, latency: %f", isSuccess, latency);
//                        [weakSelf stopPing];
//                        if (isSuccess) {
//                            // 国神内网
//                            [weakSelf requestCheckUpdate:CLAPIBaseGuoShenLANURL param:param needDialog:needDialog];
//                        } else {
////                            if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable || GLobalRealReachability.currentReachabilityStatus == RealStatusUnknown) {
//                                [weakSelf requestAccessCheck:CLAPIBaseGuoShenWLANURL param:param];
////                            }
//                        }
//                    }];
//                } else {
//                    [self requestCheckUpdate:CLAPIBaseGuoShenWLANURL param:param needDialog:needDialog];
//                }
            } else {
                [self hideActivity];
                // 失败直接过
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (void)requestCheckUpdate:(CLAPIBaseURL)hostUrl param:(NSDictionary *)param needDialog:(BOOL)needDialog {
    NSString *version = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
    NSString *url = [NSString stringWithFormat:@"%@/appPackage/obtainNewPackageByDeviceType?deviceType=%@&versionNumber=%@", CLAPIBaseGuoShenWLANURL, param[@"deviceType"], version];
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.timeoutIntervalForRequest = 10.0;
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSString *uniqueCode1 = [self uniqueAppInstanceIdentifier];
//    [manager.requestSerializer setValue:uniqueCode1 forHTTPHeaderField:@"uniqueCode"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet
//                                                         setWithObjects:@"application/json",@"text/json",
//                                                         @"text/javascript",@"text/html",@"text/plain",
//                                                         @"application/atom+xml",@"application/xml",
//                                                         @"text/xml",@"image/png",@"image/jpeg",
//                                                         @"charset=utf-8", nil];
//    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *response = (NSDictionary *)responseObject;
//        if ([[response objectForKey:@"success"] boolValue] == YES) {
//            NSDictionary *object = response[@"object"];
//            if (object) {
//                NSInteger versionNum = [object[@"versionNum"] integerValue];
//                NSInteger currentVersion = [version integerValue];
//                if (versionNum > currentVersion) {
//                    [self checkUpdateBaseUrl:object needDialog:needDialog];
//                } else {
//                    if (needDialog && self.activityIndicatorView.isAnimating) {
//                        [self hideActivity];
//                    }
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
//                }
//            } else {
//                if (needDialog && self.activityIndicatorView.isAnimating) {
//                    [self hideActivity];
//                }
//                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
//                [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
//            }
//        } else {
//            if (needDialog && self.activityIndicatorView.isAnimating) {
//                [self hideActivity];
//            }
//            // 失败直接过
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
//        }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (needDialog && self.activityIndicatorView.isAnimating) {
//                [self hideActivity];
//            }
//            NSLog(@"检查更新接口 Error %@", error.localizedDescription);
//            NSLog(@"准入失败，先放行");
//    //        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
//    //        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
//            // 失败直接过
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
//    }];
//    return;
    CLAPIClient *client = [CLAPIClient sharedInstance];
    NSString *uniqueCode = [self uniqueAppInstanceIdentifier];
    [client.requestSerializer setValue:uniqueCode forHTTPHeaderField:@"uniqueCode"];
    [client GET:url baseURLType:hostUrl parameters:nil animated:NO success:^(NSDictionary * _Nullable responseObject) {
//        NSLog(@"检查更新接口 %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
            NSDictionary *object = responseObject[@"object"];
            if (object) {
                NSInteger versionNum = [object[@"versionNum"] integerValue];
                NSInteger currentVersion = [version integerValue];
                if (versionNum > currentVersion) {
                    [self checkUpdateBaseUrl:object needDialog:needDialog];
                } else {
                    if (needDialog && self.activityIndicatorView.isAnimating) {
                        [self hideActivity];
                    }
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
                }
            } else {
                if (needDialog && self.activityIndicatorView.isAnimating) {
                    [self hideActivity];
                }
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
            }
        } else {
            if (needDialog && self.activityIndicatorView.isAnimating) {
                [self hideActivity];
            }
            // 失败直接过
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
        }
    } failure:^(NSError * _Nonnull error) {
        if (needDialog && self.activityIndicatorView.isAnimating) {
            [self hideActivity];
        }
        NSLog(@"检查更新接口 Error %@", error.localizedDescription);
        NSLog(@"准入失败，先放行");
//        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.accessCallbackId];
        // 失败直接过
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
    }];
}

- (void)checkUpdateBaseUrl:(NSDictionary *)info needDialog:(BOOL)needDialog {
    if (needDialog && self.activityIndicatorView.isAnimating) {
        [self hideActivity];
    }
    [self showUpdateAlert:info baseUrl:CLAPIBaseGuoShenWLANURL];
//    if (GLobalRealReachability.currentReachabilityStatus == RealStatusViaWiFi) {
//        WS(weakSelf)
//        [self tryPingHost:^(BOOL isSuccess, NSTimeInterval latency) {
//            NSLog(@"ping 回调 %d, latency: %f", isSuccess, latency);
//            [weakSelf stopPing];
//            if (needDialog && self.activityIndicatorView.isAnimating) {
//                [self hideActivity];
//            }
//            if (isSuccess) {
//                NSInteger isForceUpdate = [info[@"isForceUpdate"] integerValue];
//                // 国神内网
//                if (isForceUpdate == 1) {
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"检测到有新版本需要更新，请切换至外网WiFi或者蜂窝移动数据网络进行更新"];
//                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:weakSelf.checkUpdateCallbackId];
//                } else {
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"检测到有新版本需要更新，请切换至外网WiFi或者蜂窝移动数据网络进行更新"];
//                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:weakSelf.checkUpdateCallbackId];
//                }
//            } else {
//                [weakSelf showUpdateAlert:info baseUrl:CLAPIBaseGuoShenWLANURL];
//            }
//        }];
//    } else {
//        if (needDialog && self.activityIndicatorView.isAnimating) {
//            [self hideActivity];
//        }
//        [self showUpdateAlert:info baseUrl:CLAPIBaseGuoShenWLANURL];
//    }
}

- (NSString*)uniqueAppInstanceIdentifier {
    UIDevice *device = [UIDevice currentDevice];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"CDVUUID";
    
    // Check user defaults first to maintain backwards compaitibility with previous versions
    // which didn't user identifierForVendor
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    if (app_uuid == nil) {
        if ([device respondsToSelector:@selector(identifierForVendor)]) {
            app_uuid = [[device identifierForVendor] UUIDString];
        } else {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            app_uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
        }

        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
    }
    
    return app_uuid;
}

- (void)showUpdateAlert:(NSDictionary *)info baseUrl:(NSString *)baseUrl {
    NSString *remark = info[@"remark"];
    NSString *iosConfAttachmentId = info[@"iosConfAttachmentId"];
    NSInteger isForceUpdate = [info[@"isForceUpdate"] integerValue];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新说明" message:remark preferredStyle:UIAlertControllerStyleAlert];
    if (isForceUpdate == 2) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"cancel"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showActivity];
        NSString *urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@/appPackage/downloadAppPackageByPath/%@", baseUrl, iosConfAttachmentId];
//        NSLog(@"安装新版本 %@", urlStr);
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//                NSLog(@"安装新版本打开结果 %d", success);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideActivity];
                    abort();
                });
            }];
        } else {
//            NSLog(@"无法打开安装ipa");
            [self hideActivity];
            // 失败直接过
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.checkUpdateCallbackId];
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)checkNetworkDialog:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            if (args && args.count >= 1) {
                NSString *showStr = args.firstObject;
                if ([showStr isEqualToString:@"1"]) {
                    CLNetworkStatusTipView.sharedInstance.canShow = YES;
                } else {
                    CLNetworkStatusTipView.sharedInstance.canShow = NO;
                }
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数个数不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

@end
