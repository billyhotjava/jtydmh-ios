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


/// 使用 WKWebView 打开远程页面，仅用于 工业视频子应用使用
/// @param command [地址，标题，vpn登录信息{user, password}，导航栏颜色]
- (void)openWKWebView:(CDVInvokedUrlCommand *)command;

/// 打开附件（文档、文件、压缩包）
//    /// @param [in] 组好的fileUrl    fileName
/// @param [in] 组好的fileUrl/zip 数据    fileName
/// 注: 若是文件则直接使用内部浏览器打开展示；若为压缩包，则直接解压后，弹出解压后的文件管理器
- (void)openFile:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
