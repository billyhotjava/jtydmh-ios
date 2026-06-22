//
//  CLCleanCache.m
//  jtydmhapp
//
//  Created by eccl on 2022/1/12.
//

#import "CLCleanCache.h"

@implementation CLCleanCache

/**
 *  清理缓存
 */
+ (void)cleanCache:(cleanCacheBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float size = [CLCleanCache folderSizeAtPath];
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(size);
        });
    });
    
}

/**
 *  整个缓存目录的大小
 *  @return 缓存目录下所有文件的大小 单位 M
 */
+ (float)folderSizeAtPath {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager * manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName = @"";
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}
/**
 *  计算单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
