//
//  CLWebViewController.m
//  jtdgdw
//
//  Created by eccl on 2024/3/15.
//  Copyright © 2024 ECCL. All rights reserved.
//

#import "CLWebViewController.h"
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "SDKWrapper.h"
#import "CLVPNManager.h"

/// WebViewController
@interface CLWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *url;

@end

@implementation CLWebViewController

- (void)setNavTitle:(NSString *)navTitle requestUrl:(NSString *)url {
    self.navTitle = navTitle;
    self.url = url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarItem];
    [self configWKWebView];
    
    NSString *waterMaskText = [NSString stringWithFormat:@"%@\n%@", CLNotificationInstance.sharedInstance.userName, CLNotificationInstance.sharedInstance.phoneNumber];
    TPWaterMaskView *waterMaskView = [[TPWaterMaskView alloc] initWithWaterMaskText:waterMaskText waterMaskTextAttribute:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:0.7], NSFontAttributeName: [UIFont systemFontOfSize:25.0]} slantAngle:(CGFloat)(-M_PI / 6)];
    [self.wkWebView addSubview:waterMaskView];
}

- (void)setupNavigationBarItem {
    // back button
    CGFloat buttonWidth = 30.0;
    CGFloat buttonHeight = 30.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    [button setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    [rightButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.title = self.navTitle;
}

- (void)configWKWebView {
    CGRect viewFrame = self.view.frame;
    CGFloat navigationBarHeight =  [self getNavigationHeight];
    viewFrame.origin.y = navigationBarHeight;
    viewFrame.size.height = CGRectGetHeight(self.view.frame) - navigationBarHeight;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:viewFrame configuration:config];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
    
    //WKWebView 的请求不基于 URL Loading System的请求，使用动态的方式注册scheme
//    Class cls = NSClassFromString(@"WKBrowsingContextController");
//    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
//    if ([cls respondsToSelector:sel]) {
//        // 通过http和https的请求，同理可通过其他的Scheme 但是要满足ULR Loading System
//        [cls performSelector:sel withObject:@"http"];
//        [cls performSelector:sel withObject:@"https"];
//    }
}

// 获取导航栏及状态栏高度
- (CGFloat)getNavigationHeight {
    CGFloat navigationHeight = 0;
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = UIApplication.sharedApplication.keyWindow.windowScene.statusBarManager;
        statusBarHeight = CGRectGetHeight(statusBarManager.statusBarFrame);
    } else {
        statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    }
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    navigationHeight = statusBarHeight + navigationBarHeight;
    //    NSLog(@"导航栏高度: %f", navigationHeight);
    return navigationHeight;
}

#pragma mark - Private Methods

- (void)goBack {
    NSLog(@"点击后退");
    if (self.wkWebView && self.wkWebView.canGoBack) {
        NSLog(@"可否后退 %d", self.wkWebView.canGoBack);
        [self.wkWebView goBack];
    } else {
        NSLog(@"webView 已退回至最后一页，返回app");
        [self dismiss];
    }
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[CLVPNManager sharedInstance] logout];
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"认证挑战 %s",__func__);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        
    }
}
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"创建新的 WKWebView 请求 %s",__func__);
    if (!navigationAction.targetFrame.isMainFrame) {
        [self.wkWebView loadRequest:navigationAction.request];
    }
    
    return nil;
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载 %s",__func__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"开始返回内容 %s",__func__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成 %s",__func__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败 %s",__func__);
    NSLog(@"error: %@", error);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"决定是否跳转 %s",__func__);
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate

@end
