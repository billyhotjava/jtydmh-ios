//
//  HarmonyCloudHTTPEye.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HarmonyCloudHTTPEye : NSURLProtocol
/**
 *  open or close HTTP/HTTPS monitor
 *
 *  @param enabled true if set to monitor http network
 *  @param receiveHost the url to receive data
 */
+ (void)setEnabled:(BOOL)enabled receiveHost:(NSString *)receiveHost;

@end
