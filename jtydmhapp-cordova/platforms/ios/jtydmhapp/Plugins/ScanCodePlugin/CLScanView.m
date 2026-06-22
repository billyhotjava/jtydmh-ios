//
//  CLScanView.m
//  jtdgdw
//
//  Created by zhangda on 2020/8/5.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "CLScanView.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const timeInterval = 0.05;
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define scanContentY ((kScreenHeight) * 0.18)

@interface CLScanView ()

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat scanAreaHeight;
@property (nonatomic) CLScanCodeType scanCodeType;

@end

@implementation CLScanView

- (instancetype)initScanViewWithFrame:(CGRect)frame scanAreaHeight:(CGFloat)scanAreaHeight scanCodeType:(CLScanCodeType)scanCodeType {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanAreaHeight = scanAreaHeight;
        self.scanCodeType = scanCodeType;
        self.backgroundColor = [UIColor clearColor];
        [self configScanView];
    }
    return self;
}

- (void)configScanView {
    UIImage *image = [UIImage imageNamed:@"scan_line"];
    self.lineImageView = [[UIImageView alloc] initWithImage:image];
    self.lineImageView.frame = CGRectMake((kScreenWidth - self.scanAreaHeight) / 2.0, scanContentY, self.scanAreaHeight, image.size.height);
    
    CGFloat scanSpaceY = 10.0;
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.frame = CGRectMake(0.0, scanContentY + self.scanAreaHeight + scanSpaceY, kScreenWidth, 25.0);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.backgroundColor = [UIColor clearColor];
    NSString *promptContent = nil;
    switch (self.scanCodeType) {
        case CLScanBarCodeType:
            promptContent = kScanBarCodeTip;
            break;
            
        case CLScanQRCodeType:
            promptContent = kScanQRCodeTip;
            break;
            
        case CLScanBarCodeType | CLScanQRCodeType:
            promptContent = kScanAllCodeTip;
            break;
        default:
            break;
    }
    promptLabel.text = promptContent;
    [self addSubview:promptLabel];
    
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *onImage = [UIImage imageNamed:@"scan_light_on"];
    UIImage *offImage = [UIImage imageNamed:@"scan_light_off"];
    CGFloat lightButtonWidth = 40.0;
    lightButton.frame = CGRectMake((kScreenWidth - lightButtonWidth) / 2.0, scanContentY + self.scanAreaHeight + (kScreenHeight - scanContentY - self.scanAreaHeight - lightButtonWidth) / 2 + CGRectGetHeight(promptLabel.frame), lightButtonWidth, lightButtonWidth);
    [lightButton setImage:onImage forState:UIControlStateNormal];
    [lightButton setImage:offImage forState:UIControlStateSelected];
    [lightButton addTarget:self action:@selector(turnOnLightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightButton];
    [self addTimerForAnimation];
}

- (void)addTimerForAnimation
{
    [self addSubview:self.lineImageView];
    [self sendSubviewToBack:self.lineImageView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(scanlineMoveAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)scanlineMoveAnimation
{
    __block CGRect frame = self.lineImageView.frame;
    static BOOL flag = YES;
    if (flag)
    {
        frame.origin.y = scanContentY;
        flag = NO;
        [UIView animateWithDuration:timeInterval animations:^{
            frame.origin.y += 5;
            self.lineImageView.frame = frame;
        } completion:nil];
    }
    else
    {
        if (self.lineImageView.frame.origin.y >= scanContentY)
        {
            CGFloat scanContent_MaxY = scanContentY + self.scanAreaHeight;
            if (self.lineImageView.frame.origin.y >= scanContent_MaxY - 10)
            {
                frame.origin.y = scanContentY;
                self.lineImageView.frame = frame;
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:timeInterval animations:^{
                    frame.origin.y += 5;
                    self.lineImageView.frame = frame;
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
}

- (void)turnOnLightButtonAction:(UIButton *)btn
{
    if (btn.selected == NO)
    {
        [self turnOnLight:YES];
        btn.selected = YES;
    }
    else
    {
        [self turnOnLight:NO];
        btn.selected = NO;
    }
}

- (void)turnOnLight:(BOOL)on
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([self.device hasTorch])
    {
        [self.device lockForConfiguration:nil];
        if (on)
        {
            [self.device setTorchMode:AVCaptureTorchModeOn];
        }
        else
        {
            [self.device setTorchMode: AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];
    }
}

- (void)destroyTimer
{
    if (self.device.torchMode == AVCaptureTorchModeOn)
    {
        [self turnOnLight:NO];
    }
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        _timer = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.scanAreaHeight / 2,scanContentY, self.scanAreaHeight, self.scanAreaHeight);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    [self addCenterClearRect:ctx rect:clearDrawRect];
//    [self addWhiteRect:ctx rect:clearDrawRect];
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextSetRGBFillColor(ctx, 0/ 255.0,0/ 255.0,0/ 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextClearRect(ctx, rect);
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1);
    
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx
{
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end
