//
// HarmonyCloudViewTracking.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudViewTracking : NSObject

+ (instancetype _Nonnull)sharedInstance;

- (void)reportView:(NSString* _Nonnull)viewName;
- (void)endView:(NSString* _Nonnull)viewName;
- (void)pauseView;
- (void)resumeView;
#if TARGET_OS_IOS
- (void)startAutoViewTracking;
- (void)addExceptionForAutoViewTracking:(NSString *)exceptionViewControllerSubclass;
- (void)removeExceptionForAutoViewTracking:(NSString *)exceptionViewControllerSubclass;
@property (nonatomic) BOOL isAutoViewTrackingEnabled;
#endif
@property (nonatomic, strong) NSString* _Nonnull lastView;

@property (nonatomic,nullable,strong) NSMutableDictionary *savedHardwareUsagesInfo;
@property (nonatomic,nullable,strong) NSMutableDictionary *savedThreadsInfo;
//@property (nonatomic,nullable,strong) NSMutableDictionary *savedTimers;
@property (nonatomic,nullable,strong) NSMutableDictionary *savedStartTimestamp;
@property (nonatomic,nullable,strong) NSMutableArray *activityHistories;

@property (nonatomic,assign) float currentCpuUsage;
@end

#if TARGET_OS_IOS
@interface UIViewController (HarmonyCloudViewTracking)
- (void)HarmonyCloud_viewDidLoad;
- (void)HarmonyCloud_viewDidAppear:(BOOL)animated;
@end
#endif
