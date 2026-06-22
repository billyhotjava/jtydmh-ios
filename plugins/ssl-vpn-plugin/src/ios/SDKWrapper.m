//
//  SDKWrapper.m
//  SdkDemo
//
//

#import "SDKWrapper.h"
//#import "SubAuthView.h"
//#import "CustomAlertViewController.h"

#import <UIKit/UIKit.h>
#import <SecurePortal/SPVPNClient.h>
#import "CLProgressHUD.h"
//#import <SecurePortal/LibSecIDLite.h>

//@class SPAlertView;

typedef void (^pendingLoginHandler)(BOOL result);

static SDKWrapper* sdkWrapperInstance = nil;

@interface SDKWrapper()<SPVPNClientDelegate>
@property (nonatomic, strong) SPVPNClient* secSdk;
@property (nonatomic, assign) BOOL loginCompleted;
@property (nonatomic, copy) pendingLoginHandler pendingHandler;

@property (nonatomic, strong) NSDictionary* nextAuthInfo;
@property (nonatomic, strong) NSDictionary* loginInfo;
@end

@implementation SDKWrapper

+ (SDKWrapper*)getInstance
{
    if (!sdkWrapperInstance)
    {
        @synchronized(self)
        {
            if (!sdkWrapperInstance)
            {
                sdkWrapperInstance = [[self alloc] init];
            }
        }
    }
    return sdkWrapperInstance;
}
/*
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSSLVPNSessionNotify:)
                                                     name:SPSDKSSLVPNTopicNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SPSDKSSLVPNTopicNotification
                                                  object:nil];
}

-(void)onSSLVPNSessionNotify:(NSNotification*)noti
{
    NSDictionary* dic = [noti object];
    NSLog(@"demo topic dic = %@", dic);
    NSLog(@"getProxy port = %ld", (long)[SPVPNClient queryProxyPort]);
}
*/
- (void)runWithParams:(NSDictionary*)params responseHandler:(void (^)( BOOL result))responseHandler
{
    if(self.loginCompleted)
    {
        [self stop];
    }
    [[CLProgressHUD sharedInstance] showWithTip:@"正在进行安全认证..."];
    self.pendingHandler = responseHandler;
    self.loginInfo = params;
    
//    //注：如果只有nc业务，检查nc的状态，如果nc进程还在运行，可以不需要重新登录
//    [SPVPNClient queryNCStatus:^(SPNCStatus status) {
//        if(status != SPNCStatusConnected)
//        {
//            //do vpn login and then start nc
//            self.secSdk = [SPVPNClient login:params listener:self];
//        }
//        else
//        {
//            if(self.pendingHandler)
//            {
//                self.pendingHandler(YES);
//                self.pendingHandler = nil;
//            }
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"信息"
//                                                            message:@"NC已经连接"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"关闭"
//                                                  otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }];
    
    self.secSdk = [SPVPNClient login:params listener:self];
}

- (void)stop
{
    if(self.pendingHandler)
    {
        self.pendingHandler(NO);
        self.pendingHandler = nil;
    }
    
    self.loginCompleted = NO;
    
    if(self.secSdk)
    {
        [self.secSdk logOut];
        
        //如果启动了nc，关闭nc
        [self.secSdk stopNC];
        
        //注销自定义的http代理协议
        [SPVPNClient unregisterHttpProxyProtocol];
        
        //CFSocket, CFStream停止自动设置代理
        [SPVPNClient stopAutoSetProxyCFNetwork];
        
        self.secSdk = nil;
    }
}

- (BOOL)isConnected
{
    return self.loginCompleted;
}

- (NSArray*)getServiceList
{
    if(self.secSdk)
    {
        return [self.secSdk getServicesArray];
    }
    return nil;
}

- (NSInteger)queryHttpProxyPort
{
    return [SPVPNClient queryProxyPort];
}

- (NSInteger)queryMappingPortWithHost:(NSString*)host port:(NSInteger)port
{
    return [SPVPNClient queryProxyPortWithHost:host port:port];
}
/*
#pragma mark - multi auth

#pragma mark update next auth values

- (NSDictionary*)updateAuthInfo:(NSDictionary*)authInfo forValues:(NSArray*)inValues
{
    NSMutableDictionary* replaceAuthInfo = [NSMutableDictionary dictionary];
    if([authInfo objectForKey:SPSDKSubAuthName])
    {
        [replaceAuthInfo setObject:[authInfo objectForKey:SPSDKSubAuthName] forKey:SPSDKSubAuthName];
    }
    
    if([authInfo objectForKey:SPSDKSubAuthRspID])
    {
        [replaceAuthInfo setObject:[authInfo objectForKey:SPSDKSubAuthRspID] forKey:SPSDKSubAuthRspID];
    }
    if([authInfo objectForKey:SPSDKSubAuthType])
    {
        [replaceAuthInfo setObject:[authInfo objectForKey:SPSDKSubAuthType] forKey:SPSDKSubAuthType];
    }
    if([authInfo objectForKey:SPSDKSubAuthDesc])
    {
        [replaceAuthInfo setObject:[authInfo objectForKey:SPSDKSubAuthDesc] forKey:SPSDKSubAuthDesc];
    }
    
    NSMutableArray* updateValues = [NSMutableArray arrayWithCapacity:2];
    NSArray* values = [authInfo objectForKey:SPSDKSubAuthNeedValues];
    for (NSDictionary* aValue in values)
    {
        for(NSDictionary* inValue in inValues)
        {
            if([[aValue objectForKey:SPSDKSubAuthNeedValueKey] isEqualToString:[inValue objectForKey:SPSDKSubAuthNeedValueKey]])
            {
                NSDictionary* fillDic = @{
                                          SPSDKSubAuthNeedValueKey : [inValue objectForKey:SPSDKSubAuthNeedValueKey],
                                          SPSDKSubAuthNeedValue : [inValue objectForKey:SPSDKSubAuthNeedValue]
                                          };
                [updateValues addObject:fillDic];
            }
        }
    }
    [replaceAuthInfo setObject:updateValues forKey:SPSDKSubAuthNeedValues];
    
    return replaceAuthInfo;
}

#pragma mark call QianxinID totp

- (void)doTotpSubAuthWithAuthInfo:(NSDictionary*)authInfo
{
    __weak __typeof(self) weakSelf = self;
    LibSecIDLite* totpLite = [[LibSecIDLite alloc] init];
    [totpLite getTOTPCompletion:^(NSDictionary *result, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error == nil)
        {
            if(result)
            {
                NSDictionary* fillDic = @{ SPSDKSubAuthNeedValueKey : @"totp",
                                           SPSDKSubAuthNeedValue : [result objectForKey:@"totp"] };
                NSArray* fillValues = [NSArray arrayWithObject:fillDic];
                NSDictionary* nextAuthDic = [strongSelf updateAuthInfo:authInfo forValues:fillValues];
                strongSelf.secSdk = [SPVPNClient login:nextAuthDic listener:self];
            }
        }
        else
        {
            [strongSelf showErrorAlert:error.localizedDescription];
        }
    }];
}

- (void)doTotpMainAuthWithAuthInfo
{
    __weak __typeof(self) weakSelf = self;
    LibSecIDLite* totpLite = [[LibSecIDLite alloc] init];
    [totpLite getTOTPCompletion:^(NSDictionary *result, NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(error == nil)
        {
            if(result)
            {
                NSString* totp = [result objectForKey:@"totp"];
                NSMutableDictionary* totpLoginParams = [NSMutableDictionary dictionaryWithDictionary:self.loginInfo];
                [totpLoginParams setObject:totp forKey:@"totp"];
                [totpLoginParams setObject:[NSNumber numberWithInteger:SPAuthModeTotp] forKey:@"auth_mode"];
                strongSelf.secSdk = [SPVPNClient login:totpLoginParams listener:self];
            }
        }
        else
        {
            [strongSelf showErrorAlert:error.localizedDescription];
        }
    }];
}

#pragma mark call QianxinID qrcode auth

- (void)doQrCodeAuthWithQrcodeString:(NSString*)qrcodeString
                            authInfo:(NSDictionary*)authInfo
{
    __weak __typeof(self) weakSelf = self;
    LibSecIDLite* oneClickLoginApi = [[LibSecIDLite alloc] init];
    [oneClickLoginApi authorizeAppQRCode:qrcodeString loginParams:nil
                        getAppInfoHander:^(NSDictionary *info, NSError *error) {
                            __strong __typeof(self) strongSelf = weakSelf;
                            if(error == nil) {
                                NSLog(@"auth successed");
                                strongSelf.secSdk = [SPVPNClient login:authInfo listener:self];
                            }
                            else {
                                if([error.domain isEqualToString:@"SecIDSDK"] && error.code == 1000) {
                                    //[strongSelf downloadSecIDAlertWithURL:[error.userInfo objectForKey:@"SecIDDownloadURL"]];
                                }
                                else if([error.domain isEqualToString:@"SecIDSDK"] && error.code == 1001) {
                                    NSLog(@"auth cancel");
                                    [strongSelf showErrorAlert:error.localizedDescription
                                                       okTitle:@"重新授权"
                                                   cancelTitle:@"取消"
                                                     okHandler:^(UIAlertAction *action) {
                                                         [strongSelf doRequestQRAuthCodeAuthInfo:authInfo];
                                                     } cancelHandler:nil];
                                }
                                else
                                {
                                    [strongSelf showErrorAlert:error.localizedDescription
                                                       okTitle:@"重新授权"
                                                   cancelTitle:@"取消"
                                                     okHandler:^(UIAlertAction *action) {
                                                         [strongSelf doRequestQRAuthCodeAuthInfo:authInfo];
                                                     } cancelHandler:nil];
                                }
                            }
                        }];
}


- (void)doRequestQRAuthCodeAuthInfo:(NSDictionary*)authInfo
{
    NSDictionary* reqQrcodeAuthInfo = nil;
    if(authInfo)
    {
        //如果不为主认证 reqQrcodeAuthInfo 为authInfo
        if([authInfo objectForKey:SPSDKSubAuthRspID] &&
           [[authInfo objectForKey:SPSDKSubAuthRspID] integerValue] != 0)
        {
            reqQrcodeAuthInfo = authInfo;
        }
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.secSdk requestQRAuthCodeInfoParams:reqQrcodeAuthInfo
                                 complection:^(NSDictionary* qrAuthInfo, NSString* qrcodeStr) {
                                     if(qrAuthInfo) {
                                         __strong __typeof(self) strongSelf = weakSelf;
                                         [strongSelf doQrCodeAuthWithQrcodeString:qrcodeStr
                                                                         authInfo:qrAuthInfo];
                                     }
                                 }];
}

- (void)showNextAuthAlertWithMessage:(NSString*)message
{
    if(!self.nextAuthInfo)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        __weak __typeof(self) weakSelf = self;
        NSString* alertMessage = [self.nextAuthInfo objectForKey:SPSDKSubAuthDesc];
        if(message)
        {
            alertMessage = [NSString stringWithFormat:@"%@,%@", alertMessage, message];
        }
        CustomAlertViewController* alert = [CustomAlertViewController alertViewController];
        
        SubAuthView* authView = [[SubAuthView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 100.0f)];
        authView.backgroundColor = [UIColor clearColor];
        [authView setMessage:alertMessage];
        authView.authInfo = self.nextAuthInfo;
        [alert addCustomView:authView];

        authView.doSubAuthBlock = ^(SubAuthView *sender, NSDictionary *authInfo, NSArray* values)
        {
            __strong __typeof(self) strongSelf = weakSelf;
            NSInteger authType = [[authInfo objectForKey:SPSDKSubAuthType] integerValue];
            if(authType == SPNextAuthQRCodeGetQrData)
            {
                [strongSelf doRequestQRAuthCodeAuthInfo:authInfo];
            }
            else
            {
                NSDictionary* nextAuthDic = [strongSelf updateAuthInfo:authInfo forValues:values];
                strongSelf.secSdk = [SPVPNClient login:nextAuthDic listener:self];
            }
        };

        authView.doSubAuthError = ^(SubAuthView* sender, NSString* errorMsg)
        {
            [self showErrorAlert:errorMsg handler:^(UIAlertAction *action) {
                __strong __typeof(self) strongSelf = weakSelf;
                [strongSelf showNextAuthAlertWithMessage:nil];
            }];
        };

        [alert addButtonTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert addButtonTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             [authView authButtonClicked:nil];
        }];
        
        [alert showInViewController:[self topShowViewController]];
    });
}

- (void)doNextAuthWithAuthInfo:(NSDictionary*)authInfo
{
    if(self.nextAuthInfo)
    {
        self.nextAuthInfo = nil;
    }
    self.nextAuthInfo = authInfo;
    
    [self showNextAuthAlertWithMessage:nil];
}
*/
#pragma mark - SPVPNClientDelegate

- (void)didLoginSuccess
{
    NSLog(@"didLoginSuccess");
    NSLog(@"getServiceList = %@", [self getServiceList]);
    [[CLProgressHUD sharedInstance] hide];
    //需要ios9.0以上的系统
    //需要创建NC插件，参看的demo的 PacketTunnel
    //start nc
    //[self.secSdk startNC:nil];
//    NSDictionary *pluginParams = @{ @"vpnplugin_name": @"VPNTunnel",
//                                    @"vpnplugin_bundleId" : @"com.SdkDemo.PacketTunnelExt",
//                                    @"vpnplugin_max_reconnect" : [NSNumber numberWithInteger:-1],
//                                    };
    
//    NSDictionary *pluginParams = @{ @"vpnplugin_name": @"VPNTunnel",
//                                    @"vpnplugin_bundleId" : @"com.SdkDemo.PacketTunnelExt",
//                                    //@"enable_dns_gateway" : [NSNumber numberWithInt:1]
//                                  };
//    //如果不填写参数，这时会使用默认的设置，参考SDK文档
//    [self.secSdk startNC:pluginParams];
    
    //注册自定义的http代理协议，NSURLRequest, NSURLSession和webview自动使用代理,AFNetwork, ASIHttpRequest 都会自动使用代理
    //如果自己设置代理，不需要注册如下的http代理协议
    [SPVPNClient registerHttpProxyProtocol];
    
    //自动给CFSocket, CFStream设置代理
    [SPVPNClient startAutoSetProxyCFNetwork];
    
    self.loginCompleted = YES;
    
    if(self.pendingHandler)
    {
        self.pendingHandler(YES);
        self.pendingHandler = nil;
    }
    
//    [self showErrorAlert:@"VPN连接成功"];
}

- (void)onLoginErrorID:(NSInteger)errid msg:(NSString*)errmsg
{
    NSLog(@"onLoginErrorID errmsg = %@", errmsg);
    [[CLProgressHUD sharedInstance] hide];
    self.loginCompleted = NO;
    
    if(self.pendingHandler)
    {
        self.pendingHandler(NO);
        self.pendingHandler = nil;
    }
    
//    [self showErrorAlert:errmsg];
}

- (void)onRuntimeErrorID:(NSInteger)errid msg:(NSString*)errmsg
{
    //if((errorCode & 0x00FFFF)==0x0410) 用户已经离线
    NSLog(@"onRuntimeErrorID errmsg = %@", errmsg);
    [[CLProgressHUD sharedInstance] hide];
}

- (void)didLogoutCompleted
{
    [[CLProgressHUD sharedInstance] hide];
    NSLog(@"didLogoutCompleted");
}
/*
#pragma mark - SPVPNClientDelegate Do multi auth

- (void)onLoginDoNextAuth:(NSDictionary*)authInfo
{
    NSInteger authType = [[authInfo objectForKey:SPSDKSubAuthType] integerValue];
    //如果SPSDKSubAuthRspID为空，当前是主认证
    if(![authInfo objectForKey:SPSDKSubAuthRspID] ||
       [[authInfo objectForKey:SPSDKSubAuthRspID] integerValue] == 0)
    {
        if(authType == SPNextAuthTOTP)
        {
            [self doTotpMainAuthWithAuthInfo];
        }
        else if(authType == SPNextAuthQRCodeGetQrData)
        {
            [self doRequestQRAuthCodeAuthInfo:authInfo];
        }
        else
        {
            [self doNextAuthWithAuthInfo:authInfo];
        }
    }
    else
    {
        if(authType == SPNextAuthTOTP)
        {
            [self doTotpSubAuthWithAuthInfo:authInfo];
        }
        else if(authType == SPNextAuthQRCodeGetQrData)
        {
            [self doRequestQRAuthCodeAuthInfo:authInfo];
        }
        else 
        {
            [self doNextAuthWithAuthInfo:authInfo];
        }
    }
}

- (void)onLoginDoNextAuthErrorID:(NSInteger)errid msg:(NSString*)errmsg
{
    [self showErrorAlert:errmsg];
}

#pragma mark alert view

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else
    {
        return rootViewController;
    }
}

- (UIViewController*)topShowViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)showErrorAlert:(NSString*)errmsg
{
    UIAlertController* alertview = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:errmsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertview addAction:defult];
    
    [[self topShowViewController] presentViewController:alertview animated:YES completion:nil];
}

- (void)showErrorAlert:(NSString*)errmsg
               handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController* alertview = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:errmsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:handler];
    [alertview addAction:defult];
    
    [[self topShowViewController] presentViewController:alertview animated:YES completion:nil];
}

- (void)showErrorAlert:(NSString*)errmsg
               okTitle:(NSString*)okTitle
           cancelTitle:(NSString*)cancelTitle
             okHandler:(void (^)(UIAlertAction *action))okHandler
         cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
{
    UIAlertController* alertview = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:errmsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:okTitle?okTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:okHandler];
    [alertview addAction:okAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle?cancelTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:okHandler];
    [alertview addAction:cancelAction];
    
    [[self topShowViewController] presentViewController:alertview animated:YES completion:nil];
}
 */

@end
