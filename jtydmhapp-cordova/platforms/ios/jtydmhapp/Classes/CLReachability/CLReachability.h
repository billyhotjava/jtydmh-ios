//
//  CLReachability.h
//  jtydmh
//
//  Created by eccl on 2021/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLReachability : NSObject


/// 查看附件的 MimeType 类型
@property (nonatomic, copy) NSString *fileMimeType;

+ (instancetype)sharedInstance;

- (void)reachabilityWithPingHost:(NSString *)pingHost;

- (void)stopNotifier;

- (void)tryPingHost:(void(^)(BOOL isSuccess, NSTimeInterval latency))callback;

@end

NS_ASSUME_NONNULL_END
