//
// HarmonyCloudUserDetails.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HarmonyCloudUserDetailsNullableString <NSObject>
@end
@interface NSString (NSStringWithHarmonyCloudUserDetailsNullableString) <HarmonyCloudUserDetailsNullableString>
@end
@interface NSNull (NSNullWithHarmonyCloudUserDetailsNullableString) <HarmonyCloudUserDetailsNullableString>
@end


@protocol HarmonyCloudUserDetailsNullableDictionary <NSObject>
@end
@interface NSDictionary (NSDictionaryWithHarmonyCloudUserDetailsNullableDictionary) <HarmonyCloudUserDetailsNullableDictionary>
@end
@interface NSNull (NSNullWithHarmonyCloudUserDetailsNullableDictionary) <HarmonyCloudUserDetailsNullableDictionary>
@end


@protocol HarmonyCloudUserDetailsNullableNumber <NSObject>
@end
@interface NSNumber (NSDictionaryWithHarmonyCloudUserDetailsNullableNumber) <HarmonyCloudUserDetailsNullableNumber>
@end
@interface NSNull (NSNullWithHarmonyCloudUserDetailsNullableNumber) <HarmonyCloudUserDetailsNullableNumber>
@end


@interface HarmonyCloudUserDetails : NSObject

@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> name;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> username;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> email;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> organization;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> phone;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> gender;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> pictureURL;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableString> pictureLocalPath;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableNumber> birthYear;
@property (nonatomic, strong) id<HarmonyCloudUserDetailsNullableDictionary> custom;

+ (HarmonyCloudUserDetails *)sharedInstance;
- (void)recordUserDetails;
- (NSString *)serialize;
- (NSData *)pictureUploadDataForRequest:(NSString *)requestString;

#pragma mark -

- (void)set:(NSString *)key value:(NSString *)value;
- (void)setOnce:(NSString *)key value:(NSString *)value;
- (void)unSet:(NSString *)key;
- (void)increment:(NSString *)key;
- (void)incrementBy:(NSString *)key value:(NSInteger)value;
- (void)multiply:(NSString *)key value:(NSInteger)value;
- (void)max:(NSString *)key value:(NSInteger)value;
- (void)min:(NSString *)key value:(NSInteger)value;
- (void)push:(NSString *)key value:(NSString *)value;
- (void)push:(NSString *)key values:(NSArray *)value;
- (void)pushUnique:(NSString *)key value:(NSString *)value;
- (void)pushUnique:(NSString *)key values:(NSArray *)value;
- (void)pull:(NSString *)key value:(NSString *)value;
- (void)pull:(NSString *)key values:(NSArray *)value;
- (void)save;
@end
