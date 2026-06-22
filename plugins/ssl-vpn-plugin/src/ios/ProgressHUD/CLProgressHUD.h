//
//  CLProgressHUD.h
//  jtdgdw
//
//  Created by eccl on 2020/8/25.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLProgressHUD : NSObject

+ (instancetype)sharedInstance;

- (void)show;

- (void)showWithTip:(NSString *)tip;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
