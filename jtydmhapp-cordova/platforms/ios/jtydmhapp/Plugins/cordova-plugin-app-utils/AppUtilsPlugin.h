//
//  AppUtilsPlugin.h
//  jtydmhapp
//
//  Created by eccl on 2022/1/10.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtilsPlugin : CDVPlugin

/// 获取极光推送ID
- (void)registrationId:(CDVInvokedUrlCommand *)command;


/// 清除缓存
- (void)clearCache:(CDVInvokedUrlCommand *)command;

/// 设置 App的标准版本和大字体版本   [in]    NSString       normal   larger
- (void)setWebSize:(CDVInvokedUrlCommand *)command;

/// 退出app
- (void)exitApp:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
