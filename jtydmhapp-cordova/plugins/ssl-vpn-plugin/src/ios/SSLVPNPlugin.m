//
//  SSLVPNPlugin.m
//  CordovaTest
//
//  Created by eccl on 2021/6/25.
//

#import "SSLVPNPlugin.h"
#import "SDKWrapper.h"

@implementation SSLVPNPlugin

- (void)loginVPN:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
//            NSLog(@"参数: %@", command.arguments);
            if (args && args.count == 5) {
                NSString *vpn_host = args.firstObject;
                NSString *vpn_port = args[1];
                NSString *auth_server = args[2];
                NSString *auth_username = args[3];
                NSString *auth_password = args.lastObject;
                NSDictionary *param = @{
                    @"vpn_host": vpn_host,
                    @"vpn_port": vpn_port,
                    @"auth_server": auth_server,
                    @"auth_username": auth_username,
                    @"auth_password": auth_password,
                    @"auth_mode": @0,
                    @"auth_autologin": @1
                };
                [[SDKWrapper getInstance] runWithParams:param responseHandler:^(BOOL result, NSString * _Nullable errorMessage) {
                    if(result) {
//                        NSLog(@"VPN Login Succees");
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"vpn 登录成功"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    } else {
//                        NSLog(@"VPN Login Fail");
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                }];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-vpnLogin: 方法入参个数不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (void)logoutVPN:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SDKWrapper getInstance] stop];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"安全认证登出成功"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
}

@end
