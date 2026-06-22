//
//  CLNetworkStatusTipView.m
//  jtydmh
//
//  Created by eccl on 2021/6/22.
//

#import "CLNetworkStatusTipView.h"
#import "CDVWKInAppBrowser.h"

@interface CLNetworkStatusTipView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *noNetworkbgView;
// 网络状态
@property (nonatomic, strong) UILabel *networkStatusLabel;
@property (nonatomic, strong) UILabel *networkStatusReadyLabel;
@property (nonatomic, strong) UIActivityIndicatorView *networkStatusActivityIndicatorView;
//@property (nonatomic, strong) UIImageView *networkReadyImageView;
// 网络环境
@property (nonatomic, strong) UILabel *networkEnvironmentLabel;
@property (nonatomic, strong) UILabel *networkEnvironmentReadyLabel;
@property (nonatomic, strong) UIActivityIndicatorView *networkEnvironmentActivityIndicatorView;
// vpn状态
@property (nonatomic, strong) UILabel *vpnStatusLabel;
@property (nonatomic, strong) UILabel *vpnStatusReadyLabel;
//@property (nonatomic, strong) UIImageView *vpnReadyImageView;
@property (nonatomic, strong) UIActivityIndicatorView *vpnStatusActivityIndicatorView;
// 网络切换完毕
@property (nonatomic, strong) UILabel *networkCheckFinishedLabel;
// 无网络
@property (nonatomic, strong) UILabel *noNetworkTipsLabel;
//@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation CLNetworkStatusTipView

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        self.canShow = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat spaceX = 20.0;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, 0, SCREEN_WIDTH - 2 * spaceX, 0)];
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8.0;
    [self addSubview:self.bgView];
    
    CGFloat spaceY = 20.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, spaceY, CGRectGetWidth(self.bgView.frame), 30.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.textColor = [UIColor colorWithHexString:@"#3072E2"];
    titleLabel.text = kNetworkStatusCheckTitle;
    [self.bgView addSubview:titleLabel];
    
    CGFloat labelHeight = 40.0;
    CGFloat labelSpaceX = 20.0;
    CGFloat labelSpaceY = 10.0;
    CGFloat titleLabelWidth = (CGRectGetWidth(self.bgView.frame) - labelSpaceX * 2) * 1.8 / 3;
    CGFloat valueLabelWidth = (CGRectGetWidth(self.bgView.frame) - labelSpaceX * 2) / 3;
    self.networkStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelSpaceX, CGRectGetMaxY(titleLabel.frame) + labelSpaceY, titleLabelWidth, labelHeight)];
    self.networkStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.networkStatusLabel.backgroundColor = UIColor.clearColor;
    self.networkStatusLabel.text = kNetworkStatusCheckTip;
    self.networkStatusLabel.textColor = UIColor.blackColor;
    [self.bgView addSubview:self.networkStatusLabel];
    
    self.networkStatusReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.networkStatusLabel.frame), CGRectGetMinY(self.networkStatusLabel.frame), valueLabelWidth, labelHeight)];
    self.networkStatusReadyLabel.textAlignment = NSTextAlignmentCenter;
    self.networkStatusReadyLabel.backgroundColor = UIColor.clearColor;
    self.networkStatusReadyLabel.textColor = [UIColor colorWithHexString:@"#3072E2"];
    self.networkStatusReadyLabel.hidden = YES;
    [self.bgView addSubview:self.networkStatusReadyLabel];
    
    self.networkStatusActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.networkStatusActivityIndicatorView.center = self.networkStatusReadyLabel.center;
    [self.networkStatusActivityIndicatorView startAnimating];
    [self.bgView addSubview:self.networkStatusActivityIndicatorView];
    
    self.networkEnvironmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelSpaceX, CGRectGetMaxY(self.networkStatusLabel.frame) + labelSpaceY, titleLabelWidth, labelHeight)];
    self.networkEnvironmentLabel.textAlignment = NSTextAlignmentCenter;
    self.networkEnvironmentLabel.backgroundColor = UIColor.clearColor;
    self.networkEnvironmentLabel.text = kNetworkEnvironmentCheckTip;
    self.networkEnvironmentLabel.textColor = UIColor.blackColor;
    [self.bgView addSubview:self.networkEnvironmentLabel];
    
    self.networkEnvironmentReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.networkEnvironmentLabel.frame), CGRectGetMinY(self.networkEnvironmentLabel.frame), valueLabelWidth, labelHeight)];
    self.networkEnvironmentReadyLabel.textAlignment = NSTextAlignmentCenter;
    self.networkEnvironmentReadyLabel.backgroundColor = UIColor.clearColor;
    self.networkEnvironmentReadyLabel.textColor = [UIColor colorWithHexString:@"#3072E2"];
    self.networkEnvironmentReadyLabel.hidden = YES;
    [self.bgView addSubview:self.networkEnvironmentReadyLabel];
    
    self.networkEnvironmentActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.networkEnvironmentActivityIndicatorView.center = self.networkEnvironmentReadyLabel.center;
    [self.networkEnvironmentActivityIndicatorView startAnimating];
    [self.bgView addSubview:self.networkEnvironmentActivityIndicatorView];
    
    self.vpnStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelSpaceX, CGRectGetMaxY(self.networkEnvironmentLabel.frame) + labelSpaceY, titleLabelWidth, labelHeight)];
    self.vpnStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.vpnStatusLabel.backgroundColor = UIColor.clearColor;
    self.vpnStatusLabel.text = kVPNStatusCheckTip;
    self.vpnStatusLabel.textColor = UIColor.blackColor;
    [self.bgView addSubview:self.vpnStatusLabel];
    
    self.vpnStatusReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.vpnStatusLabel.frame), CGRectGetMinY(self.vpnStatusLabel.frame), valueLabelWidth, labelHeight)];
    self.vpnStatusReadyLabel.textAlignment = NSTextAlignmentCenter;
    self.vpnStatusReadyLabel.backgroundColor = UIColor.clearColor;
    self.vpnStatusReadyLabel.textColor = [UIColor colorWithHexString:@"#3072E2"];
    self.vpnStatusReadyLabel.hidden = YES;
    [self.bgView addSubview:self.vpnStatusReadyLabel];
    
    self.vpnStatusActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.vpnStatusActivityIndicatorView.center = self.vpnStatusReadyLabel.center;
    [self.vpnStatusActivityIndicatorView startAnimating];
    [self.bgView addSubview:self.vpnStatusActivityIndicatorView];
    
    self.networkCheckFinishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.vpnStatusLabel.frame) + labelSpaceY, CGRectGetWidth(self.bgView.frame), labelHeight)];
    self.networkCheckFinishedLabel.textAlignment = NSTextAlignmentCenter;
    self.networkCheckFinishedLabel.text = kNetworkStatusCheckFinishedTip;
    self.networkCheckFinishedLabel.backgroundColor = UIColor.clearColor;
    self.networkCheckFinishedLabel.textColor = [UIColor colorWithRed:0.96 green:0.72 blue:0.42 alpha:1.00];
    self.networkCheckFinishedLabel.hidden = YES;
    [self.bgView addSubview:self.networkCheckFinishedLabel];
    
    
    // 无网
    self.noNetworkbgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, 0, SCREEN_WIDTH - 2 * spaceX, 0)];
    self.noNetworkbgView.backgroundColor = UIColor.whiteColor;
    self.noNetworkbgView.layer.masksToBounds = YES;
    self.noNetworkbgView.layer.cornerRadius = 8.0;
    [self addSubview:self.noNetworkbgView];
    
    self.noNetworkTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelSpaceX, spaceY, CGRectGetWidth(self.noNetworkbgView.frame) - labelSpaceX * 2, labelHeight * 2)];
    self.noNetworkTipsLabel.textAlignment = NSTextAlignmentCenter;
    self.noNetworkTipsLabel.backgroundColor = UIColor.clearColor;
    self.noNetworkTipsLabel.numberOfLines = 0;
    self.noNetworkTipsLabel.text = kNetworkStatusUnavailableTip;
    self.noNetworkTipsLabel.textColor = UIColor.blackColor;
    [self.noNetworkbgView addSubview:self.noNetworkTipsLabel];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat buttonSpaceX = 40.0;
    CGFloat buttonWidth = 100.0;
    settingButton.frame = CGRectMake(buttonSpaceX, CGRectGetMaxY(self.noNetworkTipsLabel.frame) + 30.0, buttonWidth, 40.0);
    [settingButton setTitle:@"解决方案" forState:UIControlStateNormal];
    [settingButton setTintColor:UIColor.whiteColor];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [settingButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#3072E2"]] forState:UIControlStateNormal];
    settingButton.layer.masksToBounds = YES;
    settingButton.layer.cornerRadius = 3.0;
    [settingButton addTarget:self action:@selector(gotoNetworkSettingPage) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetworkbgView addSubview:settingButton];
    
    // 离线模式
    UIButton *offlineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    offlineButton.frame = CGRectMake((CGRectGetWidth(self.noNetworkbgView.frame) - buttonWidth - buttonSpaceX), CGRectGetMinY(settingButton.frame), buttonWidth, CGRectGetHeight(settingButton.frame));
    [offlineButton setTitle:@"进入离线" forState:UIControlStateNormal];
    [offlineButton setTintColor:UIColor.whiteColor];
    offlineButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [offlineButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#3072E2"]] forState:UIControlStateNormal];
    offlineButton.layer.masksToBounds = YES;
    offlineButton.layer.cornerRadius = 3.0;
    [offlineButton addTarget:self action:@selector(gotoOfflineMode) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetworkbgView addSubview:offlineButton];
    
    CGRect noNetworkbgViewRect = self.noNetworkbgView.frame;
    noNetworkbgViewRect.size.height = CGRectGetMaxY(settingButton.frame) + 20.0;
    noNetworkbgViewRect.origin.y = (SCREEN_HEIGHT - CGRectGetHeight(noNetworkbgViewRect)) / 2;
    self.noNetworkbgView.frame = noNetworkbgViewRect;
    self.noNetworkbgView.hidden = YES;
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)networkCheckFinishedUI:(BOOL)finished {
    self.networkCheckFinishedLabel.hidden = !finished;
    CGRect bgViewRect = self.bgView.frame;
    bgViewRect.size.height = CGRectGetMaxY(finished ? self.networkCheckFinishedLabel.frame : self.vpnStatusLabel.frame) + 20.0;
    bgViewRect.origin.y = (SCREEN_HEIGHT - CGRectGetHeight(bgViewRect)) / 2;
    self.bgView.frame = bgViewRect;
    if (finished) {
        DLog(@"监测完成，修改界面");
        [self performSelector:@selector(hide) withObject:nil afterDelay:2.0];
    }
}

- (void)changedUIWithHasNetwork:(BOOL)hasNetwork {
    [self resetUI];
    self.bgView.hidden = !hasNetwork;
    self.noNetworkbgView.hidden = hasNetwork;
    if (hasNetwork) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DLog(@"修改网络状态界面");
            self.networkStatusReadyLabel.text = kNetworkStatusConnectedValue;
            self.networkStatusReadyLabel.hidden = NO;
            [self.networkStatusActivityIndicatorView stopAnimating];
        });
    }
}

- (void)setContentWithStatus:(CLNetworkStatusType)status {
    BOOL hasNetwork = NO;
    switch (status) {
        case CLNetworkStatusUnkown: {
//            networkTip = kNetworkStatusUnavailableTip;
            hasNetwork = NO;
            break;
        }
            
        case CLNetworkStatusNotReachable: {
//            networkTip = kNetworkStatusUnavailableTip;
            hasNetwork = NO;
            break;
        }
            
        case CLNetworkStatusViaWWAN: {
            hasNetwork = YES;
            break;
        }
            
        case CLNetworkStatusViaWiFi: {
            hasNetwork = YES;
            break;
        }
            
        default:
            break;
    }
    [self changedUIWithHasNetwork:hasNetwork];
}

- (void)resetUI {
    [self networkCheckFinishedUI:NO];
    self.networkStatusReadyLabel.text = @"";
    self.networkStatusReadyLabel.hidden = YES;
    self.networkEnvironmentReadyLabel.text = @"";
    self.networkEnvironmentReadyLabel.hidden = YES;
    self.vpnStatusReadyLabel.text = @"";
    self.vpnStatusReadyLabel.hidden = YES;
    [self.networkStatusActivityIndicatorView startAnimating];
    [self.networkEnvironmentActivityIndicatorView startAnimating];
    [self.vpnStatusActivityIndicatorView startAnimating];
}

- (void)show:(CLNetworkStatusType)status {
    if (!self.canShow) {
        DLog(@"不显示网络切换弹窗");
        return;
    }
    [self setContentWithStatus:status];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[@0, @0.5, @1];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    [self.bgView.layer addAnimation:animation forKey:@"ShowAnimation"];
    
    [window.rootViewController.view addSubview:self];
    [window bringSubviewToFront:self];
}

- (void)hide {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[@0, @0.5, @1];
    animation.fillMode = kCAFillModeRemoved;
    NSTimeInterval timeInterval = 0.2;
    animation.duration = timeInterval;
    [self.bgView.layer addAnimation:animation forKey:@"DismissAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [self closeNetworkSettingPage];
        [self resetUI];
    });
//    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:timeInterval];
//    [self performSelector:@selector(closeNetworkSettingPage) withObject:nil afterDelay:timeInterval];
//    [self performSelector:@selector(resetUI) withObject:nil afterDelay:timeInterval];
}

- (void)checkNetworkEnvironmentStatus:(CLNetworkEnvironmentStatus)status {
    [self.networkEnvironmentActivityIndicatorView stopAnimating];
    switch (status) {
        case CLNetworkGuoShenLAN:
            self.networkEnvironmentReadyLabel.text = kNetworkGuoShenLANValue;
            break;
        
        case CLNetworkWLAN:
            self.networkEnvironmentReadyLabel.text = kNetworkWLANValue;
            break;
    }
    self.networkEnvironmentReadyLabel.hidden = NO;
}

- (void)changeVPNStatus:(CLVPNStatus)status {
    [self.vpnStatusActivityIndicatorView stopAnimating];
    switch (status) {
        case CLVPNConnecting:
            self.vpnStatusReadyLabel.text = kVPNConnectingTip;
            break;
            
        case CLVPNConnected:
            self.vpnStatusReadyLabel.text = kVPNConnectedTip;
            break;
            
        case CLVPNReConnecting:
            self.vpnStatusReadyLabel.text = kVPNReConnectingTip;
            break;
            
        case CLVPNDisconnect:
            self.vpnStatusReadyLabel.text = kVPNDisconnectTip;
            break;
            
        case CLVPNConnectFail:
            self.vpnStatusReadyLabel.text = kVPNDisconnectTip;
            break;
    }
    self.vpnStatusReadyLabel.hidden = NO;
    if (status != CLVPNReConnecting) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self networkCheckFinishedUI:YES];
        });
    }
}

#pragma mark - Action Methods
/// 打开网络设置页面
- (void)gotoNetworkSettingPage {
    [self inlineNetworkSettingPage:YES];
}

- (void)gotoOfflineMode {
    NSLog(@"离线模式");
    NSDictionary *notificationInfo = @{
        @"identifier": @"/offlineapp"
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidReceiveLocalNotification" object:nil userInfo:notificationInfo];
    [self hide];
}

- (void)closeNetworkSettingPage {
    [self inlineNetworkSettingPage:NO];
}

- (void)inlineNetworkSettingPage:(BOOL)open {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"network_setting" ofType:@"html"];
    if (IsAvailableString(path)) {
        CDVInvokedUrlCommand *command = [[CDVInvokedUrlCommand alloc] initWithArguments:@[path, @"_blank", @"location=no,toolbar=yes,toolbarposition=top,closebuttoncaption=关闭,closebuttoncolor=#000000,toolbarcolor=#FFFFFF,hidden=yes"] callbackId:NSStringFromClass(CDVWKInAppBrowser.class) className:NSStringFromClass(CDVWKInAppBrowser.class) methodName:open ? @"open" : @"close"];
        if (open) {
            [[CDVWKInAppBrowser getInstance] open:command];
        } else {
            [[CDVWKInAppBrowser getInstance] close:command];
        }
        
    } else {
        DLog(@"未找到 network_setting.html 文件");
    }
}

@end
