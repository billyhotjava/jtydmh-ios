//
//  HarmonyCloudBacktraceLogger.h
//
//  Created by Yuli Hu on 2016/12/27.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <sys/types.h>
#include <limits.h>
#include <string.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>

/**
 *  Represents the back trace logger class.
 *
 *  @version 1.0
 */
@interface HarmonyCloudBacktraceLogger : NSObject

/**
 *  Get the back trace string of specified thread.
 *
 *  @param thread The thread number parameter.
 *
 *  @return the back trace string of the thread.
 */
+ (NSString *)backtraceOfMachthread:(thread_t)thread;

@end
