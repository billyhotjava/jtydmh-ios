//
//  AppUtilsPlugin.m
//  jtydmhapp
//
//  Created by eccl on 2022/1/10.
//

#import "AppUtilsPlugin.h"
#import "JPUSHService.h"
#import "CLCleanCache.h"


/// 字体存储Key
static NSString *const kAppFontSizeTagKey = @"kAppFontSizeTagKey";
/// 标准字体
static NSString *const kAppFontSizeNormalTag = @"normal";
/// 放大版
static NSString *const kAppFontSizeLargerTag = @"larger";


@implementation AppUtilsPlugin

/// 获取极光推送ID
- (void)registrationId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== 获取极光ID ====");
            NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:kJPushRegistrationID];
            if (IsAvailableString(registrationID)) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:registrationID];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
//            NSLog(@"[JPUSHService registrationID]: %@", [JPUSHService registrationID]);
            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                if (resCode == 0 && IsAvailableString(registrationID)) {
//                    NSLog(@"--- registrationID: %@", registrationID);
                    [[NSUserDefaults standardUserDefaults] setValue:registrationID forKey:kJPushRegistrationID];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:registrationID];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"获取 registrationID 失败, errorcode: %d", resCode]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }];
        });
    }];
}

// 清除缓存
- (void)clearCache:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== 清除缓存 ====");
            [CLCleanCache cleanCache:^(float size) {
//                NSLog(@"缓存大小: %fM", size);
                NSString *sizeString = [self formartNumber2DecimalPlaces:@(size)];
//                NSLog(@"缓存大小 string: %@M", sizeString);
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:sizeString];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        });
    }];
}

/// 设置 App的标准版本和大字体版本   [in]    NSString       normal   larger
- (void)setWebSize:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"==== 设置App标准版本和大字体版本 ====");
            NSArray *args = command.arguments;
//            NSLog(@"参数: %@", command.arguments);
            if (args && args.count >= 1) {
                NSString *tag = args.firstObject;
                if ([tag isEqualToString:kAppFontSizeNormalTag] || [tag isEqualToString:kAppFontSizeLargerTag]) {
                    [[NSUserDefaults standardUserDefaults] setValue:tag forKey:kAppFontSizeTagKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:tag];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                    NSLog(@"字体改变完成");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        NSLog(@"准备退出...");
                        abort();
                    });
                } else {
//                    NSLog(@"-setWebSize: 方法入参内容不正确");
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-setWebSize: 方法入参内容不正确"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            } else {
//                NSLog(@"-setWebSize: 方法入参个数不正确");
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-setWebSize: 方法入参个数不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

/**
 过滤器/ 将.2f格式化的字符串，去除末尾0

 @param numberStr .2f格式化后的字符串
 @return 去除末尾0之后的
 */
- (NSString *)formartNumber2DecimalPlaces:(NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.00"];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    formatter.maximumFractionDigits = 2;
    NSString *numberStr = [formatter stringFromNumber:number];
//    NSLog(@"%@", numberStr);
    if (numberStr.length > 1) {
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return [number stringValue];
    }
}

- (void)exitApp:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            abort();
        });
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
