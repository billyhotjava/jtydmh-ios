//
//  CLScanCommon.h
//  TableViewCellCollectionView
//
//  Created by eccl on 2021/6/23.
//  Copyright © 2021 eccl. All rights reserved.
//

#ifndef CLScanCommon_h
#define CLScanCommon_h

//Device Screen Size
#define IS_SCREEN_55_INCH    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size)):    NO)
#define IS_SCREEN_47_INCH    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) :     NO)
#define IS_SCREEN_4_INCH    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) :      NO)
#define IS_SCREEN_35_INCH    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :      NO)

/// NavigationBar 的高度
#define NavigationBar_Status_HEIGHT ((IS_SCREEN_35_INCH || IS_SCREEN_4_INCH || IS_SCREEN_47_INCH || IS_SCREEN_55_INCH) ? 64.0 : 88.0)

/// 是否刘海屏
#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

/// 扫码类型
typedef NS_ENUM(NSUInteger, CLScanCodeType) {
    /// 条形码
    CLScanBarCodeType = 1,
    /// 二维码
    CLScanQRCodeType = 1 << 1
};

/// 扫码提示语
static NSString *const kScanBarCodeTip = @"请将条形码放入框内";
static NSString *const kScanQRCodeTip = @"请将二维码放入框内";
static NSString *const kScanAllCodeTip = @"请将条形码/二维码放入框内";

#endif /* CLScanCommon_h */
