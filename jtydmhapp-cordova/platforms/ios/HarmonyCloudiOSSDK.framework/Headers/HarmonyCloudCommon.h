//
// HarmonyCloudCommon.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HarmonyCloud.h"
#import "HarmonyCloud_OpenUDID.h"
#import "HarmonyCloudPersistency.h"
#import "HarmonyCloudConnectionManager.h"
#import "HarmonyCloudEvent.h"
#import "HarmonyCloudUserDetails.h"
#import "HarmonyCloudDeviceInfo.h"
#import "HarmonyCloudCrashReporter.h"
#import "HarmonyCloudAPMNetworkLog.h"
#import "HarmonyCloudAPM.h"
#import "HarmonyCloudConfig.h"
#import "HarmonyCloudViewTracking.h"
#import "HarmonyCloudStarRating.h"

#ifndef HarmonyCloud_DEBUG
#define HarmonyCloud_DEBUG 0
#endif

#if HarmonyCloud_DEBUG
#define HarmonyCloud_LOG(fmt, ...) NSLog([@"%@ " stringByAppendingString:fmt], @"[HarmonyCloud]", ##__VA_ARGS__)
#else
#define HarmonyCloud_LOG(...)
#endif

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "WatchConnectivity/WatchConnectivity.h"
#endif

#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#import "WatchConnectivity/WatchConnectivity.h"
#endif

#if TARGET_OS_TV
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#endif

#ifndef TARGET_OS_OSX
#define TARGET_OS_OSX (!(TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH))
#endif

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

#import <sys/types.h>
#import <sys/sysctl.h>
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <objc/runtime.h>

#if (TARGET_OS_IOS || TARGET_OS_WATCH)
@interface HarmonyCloudCommon : NSObject <WCSessionDelegate>
#else
@interface HarmonyCloudCommon : NSObject
#endif

@property (nonatomic, strong) NSString* ISOCountryCode;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* sessionId;

+ (instancetype)sharedInstance;
- (NSInteger)hourOfDay;
- (NSInteger)dayOfWeek;
- (NSInteger)timeZone;
- (long long)timeSinceLaunch;
- (NSTimeInterval)uniqueTimestamp;
- (NSString *)regionInfo;
- (NSString *)appInfo;
- (NSString *)getCountry;
- (NSString *)getRegion;
- (NSString *)getCity;
- (NSData *)parseRequestUrlToJSONData:(NSString *)requestUrl;
- (void) getDataFrom:(NSString *)urlString;
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
- (void)activateWatchConnectivity;
#endif

#if (TARGET_OS_IOS)
- (void)transferParentDeviceID;
#endif
@end

@interface NSString (URLEscaped)
- (NSString *)URLEscaped;
- (NSString *)SHA1;
- (NSData *)dataUTF8;
@end

@interface NSArray (JSONify)
- (NSString *)JSONify;
- (NSString *)JSONifyWithoutURLEscaped;
@end

@interface NSDictionary (JSONify)
- (NSString *)JSONify;
- (NSString *)JSONifyWithoutURLEscaped;
@end

@interface NSMutableData (AppendStringUTF8)
- (void)appendStringUTF8:(NSString *)string;
@end

@interface NSData (stringUTF8)
- (NSString *)stringUTF8;
@end

@interface HarmonyCloud (RecordEventWithTimeStamp)
- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(double)sum duration:(NSTimeInterval)duration timestamp:(NSTimeInterval)timestamp;
@end
