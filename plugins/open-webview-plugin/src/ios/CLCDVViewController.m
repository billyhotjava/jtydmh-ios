//
//  CLCDVViewController.m
//  CordovaTest
//
//  Created by eccl on 2021/7/8.
//

#import "CLCDVViewController.h"
#import "CDVUrlProtocolCustom.h"
#import <Cordova/CDVPlugin.h>

@interface CLCDVViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation CLCDVViewController

- (void)viewDidLoad {
    
    [NSURLProtocol registerClass:CDVUrlProtocolCustom.class];
    
    [super viewDidLoad];
    
    CGRect viewFrame = self.webView.frame;
    CGFloat navigationBarHeight =  [self getNavigationHeight];
    viewFrame.origin.y = navigationBarHeight;
    viewFrame.size.height = CGRectGetHeight(self.view.frame) - navigationBarHeight;
    self.webView.frame = viewFrame;
    NSLog(@"self.webView frame !!!!!!!: %@", NSStringFromCGRect(self.webView.frame));
    
    // 开始加载 url
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationPageDidStartLoad:) name:CDVPluginResetNotification object:nil];
    // 加载完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationPageDidFinishLoad:) name:CDVPageDidLoadNotification object:nil];
    // 加载失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationPageDidFailLoad:) name:CDVPageDidLoadFailedNotification object:nil];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupNavigationBarItem];
    [self showActivityIndicatorView];
}

- (void)setupNavigationBarItem {
    // back button
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:UIColor.blackColor];
    
    /*
    // right button
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = 40.0;
    CGFloat buttonHeight = 30.0;
    goBackButton.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    goBackButton.enabled = NO;
    [goBackButton setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goBackBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackButton];
    
    UIButton *goForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goForwardButton.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    goForwardButton.enabled = NO;
    [goForwardButton setImage:[UIImage imageNamed:@"go_forward"] forState:UIControlStateNormal];
    [goForwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goForwardBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goForwardButton];
    
    self.navigationItem.rightBarButtonItems = @[goForwardBarButtonItem, goBackBarButtonItem];
     */
}

- (void)showActivityIndicatorView {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat spinnerWidth = 20.0;
    self.spinner.frame = CGRectMake(CGRectGetMidX(self.webView.frame) - spinnerWidth / 2, CGRectGetMidY(self.webView.frame) - spinnerWidth / 2, spinnerWidth , spinnerWidth);
    self.spinner.alpha = 1.000;
    self.spinner.autoresizesSubviews = YES;
    self.spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
    self.spinner.clearsContextBeforeDrawing = NO;
    self.spinner.clipsToBounds = NO;
    self.spinner.contentMode = UIViewContentModeScaleToFill;
    self.spinner.hidden = NO;
    self.spinner.hidesWhenStopped = YES;
    self.spinner.multipleTouchEnabled = NO;
    self.spinner.opaque = NO;
    self.spinner.userInteractionEnabled = NO;
    [self.spinner stopAnimating];
    [self.view addSubview:self.spinner];
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
    NSLog(@"导航栏高度: %f", navigationHeight);
    return navigationHeight;
}

#pragma mark - Action Methods
/*
- (void)goBack {
    NSLog(@"点击后退");
    UIWebView *webView = (UIWebView *)self.webView;
    NSLog(@"可否后退 %d", webView.canGoBack);
    if (webView && webView.canGoBack) {
        [webView goBack];
    }
}

- (void)goForward {
    NSLog(@"点击前进");
    UIWebView *webView = (UIWebView *)self.webView;
    NSLog(@"可否前进 %d", webView.canGoForward);
    if (webView && webView.canGoForward) {
        [webView goForward];
    }
}
*/
- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webViewShouldLoadingWithNotification:(NSNotification *)notification {
    if (notification.object && [notification.object isKindOfClass:UIWebView.class]) {
        return YES;
    }
    return NO;
}

#pragma mark - NSNotificationCenter
// 开始加载 url
- (void)applicationPageDidStartLoad:(NSNotification *)notification {
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", self.wwwFolderName, self.startPage];
    
    if ([self webViewShouldLoadingWithNotification:notification] && self.spinner) {
        [self.spinner startAnimating];
    }
}

// 加载完成
- (void)applicationPageDidFinishLoad:(NSNotification *)notification {
    if ([self webViewShouldLoadingWithNotification:notification] && self.spinner && self.spinner.isAnimating) {
        [self.spinner stopAnimating];
    }
    
    [(UIWebView *)notification.object stringByEvaluatingJavaScriptFromString:@"function injectionJS() { var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.src = 'http://injection/cordova.js';"
     "document.getElementsByTagName('head')[0].appendChild(script);"
     "document.body.addpendChild(script);}"];
    [(UIWebView *)notification.object stringByEvaluatingJavaScriptFromString:@"injectionJS()"];
    
    [(UIWebView *)notification.object stringByEvaluatingJavaScriptFromString:@"function injectionJSPlugins() { var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.src = 'http://injection/cordova_plugins.js';"
     "document.getElementsByTagName('head')[0].appendChild(script);"
     "document.body.addpendChild(script);}"];
    [(UIWebView *)notification.object stringByEvaluatingJavaScriptFromString:@"injectionJSPlugins()"];
    
    NSLog(@"self.view frame !!!!!!!: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"self.webView frame !!!!!!!: %@", NSStringFromCGRect(self.webView.frame));
    
    NSLog(@"((UIWebView *)notification.object).document.title !!!!!!: %@", [((UIWebView *)notification.object) stringByEvaluatingJavaScriptFromString:@"document.title"]);
    
    NSArray *rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *goBackBarButtonItem = rightBarButtonItems.firstObject;
    UIBarButtonItem *goForwardBarButtonItem = rightBarButtonItems.lastObject;
    if (notification.object && [notification.object isKindOfClass:UIWebView.class]) {
        UIWebView *webView = (UIWebView *)notification.object;
        NSLog(@"加载完成 是否可回退、前进: canGoBack: %d, canGoForward: %d", webView.canGoBack, webView.canGoForward);
        ((UIButton *)goBackBarButtonItem.customView).enabled = webView.canGoBack;
        ((UIButton *)goForwardBarButtonItem.customView).enabled = webView.canGoForward;
        
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

// 加载失败
- (void)applicationPageDidFailLoad:(NSNotification *)notification {
    if (self.spinner && self.spinner.isAnimating) {
        [self.spinner stopAnimating];
    }
}

@end
