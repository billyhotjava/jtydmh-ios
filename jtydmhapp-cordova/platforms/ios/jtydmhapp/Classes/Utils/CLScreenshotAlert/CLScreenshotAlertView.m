//
//  CLScreenshotAlertView.m
//  jtydmhapp
//
//  Created by eccl on 2022/5/18.
//

#import "CLScreenshotAlertView.h"
#import "UIView+TPAddEvent.h"
#import "FSTextView/FSTextView.h"
#import "CLAPIClient.h"
#import "SDKWrapper.h"
#import "CLNotificationInstance.h"
#import <sys/utsname.h>
#import "UIImage+Wechat.h"

@interface CLScreenshotAlertView () <NSURLSessionDelegate>

@property (nonatomic, strong) NSData *screenshotImageData;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic) BOOL showing;
@property (nonatomic) BOOL hadMoved;

@property (nonatomic, copy) NSString *uploadFileBoundary;
@property (nonatomic, strong) NSMutableData* reciveDataBuffer;
//@property (nonatomic, strong) NSString* reciveDataMime;
//@property (nonatomic, strong) NSString* reciveDataTexEncodingName;

@end

@implementation CLScreenshotAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initSubViews];
//        CFUUIDRef uuid = CFUUIDCreate(NULL);
//        self.uploadFileBoundary = [(__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        CFRelease(uuid);
//        DLog(@"!!! boundary: %@", self.uploadFileBoundary);
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        DLog(@"screen shot alert init...");
    });
    return sharedInstance;
}

- (void)initSubViews {
//    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
//    self.showing = NO;
//    self.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    CGFloat spaceX = 18.0;
//    CGFloat spaceY = 100.0;
//    CGFloat bgViewWidth = SCREEN_WIDTH - spaceX * 2;
//    CGFloat bgViewHeight = SCREEN_HEIGHT - spaceY * 2;
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, spaceY, bgViewWidth, bgViewHeight)];
//    bgView.backgroundColor = UIColor.whiteColor;
//    bgView.layer.cornerRadius = 10.0;
//    [bgView addTarget:self action:@selector(hiddenKeyboard)];
//    [self addSubview:bgView];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, bgViewWidth, 30.0)];
//    titleLabel.text = @"截屏提示";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = UIColor.whiteColor;
//    titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [bgView addSubview:titleLabel];
//
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(titleLabel.frame) + 10.0, bgViewWidth - spaceX * 2, 0.0)];
//    textLabel.textAlignment = NSTextAlignmentCenter;
//    textLabel.text = @"您正在进行截屏操作，是否要进行问题反馈？";
//    textLabel.numberOfLines = 0;
//    textLabel.backgroundColor = UIColor.whiteColor;
//    textLabel.font = [UIFont systemFontOfSize:14.0];
//    CGFloat textLabelHeight = [self heightForControl:textLabel withLimitWidth:CGRectGetWidth(textLabel.frame)];
//    CGRect textLabelFrame = textLabel.frame;
//    textLabelFrame.size.height = textLabelHeight;
//    textLabel.frame = textLabelFrame;
//    [bgView addSubview:textLabel];
//
//    CGFloat imageViewWidth = SCREEN_WIDTH / 3;
//    CGFloat imageViewSpaceX = (CGRectGetWidth(bgView.frame) - imageViewWidth) / 2;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewSpaceX, CGRectGetMaxY(textLabel.frame) + 20.0, imageViewWidth, SCREEN_HEIGHT / 3)];
//    imageView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
//    imageView.layer.borderWidth = 1.0;
//    [bgView addSubview:imageView];
//    self.imageView = imageView;
//
////    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(imageView.frame) + 20.0, CGRectGetWidth(bgView.frame) - spaceX * 2, 120.0)];
////    textView.backgroundColor = UIColor.groupTableViewBackgroundColor;
////    textView.layer.cornerRadius = 5.0;
////    [bgView addSubview:textView];
//
//    FSTextView *textView = [FSTextView textView];
//    textView.frame = CGRectMake(spaceX, CGRectGetMaxY(imageView.frame) + 20.0, CGRectGetWidth(bgView.frame) - spaceX * 2, 120.0);
//    textView.font = [UIFont systemFontOfSize:14.0];
//    textView.placeholder = @"请输入反馈内容...";
//    textView.borderWidth = 1.f;
//    textView.borderColor = UIColor.groupTableViewBackgroundColor;
//    textView.cornerRadius = 8.f;
//    [bgView addSubview:textView];
//    self.textView = textView;
//
//    // 添加输入改变Block回调.
//    [textView addTextDidChangeHandler:^(FSTextView *textView) {
//
//    }];
//    // 添加到达最大限制Block回调.
//    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
//
//    }];
//
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    cancelButton.layer.masksToBounds = YES;
//    CGFloat buttonHeight = 40.0;
//    cancelButton.layer.cornerRadius = buttonHeight / 2;
//    UIColor *titleColor = UIColor.whiteColor;
//    [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
//    CGFloat buttonWidth = (SCREEN_WIDTH - spaceX * 2) * 3 / 4 / 2;
//    CGFloat buttonTop = CGRectGetMaxY(textView.frame) + 20.0;
//    cancelButton.frame = CGRectMake(spaceX, buttonTop, buttonWidth, buttonHeight);
//    UIColor *buttonBgColor = [UIColor colorWithHexString:@"#206EEA"];
//    [cancelButton setBackgroundImage:[self createImageWithColor:buttonBgColor] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:cancelButton];
//
//    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [okButton setTitle:@"确定" forState:UIControlStateNormal];
//    okButton.titleLabel.font = cancelButton.titleLabel.font;
//    okButton.layer.masksToBounds = YES;
//    okButton.layer.cornerRadius = cancelButton.layer.cornerRadius;
//    [okButton setTitleColor:titleColor forState:UIControlStateNormal];
//    okButton.frame = CGRectMake(CGRectGetWidth(bgView.frame) - buttonWidth - spaceX, buttonTop, buttonWidth, buttonHeight);
//    [okButton setBackgroundImage:[self createImageWithColor:buttonBgColor] forState:UIControlStateNormal];
//    [okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:okButton];
//
//    CGRect bgViewFrame = bgView.frame;
//    bgViewFrame.size.height = CGRectGetMaxY(cancelButton.frame) + 30.0;
//    bgViewFrame.origin.y = (SCREEN_HEIGHT - CGRectGetHeight(bgViewFrame)) / 2;
//    bgView.frame = bgViewFrame;
//    self.bgView = bgView;
}

- (void)showScreenshotAlert {
//    if (self.showing) {
//        return;
//    }
//    self.screenshotImageData = [self imageDataScreenShot];
//    NSLog(@"图片Data: %lu",(unsigned long)self.screenshotImageData.length);
//    self.showing = YES;
//    UIImage *screenshotImage = [UIImage imageWithData:self.screenshotImageData];
//    self.imageView.image = screenshotImage;
//
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
//    animation.keyTimes = @[@0, @0.3, @0.5];
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    animation.duration = 0.5;
//    [self.bgView.layer addAnimation:animation forKey:@"ShowAnimation"];
//
//    UIWindow *window = UIApplication.sharedApplication.keyWindow;
//    [window addSubview:self];
//    [window bringSubviewToFront:self];
}

- (BOOL)isShowing {
    return self.showing;
}

- (void)hide {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[@0, @0.5];
    animation.fillMode = kCAFillModeRemoved;
    NSTimeInterval timeInterval = 0.5;
    animation.duration = timeInterval;
    [self.bgView.layer addAnimation:animation forKey:@"DismissAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.showing = NO;
        [self removeFromSuperview];
    });
}

- (void)resetUI {
    self.imageView.image = nil;
    self.textView.text = @"";
}

//- (NSData *)imageDataScreenShot {
//    CGSize imageSize = CGSizeZero;
//    imageSize = [UIScreen mainScreen].bounds.size;
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, window.center.x, window.center.y);
//        CGContextConcatCTM(context, window.transform);
//        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//        } else {
//            [window.layer renderInContext:context];
//        }
//        CGContextRestoreGState(context);
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return UIImageJPEGRepresentation([image wcSessionCompress], 0.1);
//}

- (CGFloat)heightForControl:(UILabel *)label withLimitWidth:(CGFloat)limitWidth {
    NSDictionary *attrbute = @{NSFontAttributeName : label.font};
    return [label.text boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

// UIColor 转UIImage
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

#pragma mark - Event Methods
- (void)hiddenKeyboard {
    [self endEditing:YES];
}

- (void)cancelAction {
    [self hide];
}

- (void)okAction {
    [self uploadFile];
    return;
//    if (!IsAvailableString(self.textView.text)) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入反馈内容" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self.textView becomeFirstResponder];
//        }]];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    NSString *system = [NSString stringWithFormat:@"%@%@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];
//    NSDictionary *headers = @{
//        @"Content-Type": @"multipart/form-data"
//    };
//    NSDictionary *param = @{
//        @"mobileVersion": deviceModel,
//        @"sysVersion": system,
//        @"userCode": [CLNotificationInstance sharedInstance].userCode,
//        @"feedbackContent": self.textView.text,
//        @"file": self.screenshotImageData,
//        @"name": @"file",
//        @"fileName": @"jieping-iOS.jpeg",
//        @"mimeType": @"application/octet-stream",
//    };
//    [[CLAPIClient sharedInstance] UPLOAD:@"/feedback/updateFeedback" baseURLType:CLAPIBaseNewGuoShenLANURL headers:headers parameters:param animated:YES success:^(NSDictionary * _Nullable responseObject) {
//        NSLog(@"截屏反馈接口成功: %@", responseObject);
//        [self hide];
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"截屏反馈接口失败: %@", error);
//    }];
}

- (void)checkNetwork {
    if(![[SDKWrapper getInstance] isConnected]) {
        return;
    }
    NSURL* url = [NSURL URLWithString:CLAPIBaseNewGuoShenLANURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [self createSessionWithConfigurationWithTimeoutInterval:0.2f];
    NSURLSessionDataTask* sessionTask = [session dataTaskWithRequest:request];
    [sessionTask resume];
}

- (NSURLSession *)createSessionWithConfigurationWithTimeoutInterval:(NSTimeInterval)timeOutInterval {
    NSDictionary *proxyConfigDic = nil;
    NSInteger proxyPort = [[SDKWrapper getInstance] queryHttpProxyPort];
    if(proxyPort) {
        NSString *host = @"127.0.0.1";
        proxyConfigDic = @{(NSString*)kCFStreamPropertyHTTPProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPProxyPort: @(proxyPort),
                           (NSString*)kCFNetworkProxiesHTTPEnable:@YES,
                           (NSString*)kCFStreamPropertyHTTPSProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPSProxyPort:@(proxyPort)
                           };
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = proxyConfigDic;
    config.timeoutIntervalForRequest = timeOutInterval;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

- (void)uploadFile {
    NSString *urlString = [NSString stringWithFormat:@"%@/feedback/updateFeedback", CLAPIBaseNewGuoShenLANURL];
//    NSString *urlString = @"http://10.150.50.241:8802/feedback/updateFeedback";
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // boundary
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.uploadFileBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [self createSessionWithConfigurationWithTimeoutInterval:30.0f];
    NSData *requestData = [self getSendDataWithFile];
    NSURLSessionUploadTask *uploadTask =  [session uploadTaskWithRequest:request fromData:requestData];
    [uploadTask resume];
}

- (NSData *)getSendDataWithFile {
    NSString *userCode = [CLNotificationInstance sharedInstance].userCode;
    if (!IsAvailableString(userCode)) {
        return nil;
    }
    NSMutableData *data = [NSMutableData data];
    // 表单拼接
    NSMutableString *headerStrM = [NSMutableString string];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [headerStrM appendString:[self fileUploadContentWithName:@"mobileVersion" value:deviceModel isImage:NO]];
    
    NSString *system = [NSString stringWithFormat:@"%@%@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];
    [headerStrM appendString:[self fileUploadContentWithName:@"sysVersion" value:system isImage:NO]];
    
    [headerStrM appendString:[self fileUploadContentWithName:@"userCode" value:userCode isImage:NO]];
    
    [headerStrM appendString:[self fileUploadContentWithName:@"feedbackContent" value:self.textView.text isImage:NO]];
    
    // name：表单控件名称  filename：上传文件名
    NSString *fileName = [[NSString alloc] initWithFormat:@"file\";filename=\"Screenshot_iOS_%@.jpg", [self getCurrentDate]];
    [headerStrM appendString:[self fileUploadContentWithName:fileName value:nil isImage:YES]];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    // 文件内容
    NSData *fileData = self.screenshotImageData;
    [data appendData:fileData];
//    [data appendData:UIImageJPEGRepresentation([UIImage imageNamed:@"back_btn"], 1.0)];
    
    // boundary
    NSString *footerStrM = [NSString stringWithFormat:@"\r\n--%@--\r\n", self.uploadFileBoundary];
    [data appendData:[footerStrM  dataUsingEncoding:NSUTF8StringEncoding]];
    
    DLog(@"上传data: %lu", (unsigned long)data.length);
    return data;
}

- (NSString *)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
     [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
     [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)fileUploadContentWithName:(NSString *)name value:(NSString *__nullable)value isImage:(BOOL)isImage {
    NSMutableString *headerStrM = [NSMutableString string];
    // 表单拼接 boundary
    if (isImage) {
        [headerStrM appendFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";\r\nContent-Type:image/jpg;charset=UTF-8\r\nContent-Transfer-Encoding:8bit\r\n\r\n", self.uploadFileBoundary, name];
    } else {
        [headerStrM appendFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";\r\nContent-Type:multipart/form-data;charset=UTF-8\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n\r\n", self.uploadFileBoundary, name, value];
    }
    return headerStrM;
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    self.reciveDataBuffer = [NSMutableData data];
//    self.reciveDataMime = response.MIMEType;
//    self.reciveDataTexEncodingName = response.textEncodingName;
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    //NSLog(@"data = %@", data);
    [self.reciveDataBuffer appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if(!error) {
        DLog(@"didReceiveData -> %ld", (unsigned long)self.reciveDataBuffer.length);
        NSString *str = [[NSString alloc] initWithData:self.reciveDataBuffer encoding:NSUTF8StringEncoding];
        if((str != NULL) && ![str isKindOfClass:[NSNull class]]) {
            DLog(@"截屏反馈 %@", str);
            [self showScreenshotAlert];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    DLog(@"上传进度 bytesSent: %lld", bytesSent);
    DLog(@"上传进度 totalBytesSent: %lld", totalBytesSent);
    DLog(@"上传进度 totalBytesExpectedToSend: %lld", totalBytesExpectedToSend);
    DLog(@"百分比: %f", totalBytesSent / (float)totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

#pragma mark - NSNotification
-(void)keyboardShow:(NSNotification *)notification {
    //获取键盘弹出或收回时frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat bottom = SCREEN_HEIGHT - CGRectGetMaxY(self.textView.frame) - CGRectGetMinY(self.bgView.frame) - 10.0;
    if (bottom < CGRectGetHeight(keyboardFrame)) {
        self.hadMoved = YES;
        [UIView animateWithDuration:duration animations:^{
            CGFloat needMoveY = CGRectGetHeight(keyboardFrame) - bottom;
            CGRect bgViewFrame = self.bgView.frame;
            bgViewFrame.origin.y -= needMoveY;
            self.bgView.frame = bgViewFrame;
        }];
    }
}

-(void)keyboardHide:(NSNotification *)notification {
    if (self.hadMoved) {
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            CGRect bgViewFrame = self.bgView.frame;
            bgViewFrame.origin.y = (SCREEN_HEIGHT - CGRectGetHeight(self.bgView.frame)) / 2;
            self.bgView.frame = bgViewFrame;
        } completion:nil];
    }
}
    
#pragma mark - Network Request
- (void)request {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
