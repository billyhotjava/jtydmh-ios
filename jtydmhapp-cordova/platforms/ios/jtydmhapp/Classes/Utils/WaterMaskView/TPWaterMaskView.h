//
//  TPWaterMaskView.h
//  TP
//
//  Created by eccl on 2022/8/11.
//  Copyright © 2022 eccl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPWaterMaskView : UIView

- (instancetype)initWithWaterMaskText:(NSString *)waterMaskText waterMaskTextAttribute:(NSDictionary *)waterMaskTextAttribute slantAngle:(CGFloat)slantAngle;

@end

NS_ASSUME_NONNULL_END
