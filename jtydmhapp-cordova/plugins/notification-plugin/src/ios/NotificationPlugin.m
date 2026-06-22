//
//  NotificationPlugin.m
//  CordovaTest
//
//  Created by eccl on 2021/7/13.
//

#import "NotificationPlugin.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"
#import "CLNotificationInstance.h"
#import "CLTimeManager.h"

/// 接收到远程推送通知
NSString *const kDidReceiveRemoteNotification = @"kDidReceiveRemoteNotification";
/// 接收到本地通知
NSString *const kDidReceiveLocalNotification = @"kDidReceiveLocalNotification";
//
NSString *const kApplicationDidBecomeActiveShouldGestureVerifyNotification = @"kApplicationDidBecomeActiveShouldGestureVerifyNotification";

@interface NotificationPlugin () <UNUserNotificationCenterDelegate>
/// 本地通知点击后回调的id
@property (nonatomic, copy) NSString *triggerNotificationCallbackId;
/// 原生传递给前端信息点击后回调的id
@property (nonatomic, copy) NSString *nativeToVueCallbackId;
/// 远程推送通知点击后回调的id
@property (nonatomic, copy) NSString *remoteNotificationCallbackId;
/// 程序切换至前台，通知需要跳转手势密码页面的回调的id
@property (nonatomic, copy) NSString *applicationDidBecomeActiveNotificationCallbackId;

@end

@implementation NotificationPlugin

// Notification Identifier
- (NSString *)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
     [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
     [dateFormatter setDateFormat:@"yyyy-MM-dd&HH:mm:ss.SSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)registerNotification:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"==== registerNotification ====");
            
            [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
                DLog(@"thread: %@", [NSThread currentThread]);
                if (status == JPAuthorizationStatusAuthorized) {
                    DLog(@"允许通知");
                    // 注册点击远程推送通知后的通知
                    DLog(@"注册 远程推送插件的通知");
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotificationWithInfo:) name:kDidReceiveRemoteNotification object:nil];
                    
                    // 注册点击本地通知后的通知
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalNotificationWithInfo:) name:kDidReceiveLocalNotification object:nil];
                    
                    // 注册程序切换至前台，达到手势验证的时间，需要跳转手势密码界面的通知
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveShouldGestureVerifyNotification) name:kApplicationDidBecomeActiveShouldGestureVerifyNotification object:nil];
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"已授权通知权限"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else if (status == JPAuthorizationStatusDenied) {
                    DLog(@"通知被禁止");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] message:@"您已关闭了通知权限，将会错过很多重要信息，是否要打开通知？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [JPUSHService openSettingsForNotification:^(BOOL success) {
                            DLog(@"open notification auth settings %@", success ? @"success" : @"failed");
                            if (!success) {
                                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知权限已被禁止"];
                                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                            }
                        }];
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知权限已被禁止"];
                        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                    }]];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    DLog(@"未授权通知");
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"通知权限未授权: %lu", (unsigned long)status]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
             }];
        });
    }];
}

- (void)sendNotification:(CDVInvokedUrlCommand *)command {
    self.triggerNotificationCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== sendNotification ====");
            NSArray *args = command.arguments;
            if (args && args.count >= 3) {
                JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
                content.title = args.firstObject;
//                content.subtitle = @"";
                content.body = args[1];
//                  content.badge = @1;
                content.categoryIdentifier = args[2];
                
                JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
                trigger.timeInterval = 1.0;
                
                JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
                NSString *userNotificationIdentifier = [self getCurrentDate];
                request.requestIdentifier = userNotificationIdentifier;
                request.content = content;
                request.trigger = trigger;
                request.completionHandler = ^(id result) {
                    DLog(@"推送成功, result: %@", result);
                };
                [JPUSHService addNotification:request];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数个数不正确"];
                //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
                // [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (void)didReceiveRemoteNotification:(CDVInvokedUrlCommand *)command {
    self.remoteNotificationCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"==== didReceiveRemoteNotification ====");
        });
    }];
}

- (void)changeLoginStatus:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== changeLoginStatus ====");
            NSArray *args = command.arguments;
            BOOL result = NO;
            NSString *userCode = nil;
            NSString *vpn_password = nil;
            NSString *guoShenAccessToken = nil;
            NSString *userName = nil;
            NSString *phoneNumber = nil;
            if (args && args.count >= 6) {
                // 登录状态 BOOL
                result = [args.firstObject boolValue];
                userCode = args[1];
                vpn_password = args[2];
                guoShenAccessToken = args[3];
                userName = args[4];
                phoneNumber = args[5];
            }
//            DLog(@"changeLogin Status: %d", result);
            [CLNotificationInstance sharedInstance].isLogin = result;
            [CLNotificationInstance sharedInstance].userCode = userCode;
            [CLNotificationInstance sharedInstance].vpn_password = vpn_password;
            [CLNotificationInstance sharedInstance].guoShenAccessToken = guoShenAccessToken;
            [CLNotificationInstance sharedInstance].userName = userName;
            [CLNotificationInstance sharedInstance].phoneNumber = phoneNumber;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"已获取登录状态"];
            //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
            // [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
}

- (void)applicationDidBecomeActiveShouldGestureVerify:(CDVInvokedUrlCommand *)command {
    self.applicationDidBecomeActiveNotificationCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"==== 程序切换至前台，需要验证手势密码 ====");
        });
    }];
}

- (void)resetGestureVerifyTime:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CLTimeManager sharedInstance] reset];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"重置手势密码计时时间成功"];
            //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
            // [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
}

- (void)nativeToVueTransmitMessages:(CDVInvokedUrlCommand *)command {
    self.nativeToVueCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

#pragma mark - NSNotificationCenter

/// 远程推送通知点击后的回调
- (void)didReceiveRemoteNotificationWithInfo:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
//    DLog(@"remoteNotification.request.content.userInfo: %@", userInfo);
    if (userInfo) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&error];
        NSString *messageAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:messageAsString];
        //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
        // [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.remoteNotificationCallbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知消息传递失败"];
        //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
        // [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.remoteNotificationCallbackId];
    }
    
}

/// 本地通知点击后的回调
- (void)didReceiveLocalNotificationWithInfo:(NSNotification *)notification {
    if ([notification.object isKindOfClass:NSDictionary.class]) {
        NSDictionary *info = notification.object;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
        // [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.nativeToVueCallbackId];
    } else {
        UNNotification *localNotification = notification.object;
        if (localNotification) {
            // 点击通知事件回调
            NSString *identifier = localNotification.request.content.categoryIdentifier;
            NSString *title = localNotification.request.content.title;
            NSString *body = localNotification.request.content.body;
            NSDictionary *notificationInfo = @{
                @"identifier": identifier,
                @"title": title,
                @"body": body
            };
    //        NSError *error = nil;
    //        NSData *data = [NSJSONSerialization dataWithJSONObject:notificationInfo options:NSJSONWritingPrettyPrinted error:&error];
    //        NSString *messageAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:messageAsString];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:notificationInfo];
            //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
            // [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.triggerNotificationCallbackId];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知消息传递失败"];
            //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
            // [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.triggerNotificationCallbackId];
        }
    }
}

// 注册程序切换至前台，达到手势验证的时间，需要跳转手势密码界面的通知
- (void)applicationDidBecomeActiveShouldGestureVerifyNotification {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[@([CLTimeManager sharedInstance].needGestureVerify) stringValue]];
    //将 CDVPluginResult.keepCallback 设置为 true ,则不会销毁callback
    // [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.applicationDidBecomeActiveNotificationCallbackId];
}

@end
