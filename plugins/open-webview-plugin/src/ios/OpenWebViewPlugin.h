//
//  OpenWebViewPlugin.h
//  CordovaTest
//
//  Created by eccl on 2021/7/8.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenWebViewPlugin : CDVPlugin

- (void)openWebView:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
