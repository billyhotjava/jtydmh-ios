//
//  TPWaterMaskView.h
//  TP
//
//  Created by eccl on 2022/8/11.
//  Copyright © 2022 eccl. All rights reserved.
//

#import "TPWaterMaskView.h"

@interface TPWaterMaskView ()

@property (nonatomic, copy) NSString *waterMaskText;
@property (nonatomic, copy) NSDictionary *waterMaskTextAttribute;
@property (nonatomic) CGFloat slantAngle;

@end

@implementation TPWaterMaskView

- (instancetype)initWithWaterMaskText:(NSString *)waterMaskText waterMaskTextAttribute:(NSDictionary *)waterMaskTextAttribute slantAngle:(CGFloat)slantAngle {
    self = [super init];
    if (self) {
        NSInteger alpha = 2;
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        self.frame = CGRectMake(-width / alpha, -height / alpha, width * (alpha + 1) / alpha, height * (alpha + 1) / alpha);
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
        self.waterMaskText = waterMaskText;
        self.waterMaskTextAttribute = waterMaskTextAttribute;
        self.slantAngle = slantAngle;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat start_x = CGRectGetMinX(self.frame);
    CGFloat start_y = CGRectGetMinY(self.frame);
    CGFloat space_x = 340.0;
    CGFloat space_y = 260.0;
    
    CGPoint contextCenter = CGPointMake(width / 2, height / 2);
    CGContextTranslateCTM(context, contextCenter.x, contextCenter.y);
    CGContextRotateCTM(context, self.slantAngle);
    
    CGContextSetRGBStrokeColor(context, 250/255.0, 250/255.0, 250/255.0, 1);
    CGContextSetFillColorWithColor(context, [self.waterMaskTextAttribute[NSForegroundColorAttributeName] CGColor]);
        
    for (CGFloat y= start_y; y < height; y += space_y) {
        for (CGFloat x = start_x; x < width; x += space_x) {
            [self.waterMaskText drawAtPoint:CGPointMake(x, y) withAttributes:self.waterMaskTextAttribute];
        }
    }
//    self.transform = CGAffineTransformMakeRotation(self.slantAngle);
}
@end
