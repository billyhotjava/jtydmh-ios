//
//  CLVPNManager.h
//  jtdgdw
//
//  Created by eccl on 2020/8/25.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SecurePortal/SPVPNClient.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Completion)(BOOL success, NSString * __nullable errorMessage);

@interface CLVPNManager : NSObject

/// 登录回调
@property (nonatomic, copy) Completion connectCompletion;
/// 登出回调
@property (nonatomic, copy) Completion disconnectCompletion;

+ (instancetype)sharedInstance;

/// VPN账号密码登录
- (void)loginWithAccount:(NSString *)account password:(NSString *)password;

/// 查询 HTTP 代理端口
- (NSInteger)queryHttpProxyPort;

/// 退出VPN
- (void)logout;

@end

NS_ASSUME_NONNULL_END
