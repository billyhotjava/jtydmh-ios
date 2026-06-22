//
//  CLVPNManager.m
//  jtdgdw
//
//  Created by eccl on 2020/8/25.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "CLVPNManager.h"
#import "CLProgressHUD.h"

#define kVPNWithNC

static NSString * const kVPN_HOST = @"ydvpn.ceic.com";
static NSString * const kVPN_PORT = @"443";
//static NSString * const kLOGIN_USERNAME = @"ceshi24";
//static NSString * const kLOGIN_PASSSWORD = @"gsjt@ceshi24";
//static NSString * const kVPN_AUTH_NAME = @"本地认证";
static NSString * const kVPN_AUTH_NAME = @"ldap-auth"; // 20007482      Tangpukai6!@#

@interface CLVPNManager () <SPVPNClientDelegate>

@property (nonatomic, strong) SPVPNClient *secSDK;
@property (nonatomic) BOOL isLoginSuccess;

@end

@implementation CLVPNManager

+ (instancetype)sharedInstance {
    static CLVPNManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLVPNManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnLoginFailNotification:) name:VPNLoginFailNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ncStatusConnectedNotification:) name:SPSDKNCStatusConnectedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ncStatusDisconnectedNotification:) name:SPSDKNCStatusDisconnectedNotification object:nil];
        
        //注册接收通知消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSSLVPNSessionNotify:) name:SPSDKSSLVPNTopicNotification object:nil];

    }
    return self;
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password {
    [[CLProgressHUD sharedInstance] showWithTip:@"正在进行安全认证..."];
    [SPVPNClient queryNCStatus:^(SPNCStatus status) {
        if(status != SPNCStatusConnected) {
            if ([CLVPNManager sharedInstance].isLoginSuccess) {
                NSLog(@"断开重新连接");
                [[CLVPNManager sharedInstance] logout];
            }
            NSDictionary *param = @{
                @"vpn_host": kVPN_HOST,
                @"vpn_port": kVPN_PORT,
                @"auth_server": kVPN_AUTH_NAME,
                @"auth_username": account,
                @"auth_password": password,
                @"auth_mode": @(0),
                @"auth_autologin": @(1),
//                @"extra_test_param1" : @"extra_test_param1",
            };
            [CLVPNManager sharedInstance].secSDK = [SPVPNClient login:param listener:self];
            [CLVPNManager sharedInstance].isLoginSuccess = NO;
        } else {
            if([CLVPNManager sharedInstance].connectCompletion) {
                [CLVPNManager sharedInstance].connectCompletion(YES, nil);
            }
        }
    }];
}

- (void)logout {
//    [[CLProgressHUD sharedInstance] show];
    if (self.secSDK) {
//        [self.secSDK logOut];
        [self.secSDK stopNC];
//        [SPVPNClient unregisterHttpProxyProtocol];
//        [SPVPNClient stopAutoSetProxyCFNetwork];
        [[CLProgressHUD sharedInstance] hide];
    }
    self.isLoginSuccess = NO;
    if (self.disconnectCompletion) {
        self.disconnectCompletion(!self.isLoginSuccess, nil);
    }
}

- (NSInteger)queryHttpProxyPort {
    if (self.isLoginSuccess) {
        return [SPVPNClient queryProxyPort];
    }
    return 0;
}

#pragma mark - NSNotificationCenter

///// VPN 登录失败
//- (void)vpnLoginFailNotification:(NSNotification *)notification {
//    NSLog(@"VPN 登录失败通知 notification: %@", notification);
//    [[CLProgressHUD sharedInstance] hide];
//    self.isLoginSuccess = NO;
//    if (self.connectCompletion) {
//        self.connectCompletion(self.isLoginSuccess, nil);
//    }
//}

/// NC 连接成功通知
- (void)ncStatusConnectedNotification:(NSNotification *)notification {
    NSLog(@"NC连接成功通知 notification: %@", notification);
    [[CLProgressHUD sharedInstance] hide];
    self.isLoginSuccess = YES;
    if (self.connectCompletion) {
        self.connectCompletion(self.isLoginSuccess, nil);
    }
}

/// NC 断开成功通知
- (void)ncStatusDisconnectedNotification:(NSNotification *)notification {
    NSLog(@"NC断开成功通知 %s, notification: %@", __func__, notification);
}

- (void)onSSLVPNSessionNotify:(NSNotification*)noti {
    NSDictionary* topicDic = [noti object];
    NSLog(@"topicDict: %@", topicDic);
    if(topicDic) {
        NSString* topic = [topicDic objectForKey:@"topic"];
        NSDictionary* content = [topicDic objectForKey:@"content"];
        if((topic && [topic isEqualToString:@"session_status"]) &&
           (content && [content objectForKey:@"session_state"])) {
            if([[content objectForKey:@"session_state"] isEqualToString:@"offline"]) {
                if([content objectForKey:@"session_renew"]) {
                    //提示下线
                }
            } else if([[content objectForKey:@"session_state"] isEqualToString:@"online"]) {
                //提示上线
            }
        }
    }
}


#pragma mark - SPVPNClientDelegate

- (void)didLoginSuccess {
    NSLog(@"VPN 登录成功, %s", __func__);
#ifdef kVPNWithNC
    NSString *bundleName = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleNameKey);
    NSDictionary *pluginParams = @{
//        @"vpnplugin_name": [NSString stringWithFormat:@"%@ VPN", bundleName]
        @"vpnplugin_name": @"掌上国神VPN"
    };
    [self.secSDK startNC:pluginParams];
    NSLog(@"%@", [self.secSDK getServicesArray]);
#else
    NSLog(@"VPN --> HTTP Proxy 模式可用");
    [SPVPNClient registerHttpProxyProtocol];
    [SPVPNClient startAutoSetProxyCFNetwork];
    [[CLProgressHUD sharedInstance] hide];
    NSLog(@"%@", [self.secSDK getServicesArray]);
    self.isLoginSuccess = YES;
    if (self.connectCompletion) {
        self.connectCompletion(self.isLoginSuccess, nil);
    }
#endif
}

- (void)onLoginErrorID:(NSInteger)errid msg:(NSString*)errmsg {
    NSLog(@"1 VPN 登录失败, errmsg: %@", errmsg);
    [[CLProgressHUD sharedInstance] hide];
    self.isLoginSuccess = NO;
    if (self.connectCompletion) {
        self.connectCompletion(self.isLoginSuccess, [NSString stringWithFormat:@"(1) 安全认证的 %@", errmsg]);
    }
}

- (void)onRuntimeErrorID:(NSInteger)errid msg:(NSString*)errmsg {
    NSLog(@"2 VPN 登录失败, errmsg: %@", errmsg);
    [[CLProgressHUD sharedInstance] hide];
    self.isLoginSuccess = NO;
    if (self.connectCompletion) {
        self.connectCompletion(self.isLoginSuccess, [NSString stringWithFormat:@"(2) 安全认证的 %@", errmsg]);
    }
}

- (void)onRuntimeErrorRenew {
    NSLog(@"VPN runtime error 失败");
    [[CLProgressHUD sharedInstance] hide];
    self.isLoginSuccess = NO;
    if (self.connectCompletion) {
        self.connectCompletion(self.isLoginSuccess, nil);
    }
}

- (void)didLogoutCompleted {
    self.isLoginSuccess = NO;
    NSLog(@"VPN 登出成功, %s", __func__);
}

- (void)dealloc {
    NSLog(@"%s dealloc", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
