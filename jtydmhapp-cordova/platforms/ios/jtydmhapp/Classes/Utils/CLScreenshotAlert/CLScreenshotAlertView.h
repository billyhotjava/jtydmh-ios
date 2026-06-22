//
//  CLScreenshotAlertView.h
//  jtydmhapp
//
//  Created by eccl on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLScreenshotAlertView : UIView

+ (instancetype)sharedInstance;

- (void)showScreenshotAlert;

- (void)checkNetwork;

@end

NS_ASSUME_NONNULL_END
