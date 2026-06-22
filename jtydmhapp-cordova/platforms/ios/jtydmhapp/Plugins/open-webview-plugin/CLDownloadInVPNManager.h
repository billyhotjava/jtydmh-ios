//
//  CLDownloadInVPNManager.h
//  jtydmhapp
//
//  Created by eccl on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionHandler)(NSString *filePath);

@interface CLDownloadInVPNManager : NSObject

- (void)download:(NSString *)urlString token:(NSString *)token withSavedFilePath:(NSString *)filePath completionHandler:(completionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
