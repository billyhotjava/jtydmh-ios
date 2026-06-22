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
/// @param command  Cordova 封装结果对象      登录状态改变后，修改原生登录状态值（影响通知被点击后的流程）
- (void)changeLoginStatus:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
