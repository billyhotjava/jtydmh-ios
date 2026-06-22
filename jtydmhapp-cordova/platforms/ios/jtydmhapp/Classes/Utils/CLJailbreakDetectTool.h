//
//  CLJailbreakDetectTool.h
//  jtdgdw
//
//  Created by eccl on 2022/5/26.
//  Copyright © 2022 ECCL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLJailbreakDetectTool : NSObject

/**
 * 检查当前设备是否已经越狱。
 */
+ (BOOL)detectCurrentDeviceIsJailbroken;

@end

NS_ASSUME_NONNULL_END
