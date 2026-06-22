//
// HarmonyCloudConnectionManager.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

@interface HarmonyCloudConnectionManager : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSString* appHost;
@property (nonatomic, strong) NSURLSessionTask* connection;
@property (nonatomic) BOOL isTestDevice;
@property (nonatomic) NSTimeInterval updateSessionPeriod;
@property (nonatomic, strong) NSArray* pinnedCertificates;
@property (nonatomic, strong) NSString* customHeaderFieldName;
@property (nonatomic, strong) NSString* customHeaderFieldValue;
@property (nonatomic, strong) NSString* secretSalt;
@property (nonatomic) BOOL alwaysUsePOST;

+ (instancetype)sharedInstance;

- (void)beginSession;
- (void)updateSessionWithDuration:(double)duration;
- (void)endSessionWithDuration:(double)duration;

- (void)sendEvents:(HarmonyCloudEvent *)event;
- (void)sendUserDetails:(NSString *)userDetails;
- (void)sendPushToken:(NSString *)token;
//- (void)sendCrashReportLater:(NSString *)report;
- (void)sendCrashReportLater:(NSString *)buildId activityHistory:(NSString *)activityHistory devInfo:(NSString *)devInfo envInfo:(NSString *)envInfo errMsg:(NSString *)errMsg errClass:(NSString *)errClass throwableMsg:(NSString *)throwableMsg native:(NSString *)native appBundleName:(NSString *)appBundleName binaryImages:(NSString *)binaryImages;
- (void)sendAnrInfo:(NSString *)appInfo devInfo:(NSString *)devInfo anrEnv:(NSString *)anrEnv anrStackTraces:(NSString *)anrStackTraces anrMessage:(NSString *)anrMessage;
- (void)sendOldDeviceID:(NSString *)oldDeviceID;
- (void)sendParentDeviceID:(NSString *)parentDeviceID;
- (void)sendLocation:(CLLocationCoordinate2D)coordinate;

- (NSString *)queryEssentials;
- (NSString *)boundary;
- (BOOL)isRequestSuccessful:(NSURLResponse *)response;
- (void)tick;
- (void)startTimer;
- (void)cancelSendingIfInProgress;
@end
