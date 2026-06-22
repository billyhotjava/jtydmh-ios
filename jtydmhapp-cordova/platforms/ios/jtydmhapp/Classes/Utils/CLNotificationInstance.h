//
//  CLNotificationInstance.h
//  jtydmhapp
//
//  Created by eccl on 2021/10/8.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLNotificationInstance : NSObject

/// 远程/本地通知，未登录状态时暂存；当登录成功后，通过 Cordova 传递到前端（适用于点击通知后的情况）
@property (nonatomic, strong) UNNotification * __nullable notification;
/// 是否登录成功
@property (nonatomic) BOOL isLogin;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *vpn_password;
@property (nonatomic, copy) NSString *guoShenAccessToken;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
