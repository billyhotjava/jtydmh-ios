//
// HarmonyCloudStarRating.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudStarRating : NSObject
#if TARGET_OS_IOS
+ (instancetype)sharedInstance;

- (void)showDialog:(void(^)(NSInteger rating))completion;
- (void)checkForAutoAsk;

@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* dismissButtonTitle;
@property (nonatomic) NSUInteger sessionCount;
@property (nonatomic) BOOL disableAskingForEachAppVersion;
#endif
@end
