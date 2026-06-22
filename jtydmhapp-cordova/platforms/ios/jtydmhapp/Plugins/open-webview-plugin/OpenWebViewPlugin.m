//
//  OpenWebViewPlugin.m
//  CordovaTest
//
//  Created by eccl on 2021/7/8.
//

#import "OpenWebViewPlugin.h"
#import "CLCDVViewController.h"
#import "SSZipArchive.h"
#import "SDKWrapper.h"
#import "CLDownloadInVPNManager.h"
#import "Sandboxer.h"
#import <QuickLook/QuickLook.h>
#import "CLReachability.h"
#import "CLNotificationInstance.h"
#import "CLWebViewController.h"
#import "CLVPNManager.h"
#import "SDKWrapper.h"

// 国神API BaseUrl 暂用于刷新token时
static NSString * const kGuoShenBaseUrl = @"https://mgs.sgeg.chnenergy.com.cn";

@interface OpenWebViewPlugin () <NSURLSessionDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, copy) NSString *previewFilePath;

@end

@implementation OpenWebViewPlugin

- (void)openWebView:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self realPackageOpenWebView:command isOpenUrl:YES];
        });
    }];
}

- (void)openWKWebView:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            NSLog(@"参数: %@", command.arguments);
            if (args && args.count >= 3) {
                NSString *urlStr = args.firstObject;
                NSString *title = args[1];
                NSDictionary *vpnInfo = args[2];
                NSString *colorString = @"#3b87f6";
                if (args.count >= 4) {
                    // 增加导航栏颜色字段
                    colorString = args[3];
                    NSLog(@"args[3]: %@", args[3]);
                }
                
                NSURL *url = [NSURL URLWithString:urlStr];
                if (url) {
                    NSLog(@"needVPN %d", [SDKWrapper getInstance].isConnected);
                    if ([SDKWrapper getInstance].isConnected) {
                        CLVPNManager *vpnManager = [CLVPNManager sharedInstance];
                        WS(weakSelf)
                        vpnManager.connectCompletion = ^(BOOL success, NSString * _Nullable errorMessage) {
                            if (success) {
                                [weakSelf realOpenWkWebViewWithTitle:title requestUrlStr:urlStr colorString:colorString command:command];
                            } else {
                                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWKWebView: 安全认证建立失败"];
                                [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            }
                        };
                        NSString *user = vpnInfo[@"user"];
                        NSString *password = vpnInfo[@"password"];
                        if (IsAvailableString(user) && IsAvailableString(password)) {
                            [vpnManager loginWithAccount:user password:password];
                        } else {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWKWebView: 安全认证信息获取失败"];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }
                    } else {
                        [self realOpenWkWebViewWithTitle:title requestUrlStr:urlStr colorString:colorString command:command];
                    }
                } else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWKWebView: 方法入参地址不正确"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWKWebView: 方法入参不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (void)realOpenWkWebViewWithTitle:(NSString *)title requestUrlStr:(NSString *)urlStr colorString:(NSString *)colorString command:(CDVInvokedUrlCommand *)command {
    CLWebViewController *viewController = [[CLWebViewController alloc] init];
    [viewController setNavTitle:title requestUrl:urlStr];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.modalPresentationStyle = viewController.modalPresentationStyle;
    UIColor *mainColor = [UIColor colorWithHexString:IsAvailableString(colorString) ? colorString : @"#3b87f6"];
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = mainColor;
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        nav.navigationBar.standardAppearance = appearance;
        nav.navigationBar.scrollEdgeAppearance=nav.navigationBar.standardAppearance;
    } else {
        nav.navigationBar.barTintColor = mainColor;
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootViewController) {
        if (rootViewController.presentedViewController) {
            rootViewController = rootViewController.presentedViewController;
        }
        [rootViewController presentViewController:nav animated:YES completion:^{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"-openWKWebView: 方法调用成功"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWKWebView: rootViewController 为空"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/// 打开附件（文档、文件、压缩包）
/// @param [in] 组好的fileUrl    fileName
/// 注: 若是文件则直接使用内部浏览器打开展示；若为压缩包，则直接解压后，弹出解压后的文件管理器
- (void)openFile:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *args = command.arguments;
            DLog(@"参数: %@", command.arguments);
            if (args && args.count >= 3) {
                NSString *fileUrl = args.firstObject;
                NSString *fileName = args[1];
                NSDictionary *downloadInfo = args[2];
                CLNotificationInstance.sharedInstance.userName = downloadInfo[@"userName"];
                CLNotificationInstance.sharedInstance.phoneNumber = downloadInfo[@"phoneNumber"];
                DLog(@"打开附件 info 字段: %@", downloadInfo);
                NSString *lowerFileName = [fileName lowercaseString];
//                NSLog(@"fileUrl: %@, fileName: %@", args.firstObject, fileName);
                NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
                BOOL fileNameResult = [self checkSuffix:fileNames.lastObject];
                DLog(@"是否包含可预览后缀 %d", fileNameResult);
                if (!fileNameResult) {
                    NSArray *fileUrls = [fileUrl.lowercaseString componentsSeparatedByString:@"."];
                    NSString *fileUrlSuffix = fileUrls.lastObject;
                    BOOL fileUrlResult = [self checkSuffix:fileUrlSuffix];
                    if (fileUrlResult) {
                        lowerFileName = [NSString stringWithFormat:@"%@.%@", lowerFileName, fileUrlSuffix];
                    }
                    DLog(@"组合后的 filename: %@", lowerFileName);
                }
                // 判断是否为文件、文档格式
                if ([self checkSuffix:lowerFileName]) {
                    [self setFileMimeType:lowerFileName];
                    // 用内置浏览器打开
                    if ([lowerFileName hasSuffix:@"pdf"]) {
                        DLog(@"pdf 文件 %@", lowerFileName);
//                        BOOL isExist = NO;
//                        NSString *unZipFilePath = [self tempUnzipPath:fileName isExist:&isExist];
//                        unZipFilePath = [unZipFilePath stringByAppendingPathComponent:fileName];
//                        if (isExist) {
//                            NSLog(@"存在文件，直接加载");
//                            [self previewFile2:fileName filePath:unZipFilePath];
//                            return;
//                        }
                        CLDownloadInVPNManager *downloadManager = [[CLDownloadInVPNManager alloc] init];
                        NSString *pdfFilePath = [self tempDownloadZipPath:lowerFileName isZip:NO];
                        DLog(@"pdf 文件 %@", pdfFilePath);
                        if (IsAvailableString(pdfFilePath)) {
                            [downloadManager download:fileUrl token:downloadInfo[@"token"] withSavedFilePath:pdfFilePath completionHandler:^(NSString * _Nonnull filePath) {
                                if (IsAvailableString(filePath)) {
                                    [self previewFile2:fileName filePath:filePath];
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"成功预览文件"];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                } else {
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"下载文件失败"];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                            }];
                        } else {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"创建文件失败"];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }
                        
                        return;
                    } else {
                        [self realPackageOpenWebView:command isOpenUrl:NO];
                        return;
                    }
                } else if ([lowerFileName hasSuffix:@"zip"] || [lowerFileName hasSuffix:@"rar"]) {
//                    NSLog(@"fileUrl:  %@, fileName: %@", fileUrl, fileName);
                    BOOL isExist = NO;
                    NSString *unZipFilePath = [self tempUnzipPath:fileName isExist:&isExist];
//                    NSLog(@"unZipFilePath 1 : %@", unZipFilePath);
                    if (isExist) {
//                        NSLog(@"存在文件，直接加载");
                        [self previewFile:fileName filePath:unZipFilePath];
                        return;
                    }
                    CLDownloadInVPNManager *downloadManager = [[CLDownloadInVPNManager alloc] init];
                    NSString *zipFilePath = [self tempDownloadZipPath:fileName isZip:YES];
                    [downloadManager download:fileUrl token:downloadInfo[@"token"] withSavedFilePath:zipFilePath completionHandler:^(NSString * _Nonnull filePath) {
//                        NSLog(@"完成 下载, 成功与否看 filePath 是否为空: %@", filePath);
                        if (filePath) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                NSLog(@"开始解压...");
                                if (IsAvailableString(unZipFilePath)) {
                                    BOOL success = [SSZipArchive unzipFileAtPath:filePath toDestination:unZipFilePath];
//                                    NSLog(@"解压  结果: %d", success);
//                                    NSError *error = nil;
//                                    BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:unZipFilePath preserveAttributes:YES overwrite:YES nestedZipLevel:0 password:nil error:&error delegate:nil progressHandler:nil completionHandler:nil];
                                    if (success) {
                                        // 文件管理器
//                                        NSLog(@"打开文件管理器: %@", unZipFilePath);
                                        [self previewFile:fileName filePath:unZipFilePath];
                                    } else {
                                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"解压失败，请重试"];
                                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                    }
                                } else {
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"解压路径创建失败，请重试"];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                            });
                        } else {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"获取文件失败，请重试"];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }
                    }];
                    
                    /*
                    [[CLAPIClient sharedInstance] GETDefaultContentType:fileUrl baseURLType:baseUrl parameters:nil animated:YES success:^(id _Nullable responseObject) {
                        NSLog(@"获取文件: %@", responseObject);
                        NSString *zipFilePath = [self tempDownloadZipPath:fileName];
                        NSLog(@"zipFilePath %@", zipFilePath);
                        if (responseObject && IsAvailableString(zipFilePath)) {
                            NSError *error = nil;
                            BOOL result = [(NSData *)responseObject writeToFile:zipFilePath options:NSDataWritingAtomic error:&error];
                            if (result && !error) {
                                NSString *unZipFilePath = [self tempUnzipPath:fileName];
                                NSLog(@"unZipFilePath 1 : %@", unZipFilePath);
                                if (IsAvailableString(unZipFilePath)) {
                                    BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:unZipFilePath preserveAttributes:YES overwrite:YES nestedZipLevel:0 password:nil error:nil delegate:nil progressHandler:nil completionHandler:nil];
                                    if (success) {
                                        // 文件管理器
                                        NSLog(@"打开文件管理器: %@", unZipFilePath);
                                    } else {
                                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"解压失败，请重试"];
                                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                    }
                                } else {
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"解压路径创建失败，请重试"];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }

                            } else {
                                NSLog(@"error: %@", error);
                                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"写入文件失败，请重试."];
                                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            }
                        } else {
                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"写入文件失败，请重试"];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }
                    } failure:^(NSError * _Nonnull error) {
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"获取文件失败，请重试"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }];
                     */
                } else {
                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"该类文件不支持查看"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-vpnLogin: 方法入参个数不正确"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        });
    }];
}

- (BOOL)checkSuffix:(NSString *)name {
    return ([name hasSuffix:@"doc"] || [name hasSuffix:@"docx"] || [name hasSuffix:@"xls"] || [name hasSuffix:@"xlsx"] || [name hasSuffix:@"ppt"] || [name hasSuffix:@"pptx"] || [name hasSuffix:@"pdf"] || [name hasSuffix:@"wps"] || [name hasSuffix:@"txt"] || [name hasSuffix:@"rtf"] || [name hasSuffix:@"htm"] || [name hasSuffix:@"html"] || [name hasSuffix:@"jpg"] || [name hasSuffix:@"jpeg"] || [name hasSuffix:@"png"] || [name hasSuffix:@"mp3"] || [name hasSuffix:@"mp4"] || [name hasSuffix:@"flv"]);
}

- (void)setFileMimeType:(NSString *)name {
    NSString *mimeType = @"";
    if ([name hasSuffix:@"doc"]) {
        mimeType = @"application/msword";
    } else if ([name hasSuffix:@"docx"]) {
        mimeType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    } else if ([name hasSuffix:@"xls"]) {
        mimeType = @"application/vnd.ms-excel";
    } else if ([name hasSuffix:@"xlsx"]) {
        mimeType = @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    } else if ([name hasSuffix:@"ppt"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([name hasSuffix:@"pptx"]) {
        mimeType = @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
    } else if ([name hasSuffix:@"pdf"]) {
        mimeType = @"application/pdf";
    }
    CLReachability.sharedInstance.fileMimeType = mimeType;
//    NSLog(@"文件类型: %@", mimeType);
}

- (NSString *)tempDownloadZipPath:(NSString *)fileName isZip:(BOOL)isZip {
    NSString *path = nil;
    if (!isZip) {
//        NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
//        NSString *realName = @"";
//        if (fileNames.count == 2) {
//            realName = fileNames.firstObject;
//        } else if (fileNames.count > 2) {
//            realName = fileNames[fileNames.count - 2];
//        } else {
//            realName = fileName;
//        }
//        fileName = [realName stringByAppendingPathComponent:fileName];
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    } else {
        path = [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], fileName];
    }
     
//    NSLog(@"保存目录地址: %@", path);
    NSError *error = nil;
    BOOL result = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    if (!error && result) {
        result = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        if (result) {
            return path;
        }
        return nil;
    } else {
        return nil;
    }
}

- (NSString *)tempUnzipPath:(NSString *)fileName isExist:(BOOL *)isExist {
    NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
    NSString *realName = @"";
    if (fileNames.count == 2) {
        realName = fileNames.firstObject;
    } else if (fileNames.count > 2) {
        realName = fileNames[fileNames.count - 2];
    } else {
        realName = fileName;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], realName];
//    NSLog(@"解压路径: %@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    BOOL result = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        long long fileSize = [attributes[@"NSFileSize"] longLongValue];
//        NSLog(@"存在路径，%lld", fileSize);
        if (fileSize != 0) {
//            NSLog(@"遍历");
            //遍历HomeFilePath文件夹下的子文件
            NSArray<NSString *> *subPathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error: NULL];
            if (subPathsArray && subPathsArray.count != 0) {
                for(NSString *str in subPathsArray){
//                    NSLog(@"存在文件: %@", str);
                    if (subPathsArray.count == 1 && [str isEqualToString:@".DS_Store"]) {
//                        NSLog(@"路径存在 ，无内容，删除");
                        *isExist = NO;
                        result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                        break;
                    } else {
//                        NSLog(@"存在文件");
                        *isExist = YES;
                        return path;
                    }
                }
            } else {
//                NSLog(@"路径存在，无内容，删除");
                *isExist = NO;
                result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        } else {
//            NSLog(@"路径存在，无内容，删除");
            *isExist = NO;
            result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    } else {
//        NSLog(@"不存在文件");
        *isExist = NO;
    }
    if (result && !error) {
        result = [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
        if (!error && result) {
            return url.path;
        }
        return nil;
    }
    return nil;
}

- (void)previewFile:(NSString *)fileName filePath:(NSString *)filePath {
    [Sandboxer shared].fileDeletable = YES;
    [Sandboxer shared].directoryDeletable = YES;
    [Sandboxer shared].homeFileURL = [NSURL fileURLWithPath:filePath];
    [Sandboxer shared].homeTitle = fileName;
    [[Sandboxer shared] trigger];
}

- (void)previewFile2:(NSString *)fileName filePath:(NSString *)filePath {
    self.previewFilePath = filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if ([QLPreviewController canPreviewItem:url]) {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.delegate = self;
        previewController.dataSource = self;
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if (rootViewController.presentedViewController) {
            rootViewController = rootViewController.presentedViewController;
        }
        [rootViewController presentViewController:previewController animated:YES completion:nil];
    } else {
        NSLog(@"无法文件预览");
    }
}

- (NSURLSessionDataTask*)createSessionWithRequest:(NSURLRequest*)aRequest withProxyConfig:(NSDictionary*)proxyConfigDic {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = proxyConfigDic;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask* sessionTask = [session dataTaskWithRequest:aRequest];
    return sessionTask;
}

//- (void)packageOpenWebView:(CDVInvokedUrlCommand *)command isOpenUrl:(BOOL)isOpenUrl {
//    if (isOpenUrl) {
//        WS(weakSelf)
//        [self refreshTokenBeforeOpenWebView:^(NSString * _Nullable guoShenAccessToken) {
//            if (IsAvailableString(guoShenAccessToken)) {
//                [weakSelf realPackageOpenWebView:command isOpenUrl:isOpenUrl];
//            } else {
//                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 刷新token失败."];
//                [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//            }
//        }];
//    } else {
//        [self realPackageOpenWebView:command isOpenUrl:isOpenUrl];
//    }
//}

- (void)realPackageOpenWebView:(CDVInvokedUrlCommand *)command isOpenUrl:(BOOL)isOpenUrl {
    NSArray *args = command.arguments;
    NSLog(@"参数: %@", command.arguments);
    if (args && args.count >= 1) {
        NSString *param = args.firstObject;
        NSString *title = @"";
        NSDictionary *downloadInfo = @{};
        NSString *colorString = @"#3b87f6";
        if (args.count >= 4) {
            // 增加导航栏颜色字段
            colorString = args[3];
            NSLog(@"args[3]: %@", args[3]);
        } else if (args.count >= 3) {
            title = args[1];
            if ([args[2] isKindOfClass:NSDictionary.class]) {
                downloadInfo = args[2];
            } else {
                downloadInfo = @{};
            }
        } else if (args.count >= 2) {
            title = args[1];
        }
        NSURL *url = [NSURL URLWithString:param];
        if (url) {
            NSString *http = [NSString stringWithFormat:@"%@://", url.scheme];
//            NSLog(@"url: %@, url.scheme: %@, http: %@, param: %@", url, url.scheme, http, param);
            NSRange range = [param rangeOfString:http];
            if (range.location != NSNotFound) {
                NSString *port = [param substringFromIndex:range.location + range.length];
                NSString *token = downloadInfo[@"token"];
                if (IsAvailableString(token)) {
                    port = [NSString stringWithFormat:@"%@&token=%@", port, token];
                }
//                NSLog(@"viewController.wwwFolderName: %@, viewController.startPage: %@", http, port);
                
                // 增加guoShenAccessToken
//                if (isOpenUrl) {
//                    if ([port containsString:@"?"]) {
//                        port = [port stringByAppendingString:@"&"];
//                    } else {
//                        port = [port stringByAppendingString:@"?"];
//                    }
//                    port = [port stringByAppendingString:[NSString stringWithFormat:@"?guoshenaccesstoken=%@", [CLNotificationInstance sharedInstance].guoShenAccessToken]];
//                    DLog(@"......webview url: %@", port);
//                }
                
                CLCDVViewController *viewController = [[CLCDVViewController alloc] init];
                viewController.configFile = @"config-custom-webview.xml";
//                viewController.wwwFolderName = http;
//                viewController.startPage = port;
                viewController.startPage = [NSString stringWithFormat:@"%@%@", http, port];
                viewController.navTitle = title;
                viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                nav.modalPresentationStyle = viewController.modalPresentationStyle;
                UIColor *mainColor = [UIColor colorWithHexString:IsAvailableString(colorString) ? colorString : @"#3b87f6"];
                
                if (@available(iOS 13.0, *)) {
                    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
                    [appearance configureWithOpaqueBackground];
                    appearance.backgroundColor = mainColor;
                    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    nav.navigationBar.standardAppearance = appearance;
                    nav.navigationBar.scrollEdgeAppearance=nav.navigationBar.standardAppearance;
                } else {
                    nav.navigationBar.barTintColor = mainColor;
                    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                }
                
                UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                if (rootViewController) {
                    if (rootViewController.presentedViewController) {
                        rootViewController = rootViewController.presentedViewController;
                    }
                    [rootViewController presentViewController:nav animated:YES completion:^{
                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"-openWebView: 方法调用成功"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }];
                }
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 方法入参地址不正确."];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } else {
//            NSLog(@"args: %@", args);
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 方法入参地址不正确"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"-openWebView: 方法入参不正确"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

//- (void)refreshTokenBeforeOpenWebView:(void(^)(NSString *__nullable guoShenAccessToken))completion {
//    NSDictionary *param = @{
//        @"accessToken": CLNotificationInstance.sharedInstance.guoShenAccessToken
//    };
//    [[CLAPIClient sharedInstance] POST:@"/external/refreshToken" baseURLType:kGuoShenBaseUrl parameters:param animated:NO success:^(NSDictionary * _Nullable responseObject) {
//        DLog(@"刷新token response: %@", responseObject);
//        if ([responseObject[@"success"] boolValue] && completion) {
//            if (completion) {
//                completion(responseObject[@"object"]);
//            }
//        } else {
//            if (completion) {
//                completion(nil);
//            }
//        }
//    } failure:^(NSError * _Nonnull error) {
//        DLog(@"刷新token error: %@", error);
//        if (completion) {
//            completion(nil);
//        }
//    }];
//}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
//    NSLog(@"response: %@, expectedContentLength: %lld", response, response.expectedContentLength);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
//    NSLog(@"data: %@", data);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
//    NSLog(@"error: %@", error);
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:self.previewFilePath];
}

@end
