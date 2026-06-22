//
// HarmonyCloudAPM.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudAPM : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableArray* _Nonnull exceptionURLs;

+ (instancetype _Nonnull)sharedInstance;
- (void)startAPM;
- (void)addExceptionForAPM:(NSString* _Nonnull)exceptionURL;
- (void)removeExceptionForAPM:(NSString* _Nonnull)exceptionURL;
@end



#pragma mark -
@interface NSURLConnection (HarmonyCloudAPM)

@property (nonatomic, strong) id <NSURLConnectionDataDelegate,NSURLConnectionDelegate> _Nonnull originalDelegate;
@property (nonatomic, strong) HarmonyCloudAPMNetworkLog* _Nonnull APMNetworkLog;

+ (nullable NSData *)HarmonyCloud_sendSynchronousRequest:(NSURLRequest  * _Nonnull )request
                                  returningResponse:(NSURLResponse * __nullable * __nullable)response
                                              error:(NSError * __nullable * __nullable)error;

+ (void)HarmonyCloud_sendAsynchronousRequest:(NSURLRequest * _Nonnull) request
                                  queue:(NSOperationQueue*_Nonnull) queue
                      completionHandler:(void (^ _Nullable)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError)) handler;

- (nullable instancetype)HarmonyCloud_initWithRequest:(NSURLRequest * _Nonnull)request delegate:(nullable id)delegate;

- (nullable instancetype)HarmonyCloud_initWithRequest:(NSURLRequest * _Nonnull)request delegate:(nullable id)delegate startImmediately:(BOOL)startImmediately;

- (void)HarmonyCloud_start;

@end



#pragma mark -
@interface NSURLSession (HarmonyCloudAPM)
- (NSURLSessionDataTask * __nullable)HarmonyCloud_dataTaskWithRequest:(NSURLRequest * _Nonnull)request
                                               completionHandler:(void (^ _Nullable)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

- (NSURLSessionDownloadTask * __nullable)HarmonyCloud_downloadTaskWithRequest:(NSURLRequest * _Nonnull)request completionHandler:(void (^ _Nullable)(NSURL * __nullable location, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

@end



@interface NSURLSessionTask (HarmonyCloudAPM)

@property (nonatomic, strong) HarmonyCloudAPMNetworkLog* _Nonnull APMNetworkLog;

- (void)HarmonyCloud_resume;

@end
