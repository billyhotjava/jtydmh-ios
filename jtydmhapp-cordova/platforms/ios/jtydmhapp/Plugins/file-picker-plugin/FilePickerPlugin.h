//
//  FilePickerPlugin.h
//  jtydmhapp
//
//  Created by eccl on 2022/11/29.
//

#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilePickerPlugin : CDVPlugin

- (void)file:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
