//
//  NotificationPlugin.h
//  CordovaTest
//
//  Created by eccl on 2021/7/13.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

/// 接收到远程推送通知
extern NSString *const kDidReceiveRemoteNotification;
/// 接收到本地通知
extern NSString *const kDidReceiveLocalNotification;

@interface NotificationPlugin : CDVPlugin


/// 注册通知（在页面）[包括本地通知 及 远程推送通知]
/// @param command  Cordova 封装结果对象
- (void)registerNotification:(CDVInvokedUrlCommand *)command;

/// 发送通知
/// @param command  Cordova 封装结果对象      点击本地通知后，将通知信息回调给 Cordova 前端页面
- (void)sendNotification:(CDVInvokedUrlCommand *)command;

/// 接收到远程推送通知的回调
/// @param command  Cordova 封装结果对象      点击远程推送通知后，将通知信息回调给 Cordova 前端页面
- (void)didReceiveRemoteNotification:(CDVInvokedUrlCommand *)command;

/// 切换登录状态
/// @param command  [in] BOOL 登录状态；NSString vpn账号；NSString  vpn密码; NSString guoShenAccessToken 国神token;  Cordova 封装结果对象      登录状态改变后，修改原生登录状态值（影响通知被点击后的流程）
- (void)changeLoginStatus:(CDVInvokedUrlCommand *)command;


/// 程序由后台切换至前台，并达到验证手势密码时间，需要跳转手势密码页面
/// @param command  Cordova 封装结果对象      跳转手势密码页面
- (void)applicationDidBecomeActiveShouldGestureVerify:(CDVInvokedUrlCommand *)command;

/// 重置需要手势密码验证的时间
/// @param command Cordova 封装结果对象       重置手势密码验证的时间计算
- (void)resetGestureVerifyTime:(CDVInvokedUrlCommand *)command;

/// 原生给前端传递数据
/// @param command Cordova 封装结果对象       原生的网络检测为无网络时，点击进入离线，通知给前端跳转到离线应用页面
- (void)nativeToVueTransmitMessages:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
