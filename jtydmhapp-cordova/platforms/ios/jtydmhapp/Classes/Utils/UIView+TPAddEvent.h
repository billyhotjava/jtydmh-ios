//
//  UIView+TPAddEvent.h
//  HappyDZ
//
//  Created by 赵晓静 on 2018/12/31.
//  Copyright © 2015 TP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TPAddEvent)

/// 设置点击事件
- (void)addTarget:(id)target action:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
