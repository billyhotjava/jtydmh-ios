//
// HarmonyCloudAPMNetworkLog.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HarmonyCloud.h"

@interface HarmonyCloudAPMNetworkLog : NSObject
@property (nonatomic, strong) NSURLRequest* request;
+ (instancetype)createWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
- (void)start;
- (void)updateWithResponse:(NSURLResponse *)response;
- (void)finish;
- (void)finishWithStatusCode:(NSInteger)statusCode andDataSize:(long long)dataSize;
@end
