//
//  CLProgressHUD.m
//  jtdgdw
//
//  Created by eccl on 2020/8/25.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "CLProgressHUD.h"

#define IsAvailableString(_ref)   (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ([_ref isKindOfClass:[NSString class]]) && (_ref.length > 0))

@interface CLProgressHUD ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CLProgressHUD

+ (instancetype)sharedInstance {
    static CLProgressHUD *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CLProgressHUD alloc] init];
        sharedInstance.hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        NSArray *array = [NSArray arrayWithObjects:[MBProgressHUD class], nil];
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:array].color = [UIColor whiteColor];
        sharedInstance.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        sharedInstance.hud.bezelView.backgroundColor=[UIColor blackColor];
        sharedInstance.hud.removeFromSuperViewOnHide = YES;
        sharedInstance.hud.label.textColor = [UIColor whiteColor];
    });
    return sharedInstance;
}

- (void)show {
    if ([NSThread currentThread].isMainThread) {
        [self normalShowWithTip:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self normalShowWithTip:nil];
        });
    }
}

- (void)showWithTip:(NSString *)tip {
    if ([NSThread currentThread].isMainThread) {
        [self normalShowWithTip:tip];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self normalShowWithTip:tip];
        });
    }
}

- (void)hide {
    if ([NSThread currentThread].isMainThread) {
        [self normalHide];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self normalHide];
        });
    }
}

- (void)normalShowWithTip:(NSString *)tip {
    if (!IsAvailableString(tip)) {
        tip = @"请稍候...";
    }
    self.hud.label.text = tip;
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)normalHide {
    [self.hud hideAnimated:YES];
}

@end
