//
//  HarmonyCloudHTTPModel.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface HarmonyCloudHTTPModel : NSObject

@property (nonatomic,strong) NSURLRequest *ne_request;
@property (nonatomic,strong) NSHTTPURLResponse *ne_response;
@property (nonatomic,assign) double myID;
@property (nonatomic,strong) NSString *startDateString;
@property (nonatomic,strong) NSString *endDateString;

@property (nonatomic,assign) NSTimeInterval startDateSeconds;
@property (nonatomic,assign) NSTimeInterval endDateSeconds;
// record http error count
@property (nonatomic,assign) long long count;

// record all loaded http hosts
@property (nonatomic, strong) NSMutableArray *loadedHosts;

//request
@property (nonatomic,strong) NSString *requestURLString;
@property (nonatomic,strong) NSString *requestCachePolicy;
@property (nonatomic,assign) double requestTimeoutInterval;
@property (nonatomic,nullable, strong) NSString *requestHTTPMethod;
@property (nonatomic,nullable,strong) NSString *requestAllHTTPHeaderFields;
@property (nonatomic,nullable,strong) NSString *requestHTTPBody;
@property (nonatomic,assign) long long sentDataSize;

//response
@property (nonatomic,nullable,strong) NSString *responseMIMEType;
@property (nonatomic,strong) NSString * responseExpectedContentLength;
@property (nonatomic,nullable,strong) NSString *responseTextEncodingName;
@property (nullable, nonatomic, strong) NSString *responseSuggestedFilename;
@property (nonatomic,assign) int responseStatusCode;
@property (nonatomic,nullable,strong) NSString *responseAllHeaderFields;
@property (nonatomic,assign) long long receivedDataSize;

//JSONData
@property (nonatomic,strong) NSString *receiveJSONData;

@property (nonatomic,strong) NSString *mapPath;
@property (nonatomic,strong) NSString *mapJSONData;

@end
NS_ASSUME_NONNULL_END
