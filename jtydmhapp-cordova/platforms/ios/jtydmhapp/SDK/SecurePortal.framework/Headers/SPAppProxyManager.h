//
//  SPAppProxyManager.h
//  SecurePortal
//
//  Created by wangyj on 2019/5/15.
//  Copyright © 2019 legendsec. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPAppProxyManager : NSObject

///**
// 如果配置了App GroupID, 设置App GroupID（可选项）
//
// */
+ (void)setAppGroupId:(NSString*)groupId;


///**
// 设置AppProxy Extension的bundle,需要和Info.plist设置的一致（可选项）
//
// */
+ (void)setAppProxyBundleId:(NSString*)bundleId;

/**
 *  设置登录到 SSLVPN网关的参数， 设置以后AppProxy可以自动登录SSLVPN, 不需要在app登录
 *
 * 登录服务器，登录参数说明<br>
 NSDictionary *loginDic = @{
 @"vpn_host"      : @"SSLVPN网关的域名或IP",
 @"vpn_port"      : @"SSLVPN网关的端口，默认为443",
 @"auth_server"   : @"认证服务器名，默认选取第一个",
 @"auth_username" : @"登录用户名",
 @"auth_password" : @"登录密码",
 @"auth_mode"     : @0, //0用户名密码登录，1，证书登录, 2 动态口令， 3 二维码
 @"auth_autologin": @1, //1自动登录，0手动登录，需要实现登录界面， Extension不支持界面登录。
 @"extra_xxxxxx" :  extra_ 开头的额外的参数
 };
 *
 * @param params
 *        登录参数
 *
 */
+ (void)setVPNLoginParams:(NSDictionary*)params complectionHandler:(void (^)(NSError* _Nullable error))complectionHandler;


///**
// 如果在App登录VPN，VPN登录成功后,调用如下方法，将vpn的用户参数传入AppProxy
// AppProxy可以不用再登录VPN，使用app登录的数据建立VPN代理。
// 如果App的VPN会话失效，AppProxy将无法工作，所以App需要检查和维护vpn会话状态
//
// */
+ (void)setVPNLoginUserDataComplectionHandler:(void (^)(NSError* _Nullable error))complectionHandler;


///**
// 直接设置一个代理服务器，AppProxy数据将转发到设置的代理服务器
//
// */
//NSDictionary *proxyDic = @{
//@"proxy_host"      : @"代理主机",
//@"proxy_port"      : @"代理端口",
//};
+ (void)setProxyParams:(NSDictionary*)params complectionHandler:(void (^)(NSError* _Nullable error))complectionHandler;


///**
// 清除所有设置
//
// */
+ (void)cleanConfig;

@end

NS_ASSUME_NONNULL_END
