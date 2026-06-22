//
//  CLNotificationInstance.m
//  jtydmhapp
//
//  Created by eccl on 2021/10/8.
//

#import "CLNotificationInstance.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
#import "CLTimeManager.h"
#import "CLReachability.h"
#import "CLAPIClient.h"

@implementation CLNotificationInstance

+ (instancetype)sharedInstance {
    static CLNotificationInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CLNotificationInstance alloc] init];
        DLog("监听isLogin.................");
        [instance addObserver:instance forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew context:nil];
    });
    return instance;
}

//当key路径对应的属性值发生改变时，监听器就会回调自身的监听方法，如下
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)contex {
    if ([keyPath isEqualToString:@"isLogin"]) {
        BOOL oldValue = [[change objectForKey:@"old"] boolValue];
        BOOL newValue = [[change objectForKey:@"new"] boolValue];
        DLog(@"旧值: %@", [change objectForKey:@"old"]);
        DLog(@"新值: %@", [change objectForKey:@"new"]);
        // 登录成功
        if (oldValue == NO && newValue == YES) {
            DLog(@"登录成功");
            [[CLReachability sharedInstance] reachabilityWithPingHost:kPingGuoShenLANHost];
            if (CLNotificationInstance.sharedInstance.notification) {
                if([CLNotificationInstance.sharedInstance.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
                    DLog(@"CLNotificationInstance 远程推送通知");
                    // 设置远程通知点击回调的插件
                    DLog(@"CLNotificationInstance 发出 远程推送插件的通知");
                    NSDictionary * userInfo = CLNotificationInstance.sharedInstance.notification.request.content.userInfo;
                    NSMutableDictionary *newInfo = [userInfo mutableCopy];
                    [newInfo setValue:@([CLTimeManager sharedInstance].needGestureVerify) forKey:@"needGestureVerify"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveRemoteNotification" object:CLNotificationInstance.sharedInstance.notification userInfo:newInfo];
                    [JPUSHService handleRemoteNotification:CLNotificationInstance.sharedInstance.notification.request.content.userInfo];
                } else {
                    DLog(@"CLNotificationInstance 本地通知");
                    // 设置本地通知点击回调的插件
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveLocalNotification" object:CLNotificationInstance.sharedInstance.notification userInfo:nil];
                }
                CLNotificationInstance.sharedInstance.notification = nil;
            }
        } else {
            DLog(@"登出成功");
            [[CLReachability sharedInstance] stopNotifier];
        }
    }
}

@end
