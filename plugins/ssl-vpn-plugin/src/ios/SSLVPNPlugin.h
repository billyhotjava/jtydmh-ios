//
//  SSLVPNPlugin.h
//  CordovaTest
//
//  Created by eccl on 2021/6/25.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLVPNPlugin : CDVPlugin

/// VPN 登录接口
/// @param command  Cordova 入参
/// vpn_host
/// vpn_port
/// auth_server
/// auth_username
/// auth_password
- (void)loginVPN:(CDVInvokedUrlCommand *)command;

/// VPN 登出接口
- (void)logoutVPN:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
