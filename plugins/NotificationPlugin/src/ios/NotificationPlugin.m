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

/// 接收到远程推送通知
NSString *const kDidReceiveRemoteNotification = @"kDidReceiveRemoteNotification";
/// 接收到本地通知
NSString *const kDidReceiveLocalNotification = @"kDidReceiveLocalNotification";

@interface NotificationPlugin () <UNUserNotificationCenterDelegate>
/// 本地通知点击后回调的id
@property (nonatomic, copy) NSString *triggerNotificationCallbackId;
/// 远程推送通知点击后回调的id
@property (nonatomic, copy) NSString *remoteNotificationCallbackId;

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
                    DLog(@"🌰 注册 远程推送插件的通知");
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotificationWithInfo:) name:kDidReceiveRemoteNotification object:nil];
                    
                    // 注册点击本地通知后的通知
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalNotificationWithInfo:) name:kDidReceiveLocalNotification object:nil];
                    
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
            NSLog(@"==== sendNotification ====");
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
            NSLog(@"==== changeLoginStatus ====");
            NSArray *args = command.arguments;
            BOOL result = NO;
            if (args && args.count) {
                // 登录状态 BOOL
                result = [args.firstObject boolValue];
            }
            DLog(@"🍌 changeLogin Status: %d", result);
            [CLNotificationInstance sharedInstance].isLogin = result;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"已获取登录状态"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
}

#pragma mark - NSNotificationCenter

/// 远程推送通知点击后的回调
- (void)didReceiveRemoteNotificationWithInfo:(NSNotification *)notification {
    UNNotification *remoteNotification = notification.object;
    DLog(@"🍎 remoteNotification.request.content: %@", remoteNotification.request.content);
    DLog(@"🍎 remoteNotification.request.content.userInfo: %@", remoteNotification.request.content.userInfo);
    if (remoteNotification) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:remoteNotification.request.content.userInfo options:NSJSONWritingPrettyPrinted error:&error];
        NSString *messageAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:messageAsString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.remoteNotificationCallbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知消息传递失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.remoteNotificationCallbackId];
    }
    
}

/// 本地通知点击后的回调
- (void)didReceiveLocalNotificationWithInfo:(NSNotification *)notification {
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
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.triggerNotificationCallbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"通知消息传递失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.triggerNotificationCallbackId];
    }
}

@end
