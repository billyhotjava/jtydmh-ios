//
// HarmonyCloud_OpenUDID.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

/**
 *  Represents an open UDID class.
 *
 *  @version 1.0
 */
@interface HarmonyCloud_OpenUDID : NSObject {
}

/**
 *  Main public method that returns the OpenUDID
 *  This method will generate and store the OpenUDID if it doesn't exist, typically the first time it is called
 *  It will return the null udid (forty zeros) if the user has somehow opted this app out (this is subject to 3rd party implementation)
 *  Otherwise, it will register the current app and return the OpenUDID
 *
 * @return the open UDID string.
 */
+ (NSString *)value;

/**
 *  Generate the OpenUDID.
 *
 *  @param error The error variable to record when generating an OpenUDID.
 *  @return the open UDID string.
 */
+ (NSString *)valueWithError:(NSError**)error;

/**
 *  Set to opt-out the key of OpenUDID or not.
 *  If YES, opt-out the key, else store it.
 *
 *  @param optOutValue the flag indicating whether to opt out the key or not.
 */
+ (void)setOptOut:(BOOL)optOutValue;

@end
