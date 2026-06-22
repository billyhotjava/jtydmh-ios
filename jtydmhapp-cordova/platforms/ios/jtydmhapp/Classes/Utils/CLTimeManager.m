//
//  CLTimeManager.m
//  jtydmhapp
//
//  Created by eccl on 2022/1/17.
//

#import "CLTimeManager.h"

@interface CLTimeManager ()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) NSTimeInterval differTimeInterval;

@end

@implementation CLTimeManager

+ (instancetype)sharedInstance {
    static CLTimeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CLTimeManager alloc] init];
    });
    return instance;
}

- (void)startCalculateTime {
    self.startDate = [NSDate date];
    DLog(@"退置后台，开始计算时间");
}

- (BOOL)needGestureVerify {
    if (self.startDate) {
        self.differTimeInterval = [[NSDate date] timeIntervalSinceDate:self.startDate];
        DLog(@"是否需要手势密码, 开始时间: %@, 时间差 %f", self.startDate, self.differTimeInterval);
        BOOL result = self.differTimeInterval - needGestureVerifyTime > 0;
        [self reset];
        return result;
    }
    return NO;
}

- (void)reset {
    self.startDate = nil;
    self.differTimeInterval = 0;
}

@end
