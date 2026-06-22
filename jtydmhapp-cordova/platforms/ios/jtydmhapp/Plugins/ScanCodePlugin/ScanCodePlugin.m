//
//  ScanCodePlugin.m
//  jtydmh
//
//  Created by eccl on 2021/6/23.
//

#import "ScanCodePlugin.h"
#import "CLScanViewController.h"

@implementation ScanCodePlugin

- (void)scan:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
//            NSLog(@"参数: %@", command.arguments);
            if (args && args.count > 0) {
                NSMutableString *arg = [NSMutableString stringWithFormat:@"%@", args.firstObject];
                NSInteger codeType = [arg integerValue];
                if (codeType <= 0 || codeType > 3) {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-scan: 方法入参值不正确"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else {
                    CLScanViewController *scanViewController = [[CLScanViewController alloc] init];
                    scanViewController.scanCodeType = codeType;
                    scanViewController.completion = ^(NSString * _Nullable codeContent) {
                        if (codeContent && codeContent.length) {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:codeContent];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        } else {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"用户取消"];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }
                    };
                    scanViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                    if (rootViewController) {
                        if (rootViewController.presentedViewController) {
                            rootViewController = rootViewController.presentedViewController;
                        }
                        [rootViewController presentViewController:scanViewController animated:YES completion:nil];
                    } else {
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"系统异常，根试图控制器获取失败"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                }
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-scan: 方法没有入参"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

@end
