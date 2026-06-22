//
//  CLTimeManager.h
//  jtydmhapp
//
//  Created by eccl on 2022/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 管理 移动门户进入后台后至切换到前台的时间，判断是否需要手势密码
@interface CLTimeManager : NSObject

+ (instancetype)sharedInstance;

- (void)startCalculateTime;

- (BOOL)needGestureVerify;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
