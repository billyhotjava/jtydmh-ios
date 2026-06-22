//
// HarmonyCloudAnr.h
//
//  Created by Yuli Hu on 2017/06/01.
//  Copyright © 2017年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudAnr : NSObject

+ (instancetype _Nonnull) sharedInstance;
- (void) startMonitor;
- (void) endMonitor;
- (void) printLogTrace;

@end
