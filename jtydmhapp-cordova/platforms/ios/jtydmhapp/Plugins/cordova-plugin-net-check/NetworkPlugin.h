//
//  NetworkPlugin.h
//  CordovaTest
//
//  Created by eccl on 2022/1/4.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkPlugin : CDVPlugin

/// 检测网络是否为国神内网
- (void)netType:(CDVInvokedUrlCommand *)command;

/// 检测是否有网络     1 有网络   0 无网络
- (void)checkNetworkAvailable:(CDVInvokedUrlCommand *)command;

/// 准入管理，需忽略准入服务的自签证书，并请求返回数据给前端
/// @param command  Cordova 入参
/// deviceType
/// uniqueCode
/// employeeCode
- (void)access:(CDVInvokedUrlCommand *)command;

/// 检查更新，需忽略检查更新内网服务的自签证书，并请求返回数据给前端
/// @param command  Cordova 入参
/// deviceType
/// needDialog
/// @param command Cordova 回调内容
/// success     包括字段 [success] 已是最新版本   [文字提示] 有更新但处在内网     [cancel] 用户取消更新
/// error           包括字段 [文字提示] 有强制更新但处在内网
- (void)update:(CDVInvokedUrlCommand *)command;

/// 切换网络监听
- (void)checkNetworkDialog:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
