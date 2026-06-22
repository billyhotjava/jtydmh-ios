//
//  OpenWebViewPlugin.m
//  CordovaTest
//
//  Created by eccl on 2021/7/8.
//

#import "OpenWebViewPlugin.h"
#import "CLCDVViewController.h"

@implementation OpenWebViewPlugin

- (void)openWebView:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            NSLog(@"参数: %@", command.arguments);
            if (args && args.count >= 1) {
                NSString *param = args.firstObject;
                NSArray *params = [param componentsSeparatedByString:@"//"];
                if (params && params.count == 2) {
                    NSString *http = [NSString stringWithFormat:@"%@//", params.firstObject];
                    NSString *port = params.lastObject;
                    CLCDVViewController *viewController = [[CLCDVViewController alloc] init];
                    viewController.wwwFolderName = http;
                    viewController.startPage = port;
                    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    if (rootViewController) {
                        [rootViewController presentViewController:nav animated:YES completion:nil];
                    }
                } else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 方法入参内容不正确"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
                
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 方法入参不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

@end
