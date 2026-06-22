//
//  ScanCodePlugin.h
//  jtydmh
//
//  Created by eccl on 2021/6/23.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanCodePlugin : CDVPlugin


/// 扫码方法
/// @param command  需传入参数
/// [NSString]  1 条形码       2 二维码       3 条形码 & 二维码
- (void)scan:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
