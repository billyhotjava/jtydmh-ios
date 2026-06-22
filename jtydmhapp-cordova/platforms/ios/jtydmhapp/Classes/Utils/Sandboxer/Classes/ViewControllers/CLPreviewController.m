//
//  CLPreviewController.m
//  jtydmhapp
//
//  Created by eccl on 2022/8/11.
//

#import "CLPreviewController.h"

@interface CLPreviewController ()

@end

@implementation CLPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *waterMaskText = [NSString stringWithFormat:@"%@\n%@", CLNotificationInstance.sharedInstance.userName, CLNotificationInstance.sharedInstance.phoneNumber];
    TPWaterMaskView *waterMaskView = [[TPWaterMaskView alloc] initWithWaterMaskText:waterMaskText waterMaskTextAttribute:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:0.7], NSFontAttributeName: [UIFont systemFontOfSize:25.0]} slantAngle:(CGFloat)(-M_PI / 6)];
    [self.view addSubview:waterMaskView];
    [self.view sendSubviewToBack:waterMaskView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
