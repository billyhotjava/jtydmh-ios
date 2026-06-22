//
// HarmonyCloudCrashReporter.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudCrashReporter : NSObject <NSURLSessionDelegate>
#if TARGET_OS_IOS
@property (nonatomic, strong) NSDictionary* crashSegmentation;

+ (instancetype)sharedInstance;
- (void)startCrashReporting;
- (void)recordHandledException:(NSException *)exception;
- (void)logWithFormat:(NSString *)format andArguments:(va_list)args;
- (void)crashTest;
- (void)crashTest2;
- (void)crashTest3;
- (void)crashTest4;
- (void)crashTest5;
- (void)crashTest6;
#endif
@end
