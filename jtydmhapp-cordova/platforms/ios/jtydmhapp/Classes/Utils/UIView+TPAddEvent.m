//
//  UIView+TPAddEvent.m
//  HappyDZ
//
//  Created by 赵晓静 on 2018/12/31.
//  Copyright © 2015 TP. All rights reserved.
//

#import "UIView+TPAddEvent.h"

@implementation UIView (TPAddEvent)

- (void)addTarget:(id)target action:(SEL)selector {

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//
//        if ([target respondsToSelector:selector]) {
//
//#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
//            [target performSelector:selector withObject:self];
//        }
//    }];
    [self addGestureRecognizer:tap];
}

@end
