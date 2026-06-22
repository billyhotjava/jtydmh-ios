/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  jtydmhapp
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CLReachability.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#import <UserNotifications/UserNotifications.h>
#import "Utils/CLNotificationInstance.h"
#import "Utils/CLTimeManager.h"
//#import <HarmonyCloudiOSSDK/HarmonyCloud.h>
#import "CLAPIClient.h"
//#import "Utils/CLScreenshotAlert/CLScreenshotAlertView.h"
#import "CLJailbreakDetectTool.h"
#import <Bugly/Bugly.h>

static NSString *const BuglyAppID = @"199df54e07";

@interface AppDelegate () <JPUSHRegisterDelegate>

@end


@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    DLog(@"忽略证书认证 Appdelegate");
    return YES;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [Bugly startWithAppId:BuglyAppID];
    [[CLReachability sharedInstance] reachabilityWithPingHost:kPingGuoShenLANHost];
    
    //Required 初始化 APNs
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
#ifdef DEBUG
    [JPUSHService setDebugMode];
#endif
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    //    @param launchingOption 启动参数.
    //    * @param appKey 一个JPush 应用必须的,唯一的标识. 请参考 JPush 相关说明文档来获取这个标识.
    //    * @param channel 发布渠道. 可选.
    //    * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
    //    *                     App 证书环境取决于profile provision的配置，此处建议与证书环境保持一致.
    //    * @param advertisingId 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
    DLog(@"kIsProduction: %d", kIsProduction);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        DLog(@"极光推送服务注册成功，获取 RegistrationID %@, resCode: %d", registrationID, resCode);
        if (resCode == 0 && IsAvailableString(registrationID)) {
            [[NSUserDefaults standardUserDefaults] setValue:registrationID forKey:kJPushRegistrationID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            DLog(@"获取 RegistrationID 失败, resCode: %d", resCode);
        }
    }];
    
    // 服务端传递的 Extras 附加字段
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [self checkJailbreak];
    
    // 监听截屏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenshotNotification) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:kJPushChannel apsForProduction:kIsProduction advertisingIdentifier:nil];
    self.viewController = [[MainViewController alloc] init];
    
    /*
    // 以下代码要确保加在这个方法的最后面
    HarmonyCloudConfig *config = HarmonyCloudConfig.new;
    // app key, HarmonyCloud为当前app提供的key
    config.appKey = @"DE80C4566CE9256F01166A81B175EBBD6AE463E280A84E38800A1EFEEF34DD8F62EA6A8E61F531D6D64AFE553158D735";
    // 接收数据的URL, HarmonyCloud会提供
    config.host = @"http://apmapp.sgeg.ceic.com";
    // 启动监控
    [HarmonyCloud.sharedInstance startWithConfig:config];
    */
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)checkJailbreak {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL result = [CLJailbreakDetectTool detectCurrentDeviceIsJailbroken];
        if (result) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"风险提示" message:@"检测到该App有被修改的风险，请卸载后联系管理员重新下载。" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                abort();
            }]];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DLog(@"did 进入前台");
    if (CLNotificationInstance.sharedInstance.isLogin) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        if ([CLTimeManager sharedInstance].needGestureVerify) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kApplicationDidBecomeActiveShouldGestureVerifyNotification" object:nil];
        } else {
            DLog(@"未达到手势密码时间，不验证");
        }
    } else {
        DLog(@"未登录，不验证");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    DLog(@"did 进入后台");
    if (CLNotificationInstance.sharedInstance.isLogin) {
        [[CLTimeManager sharedInstance] startCalculateTime];
    } else {
        DLog(@"未登录，不计时");
    }
}


/*
 "_j_business" = 1;
    "_j_data_" = "{\"data_msgtype\":1,\"push_type\":8,\"is_vip\":0}";
    "_j_msgid" = 38280873707581492;
    "_j_uid" = 59255962617;
    appInfo = "{ \t\"name\": \"\U751f\U4ea7\U65e5\U62a5\", \t\"category\": \"1\", \t\"appPath\": \"/rb\", \t\"appUrl\": null, \t\"authType\": null, \t\"nameElementId\": null, \t\"passwordElementId\": null, \t\"androidEntrance\": null, \t\"iosEntrance\": null, \t\"isUnifiedAuthentication\": null, \t\"createTime\": null, \t\"updateTime\": null }";
    appParam = "{ \t\"data\": \"2021-12-17\", \t\"url\": \"dailyproductionreportdetail\" }";
    aps =     {
        alert =         {
            body = "\U60a8\U6536\U5230\U4e00\U6761\U751f\U4ea7\U65e5\U62a5";
            title = "\U751f\U4ea7\U65e5\U62a5";
        };
        badge = 1;
        "interruption-level" = active;
        "mutable-content" = 1;
        sound = default;

 }
 */
// 获取 服务端传递的 Extras 附加字段
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    DLog(@"%s, userInfo: %@", __func__, userInfo);
}

/// 注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    DLog(@"JPush deviceToken: %@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}
/// 注册 APNs 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - UIApplicationUserDidTakeScreenshotNotification
- (void)takeScreenshotNotification {
//    [[CLScreenshotAlertView sharedInstance] checkNetwork];
//    WS(weakSelf)
//    CLAPIClient *client = [CLAPIClient sharedInstanceShortTimeOut];
//    client.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [client GET:CLAPIBaseNewGuoShenLANURL baseURLType:CLAPIBaseNewGuoShenLANURL parameters:nil animated:NO success:^(NSDictionary * _Nullable responseObject) {
//        DLog(@"截屏事件，网络可通，弹出反馈界面");
//        if (responseObject && [responseObject isKindOfClass:[NSData class]] && ((NSData *)responseObject).length > 0) {
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [weakSelf showtakeScreenAlert];
////            });
//        } else {
//            DLog(@"截屏事件，网络不通，不处理");
//        }
//    } failure:^(NSError * _Nonnull error) {
//        DLog(@"截屏事件，网络不通，不处理");
//    }];
}

- (void)showtakeScreenAlert {
//    [[CLScreenshotAlertView sharedInstance] checkNetwork];
//    [[CLScreenshotAlertView sharedInstance] showScreenshotAlert];
//    WS(weakSelf)
//    CLAPIClient *client = [CLAPIClient sharedInstanceShortTimeOut];
//    client.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [client GET:CLAPIBaseNewGuoShenLANURL baseURLType:CLAPIBaseNewGuoShenLANURL parameters:nil animated:NO success:^(NSDictionary * _Nullable responseObject) {
//        if (responseObject && [responseObject isKindOfClass:[NSData class]] && ((NSData *)responseObject).length > 0) {
//            DLog(@"截屏事件，网络可通，弹出反馈界面");
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [weakSelf showtakeScreenAlert];
////            });
//        } else {
//            DLog(@"截屏事件，网络不通，不处理");
//        }
//    } failure:^(NSError * _Nonnull error) {
//        DLog(@"截屏事件，网络不通，不处理");
//    }];
}

/// APNs 通知回调
#pragma mark - JPushRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        DLog(@"从通知界面直接进入应用 %s", __func__);
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
        DLog(@"从通知设置界面进入应用 %s", __func__);
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    DLog(@"%s, response.notification.request.trigger: %@", __func__, notification.request.trigger);
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    } else {
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    DLog(@"%s, response.notification.request.trigger: %@", __func__, response.notification.request.trigger);
    /*
     判断是否登录成功
     1、未登录状态下，需要把 response.notification 保存；等登录成功后，前端调用 触发以下方法
     */
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSMutableDictionary *newInfo = [userInfo mutableCopy];
    [newInfo setValue:@([CLTimeManager sharedInstance].needGestureVerify) forKey:@"needGestureVerify"];
    DLog(@"response.notification.request.content: %@", response.notification.request.content);
    if (CLNotificationInstance.sharedInstance.isLogin) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            DLog(@"远程推送通知");
            // 设置远程通知点击回调的插件
            DLog(@"发出 远程推送插件的通知");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveRemoteNotification" object:response.notification userInfo:newInfo];
            [JPUSHService handleRemoteNotification:userInfo];
        } else {
            DLog(@"本地通知");
            // 设置本地通知点击回调的插件
            UNNotification *localNotification = response.notification;
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveLocalNotification" object:notificationInfo userInfo:nil];
            }
        }
    } else {
        // 未登录
        DLog(@"未登录，保存远程通知");
        CLNotificationInstance.sharedInstance.notification = response.notification;
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    DLog(@"%s", __func__);
    DLog(@"status: %lu, info: %@", (unsigned long)status, info);
}

@end
