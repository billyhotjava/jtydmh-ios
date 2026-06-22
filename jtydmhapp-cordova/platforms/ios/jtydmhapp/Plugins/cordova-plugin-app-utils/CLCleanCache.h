//
//  CLCleanCache.h
//  jtydmhapp
//
//  Created by eccl on 2022/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^cleanCacheBlock)(float size);

@interface CLCleanCache : NSObject

/**
 *  清理缓存
 */
+ (void)cleanCache:(cleanCacheBlock)block;

/**
 *  整个缓存目录的大小
 *  @return 缓存目录下所有文件的大小 单位 M
 */
+ (float)folderSizeAtPath;

@end

NS_ASSUME_NONNULL_END
