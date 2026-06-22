//
//  UIImage+WaterMark.m
//  PictureWatermark
//
//  Created by AD-iOS on 15/8/3.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import "UIImage+WaterMark.h"

@implementation UIImage (WaterMark)

- (UIImage*)imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil rect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

- (UIImage*)imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil point:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri
{
    return [self imageWaterMarkWithString:str rect:strRect attribute:attri image:nil imageRect:CGRectZero alpha:0];
}

- (UIImage*)imageWaterMarkWithRect:(CGRect)strRect attribute:(NSDictionary *)attri {
    NSString *dateTime = [self dateTime];
    return [self imageWaterMarkWithString:dateTime rect:strRect attribute:attri image:nil imageRect:CGRectZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri
{
    return [self imageWaterMarkWithString:str point:strPoint attribute:attri image:nil imagePoint:CGPointZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawAtPoint:strPoint withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}

- (NSString *)dateTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    NSString *dateStr = [timeStr substringWithRange:NSMakeRange(0, 10)];
    NSString *timeString = [timeStr substringWithRange:NSMakeRange(11, 8)];
    NSString *weekDay = [self weekdayStringFromDate:[NSDate date]];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",dateStr, weekDay];
    return [NSString stringWithFormat:@"%@\n%@", timeString, dateString];
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (UIImage *)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        NSArray *list = [str componentsSeparatedByString:@"\n"];
        for (int i = 0; i < list.count; i++) {
            NSString *str = list[i];
            if (i == 0) {
                [str drawInRect:strRect withAttributes:attri];
            } else {
                [str drawInRect:CGRectMake(CGRectGetMinX(strRect), CGRectGetMinY(strRect) + 300, CGRectGetWidth(strRect), CGRectGetHeight(strRect)) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:130], NSForegroundColorAttributeName: [UIColor whiteColor]}];
            }
        }
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark - 翻转
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return M_PI * (degrees / 180.0);
}

- (UIImage *)rotatedByImageOrientation:(UIImageOrientation)imageOrientation {
    CGFloat degrees = 0.0;
    switch (imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            degrees = 180.0;
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            degrees = 90.0;
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            degrees = -90.0;
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            degrees = 0.0;
            break;
    }
    return [self rotatedByDegrees:degrees];
}

- (UIImage *)rotatedByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
