//
//  CLScanViewController.h
//  jtdgdw
//
//  Created by zhangda on 2020/8/5.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScanCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLScanViewController : UIViewController

@property (nonatomic) CLScanCodeType scanCodeType;
@property (nonatomic, copy) void (^completion)(NSString *__nullable codeContent);

@end

NS_ASSUME_NONNULL_END
