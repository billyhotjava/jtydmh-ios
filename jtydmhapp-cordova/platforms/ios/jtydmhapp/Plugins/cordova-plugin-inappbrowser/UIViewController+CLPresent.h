//
//  UIViewController+CLPresent.h
//  CordovaTest
//
//  Created by eccl on 2021/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// add by TP
@interface UIViewController (CLPresent)

- (void)dy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
