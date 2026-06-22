//
//  CLScanViewController.m
//  jtdgdw
//
//  Created by zhangda on 2020/8/5.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "CLScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CLScanView.h"

#define IsAvailableString(_ref)   (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ([_ref isKindOfClass:[NSString class]]) && (_ref.length > 0))

@interface CLScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CLScanView *scanView;

@end

@implementation CLScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self configScanningQRCode];
//    self.scanView = [[CLScanView alloc] initScanViewWithFrame:[self getPreViewFrame] scanAreaHeight:200.0];
    self.scanView = [[CLScanView alloc] initScanViewWithFrame:self.view.frame scanAreaHeight:CGRectGetWidth(self.view.frame) - 80.0 scanCodeType:self.scanCodeType];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = [UIApplication sharedApplication].keyWindow.center;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        [self.view addSubview:self.scanView];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.frame = CGRectMake(20.0, kIsBangsScreen ? 54.0 : 30.0, 30.0, 30.0);
        [backButton setBackgroundImage:[UIImage imageNamed:@"scan_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
        [self.view bringSubviewToFront:backButton];
    });
    
    [self configSession];
    [self addGenstureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.session && ![self.session isRunning]) {
        [self.session performSelector:@selector(startRunning) withObject:nil afterDelay:0.5];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.session && self.session.isRunning) {
        [self.session stopRunning];
    }
    [self.scanView destroyTimer];
}

- (void)configScanningQRCode {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self showDeniedCamera];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted) {
                    [self showDeniedCamera];
                }
            });
        }];
    }
}

- (void)showDeniedCamera {
    NSString *appName = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleNameKey);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"请在 iPhone 的“设置-隐私-相机”选项中，允许%@访问你的相机", appName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:leftAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)configSession {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    self.output.rectOfInterest = CGRectMake(0.15, 0.24, 0.7, 0.52);
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])  {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    /*
     // 条形码
     AVMetadataObjectTypeUPCECode,
     AVMetadataObjectTypeCode39Code,
     AVMetadataObjectTypeCode39Mod43Code,
     AVMetadataObjectTypeEAN8Code,
     AVMetadataObjectTypeEAN13Code,
     AVMetadataObjectTypeCode93Code,
     AVMetadataObjectTypeCode128Code,
     AVMetadataObjectTypeInterleaved2of5Code,
     AVMetadataObjectTypeITF14Code
     
     // 二维码
     AVMetadataObjectTypePDF417Code,
     AVMetadataObjectTypeQRCode,
     AVMetadataObjectTypeAztecCode,
     AVMetadataObjectTypeDataMatrixCode
     */
    NSArray *barCodeMetadataArray = @[
        AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypeInterleaved2of5Code,
        AVMetadataObjectTypeITF14Code
    ];
    NSArray *qrCodeMetadataArray = @[
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode
    ];
    switch (self.scanCodeType) {
        case CLScanBarCodeType:
            self.output.metadataObjectTypes = barCodeMetadataArray;
            break;
            
        case CLScanQRCodeType:
            self.output.metadataObjectTypes = qrCodeMetadataArray;
            break;
            
        case CLScanBarCodeType | CLScanQRCodeType: {
            self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
            break;
        }
        default:
            break;
    }
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.view.frame;//[self getPreViewFrame];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

//- (CGRect)getPreViewFrame {
//    CGRect viewFrame = self.view.frame;
//    viewFrame.size.height = CGRectGetHeight(viewFrame) - NavigationBar_Status_HEIGHT;
//    return viewFrame;
//}

-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)tapScreen:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake(point.y /size.height ,1 - point.x / size.width);
    NSError *error = nil;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.device unlockForConfiguration];
    }
}

- (void)checkQRCodeContent:(NSString *)content {
    NSLog(@">>>>> 内容: %@", content);
    if (IsAvailableString(content)) {
        if (self.completion) {
            self.completion(content);
            [self dismiss];
        }
    } else if (self.session && !self.session.isRunning) {
        [self.session startRunning];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goback {
    if (self.completion) {
        self.completion(nil);
        [self dismiss];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.lastObject;
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            if (self.session && !self.session.isRunning) {
                   [self.session startRunning];
               }
            return;
        } else {
            if (self.session && self.session.isRunning) {
                [self.session stopRunning];
            }
            [self checkQRCodeContent:obj.stringValue];
        }
    } else {
        if (self.session && !self.session.isRunning) {
            [self.session startRunning];
        }
    }
}

- (void)dealloc {
    NSLog(@"== CLScanViewController Dealloc ==");
}

@end
