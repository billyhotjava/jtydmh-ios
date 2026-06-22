//
//  CLNetworkStatusTipView.h
//  jtydmh
//
//  Created by eccl on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLNetworkStatusTipView : UIView

@property (nonatomic) BOOL canShow;

+ (instancetype)sharedInstance;

- (void)show:(CLNetworkStatusType)status;

- (void)checkNetworkEnvironmentStatus:(CLNetworkEnvironmentStatus)status;

- (void)changeVPNStatus:(CLVPNStatus)status;

@end

NS_ASSUME_NONNULL_END
