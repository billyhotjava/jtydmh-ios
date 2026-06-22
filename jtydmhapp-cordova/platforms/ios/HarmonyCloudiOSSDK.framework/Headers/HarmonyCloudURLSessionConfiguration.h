//
//  HarmonyCloudURLSessionConfiguration.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudURLSessionConfiguration : NSObject
@property (nonatomic,assign) BOOL isSwizzle;// whether swizzle NSURLSessionConfiguration's protocolClasses method

/**
 *  get HarmonyCloudURLSessionConfiguration's singleton object
 *
 *  @return singleton object
 */
+ (HarmonyCloudURLSessionConfiguration *)defaultConfiguration;

/**
 *  swizzle NSURLSessionConfiguration's protocolClasses method
 */
- (void)load;

/**
 *  make NSURLSessionConfiguration's protocolClasses method is normal
 */
- (void)unload;
@end
