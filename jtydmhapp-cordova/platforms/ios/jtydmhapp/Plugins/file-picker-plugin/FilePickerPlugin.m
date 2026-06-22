//
//  FilePickerPlugin.m
//  jtydmhapp
//
//  Created by eccl on 2022/11/29.
//

#import "FilePickerPlugin.h"
#import "CLICloudManager.h"

@interface FilePickerPlugin () <UIDocumentPickerDelegate>

@property (nonatomic, copy) NSString *callbackId;

@end

@implementation FilePickerPlugin

- (void)file:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isEnable = [CLICloudManager iCloudEnable];
            if(isEnable == false){
                NSLog(@"iCloud不支持");
                return;
            }
            self.callbackId = command.callbackId;
            NSArray *documentTypes = @[@"public.text",@"public.source-code",@"com.microsoft.word.doc",
                                       @"com.microsoft.excel.xls",@"public.content", @"public.audiovisual-content",
                                       @"com.adobe.pdf",@"com.apple.keynote.key",@"com.microsoft.powerpoint.ppt"];
            UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
            documentPickerViewController.delegate = self;
            documentPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:documentPickerViewController animated:YES completion:nil];
        });
    }];
}

#pragma mark - UIDocumentPickerDelegate
/*
 (
     "file:///private/var/mobile/Containers/Data/Application/E34FC18F-4748-4A3F-8A06-2F06A6C84C45/tmp/com.eccl.jtmh-Inbox/question_bank.txt"
 )
 */
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
    NSLog(@"%s --- %@", __FUNCTION__, urls);
    NSMutableArray *newUrls = [NSMutableArray array];
    [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newUrls addObject:@{
            @"mediaType": @3,
            @"url": obj.absoluteString
        }];
    }];
    NSLog(@"--- 获取的文件信息 ---\n %@", newUrls);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:newUrls];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

// called if the user dismisses the document picker without selecting a document (using the Cancel button)
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"取消 %s --- %@", __FUNCTION__, controller);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"用户取消"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSLog(@"%s --- %@", __FUNCTION__, url);
    NSArray *newUrls = @[
        @{
            @"mediaType": @3,
            @"url": url.absoluteString
        }
    ];
    NSLog(@"--- 2 获取的文件信息 ---\n %@", newUrls);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:newUrls];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
