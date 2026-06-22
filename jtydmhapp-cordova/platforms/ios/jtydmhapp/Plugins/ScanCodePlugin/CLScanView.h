//
//  CLScanView.h
//  jtdgdw
//
//  Created by zhangda on 2020/8/5.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScanCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLScanView : UIView

- (instancetype)initScanViewWithFrame:(CGRect)frame scanAreaHeight:(CGFloat)scanAreaHeight scanCodeType:(CLScanCodeType)scanCodeType;

- (void)destroyTimer;

@end

NS_ASSUME_NONNULL_END
