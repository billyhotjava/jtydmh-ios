//
// HarmonyCloudPersistency.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HarmonyCloudEvent;

@interface HarmonyCloudPersistency : NSObject

+ (instancetype)sharedInstance;

- (void)addToQueue:(NSString *)queryString;
- (void)removeFromQueue:(NSString *)queryString;
- (NSString *)firstItemInQueue;

- (void)recordEvent:(HarmonyCloudEvent *)event;
- (NSString *)serializedRecordedEvents;

- (void)recordTimedEvent:(HarmonyCloudEvent *)event;
- (HarmonyCloudEvent *)timedEventForKey:(NSString *)key;
- (void)clearAllTimedEvents;

- (void)saveToFile;
- (void)saveToFileSync;

- (NSString *)retrieveStoredDeviceID;
- (void)storeDeviceID:(NSString *)deviceID;

- (NSString *)retrieveWatchParentDeviceID;
- (void)storeWatchParentDeviceID:(NSString *)deviceID;

- (NSDictionary *)retrieveStarRatingStatus;
- (void)storeStarRatingStatus:(NSDictionary *)status;

@property (nonatomic) NSUInteger eventSendThreshold;
@property (nonatomic) NSUInteger storedRequestsLimit;
@end
