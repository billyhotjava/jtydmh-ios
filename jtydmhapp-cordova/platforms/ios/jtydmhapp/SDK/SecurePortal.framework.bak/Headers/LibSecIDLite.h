//
//  LibSecIDLite.h
//  SecIDSDK
//
//  Created by HalloWorld on 2016/10/25.
//  Copyright © 2016年 legendsec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibSecIDLite : NSObject

///**
// 登录SecID (Login SecID)
//
// 参数 (parameter)
// params:登录的参数 (login params)
//    NSDictionary *params = @{
//    @"host"      : @"SecID网关的域名或IP",
//    @"port"      : @"SecID网关的端口，默认为443",
//    @"username" : @"登录用户名",
//    @"password" : @"登录密码",
//    };
// completion:如果登录成功error为nil
//
// */
-(void)login:(NSDictionary *)params
  completion:(void (^)(NSDictionary* result, NSError* error))completion;

///**
// 登出 SecID (logout SecID)
//
// */
-(void)logout:(void(^)(NSError* error))completion;


///**
// 获取动态口令 (get totp token)
//
// */

-(void)getTOTPCompletion:(void(^)(NSDictionary* result, NSError* error))completionHandler;


///**
// 获取动态口令 (get totp token)
// 参数 (parameter)
// params:如下所示
//  appName :获取动态口令App的名称
//  appIcon :获取动态口令App的图标
// */

-(void)getTOTPWithAppName:(NSString*)appName
                  appIcon:(UIImage*)appIcon
               completion:(void(^)(NSDictionary* result, NSError* error))completionHandler;


///**
// 获取动态口令 (get totp token)
// 参数 (parameter)
// params:如下所示
//  appName :获取动态口令App的名称
//  appIcon :获取动态口令App的图标
// loginParams:如下所示
// NSDictionary *params = @{
//  @"host"         : @"SecID网关的域名或IP",
//  @"port"         : @"SecID网关的端口，默认为443",
//  @"username"     : @"登录用户名"
//  };
// */

-(void)getTOTPWithAppName:(NSString*)appName
                  appIcon:(UIImage*)appIcon
              loginParams:(NSDictionary*)loginParams
               completion:(void(^)(NSDictionary* result, NSError* error))completionHandler;


///**
// 授权应用 (authorize app)
// 参数 (parameter)
// code:扫描获取或输入的二维码信息
// params:如下所示
// NSDictionary *params = @{
//  @"app_username"     : @"授权App用户名",
//  @"app_password"     : @"授权App密码",
//  };
// 用户名，密码没有可以不填，或填@“”
// 如果没有参数，params可以填nil,
// */

- (void)authorizeAppQRCode:(NSString*)code
               loginParams:(NSDictionary* _Nullable)params
          getAppInfoHander:(void (^)(NSDictionary* info, NSError* error))handler;


///**
// 获取应用授权码 (get authorize code)
// 参数 (parameter)
// bundleId:要授权的app的bundleID
// params:如下所示
// NSDictionary *params = @{
//  @"host"     : @"域名或IP",
//  @"port"     : @"端口",
//  @"username" : @"用户名",
//  };
// 用户名，密码没有可以不填，或填@“”
// 如果没有参数，params可以填nil,
// popup:是否弹出确认框
// */

- (void)getLaunchAuthCode:(NSString*)bundleId
                   params:(NSDictionary* _Nullable)params
                    popup:(BOOL)popup
               completion:(void (^)(NSDictionary* info, NSError* error))completionHandler;


///**
// 获取一个或多个 App AuthCode (App Auth QRCode)
//
// */
// 参数 (parameter)
// bundleids:一个或多个app的bundleid
//如里
//(
//    "com.legendsec.app1",
//    "com.legendsec.app1"
//)
// params:如下所示
// NSDictionary *params = @{
//  @"host"     : @"域名或IP",
//  @"port"     : @"端口",
//  @"username" : @"用户名",
//  };
// 用户名，密码没有可以不填，或填@“”
// 如果没有参数，params可以填nil,
// popup:是否弹出确认框
// completionHandler
// error:请求结果，如果为nil请求AuthCode成功 (request AuthCode result)
// authInfo:包含token和leftTime
// 如果返回了leftTime， leftTime是token的有效剩余时间
// 下面是返回的authInfo的例子
//{
//    "com.legendsec.app2" : {
//        "token" : "222222",
//        "leftTime" : "30"
//    },
//    "com.legendsec.app1" : {
//        "token" : "111111",
//        "leftTime" : "30"
//    }
//}
//
- (void)getAuthCodeWithAppBundleIds:(NSArray*)bundleids
                             params:(NSDictionary* _Nullable)params
                              popup:(BOOL)popup
                  completionHandler:(void(^)(NSDictionary* authInfo, NSError* error))completionHandler;

///**
// 取消操作 (cancel opration)
//
// */

-(void)cancel;


///** 处理通过URL启动App时传递的数据
//
// 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
// @param url 第三方应用时传递过来的URL
// @return 成功返回YES，失败返回NO。
// */

+(BOOL)handleOpenURL:(NSURL *)url;

///**
// 设需要调用获取动态口令App的 URLSccheme
//
// */
+(void)setSecIDURLScheme:(NSString*)urlScheme;

///**
// 设需动态口令App的显示名称
//
// */
+(void)setProductDisplayName:(NSString*)name;

///**
// 设需动态口令App的下载地址
//
// */
+(void)setDownloadURL:(NSString*)urlString;

@end

NS_ASSUME_NONNULL_END
