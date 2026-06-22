//
//  CLICloudManager.h
//  FileAppDemo
//
//  Created by eccl on 2022/11/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^downloadBlock)(NSData * __nullable data, BOOL success);

@interface CLICloudManager : NSObject

+ (instancetype)sharedInstance;
+ (BOOL)iCloudEnable;
- (void)downloadWithDocumentURL:(NSURL *)url callBack:(downloadBlock)block;

@end

NS_ASSUME_NONNULL_END
