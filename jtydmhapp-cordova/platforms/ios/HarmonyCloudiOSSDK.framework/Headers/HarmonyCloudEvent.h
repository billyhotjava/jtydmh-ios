//
// HarmonyCloudEvent.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudEvent : NSObject <NSCoding>

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* eventType;
@property (nonatomic, strong) NSDictionary* segmentation;
@property (nonatomic) NSUInteger count;
@property (nonatomic) double sum;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) NSUInteger hourOfDay;
@property (nonatomic) NSUInteger dayOfWeek;
@property (nonatomic) NSTimeInterval duration;
- (NSDictionary *)dictionaryRepresentation;

@end
