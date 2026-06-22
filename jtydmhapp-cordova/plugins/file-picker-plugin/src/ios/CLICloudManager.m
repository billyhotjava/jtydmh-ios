//
//  CLICloudManager.m
//  FileAppDemo
//
//  Created by eccl on 2022/11/29.
//

#import "CLICloudManager.h"

@interface CLDocument: UIDocument

@property (nonatomic, strong) NSData *data;

@end

@implementation CLDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.data = contents;
    return YES;
}

@end

@implementation CLICloudManager

+ (instancetype)sharedInstance {
    static CLICloudManager *manager = nil;
    if(manager == nil){
        manager = [[CLICloudManager alloc] init];
    }
    return manager;
}
//iCloud是否可用，只有在capability的iCloud勾选了Containers才有效果
///没有Containers创建即可，development后台会同步更新
+ (BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    NSLog(@"iCloud 不可用");
    return NO;
}
///从iCloud中下载文件
- (void)downloadWithDocumentURL:(NSURL *)url callBack:(downloadBlock)block{
    CLDocument *iCloudDoc = [[CLDocument alloc] initWithFileURL:url];
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"%@", iCloudDoc.data);
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"关闭iCloud成功");
            }];
            if (block) {
                block(iCloudDoc.data, true);
            }
        }else{
            if (block) {
                block(nil, false);
            }
        }
    }];
}
///上传文件到iCloud
///具体可以上传什么文件，大家可以自己测试一下
- (void)uploadWithWithDocumentURL:(NSURL *)url data:(NSData *)data callBack:(downloadBlock)block {
    if(url == nil || data == nil)return;
    CLDocument *iCloudDoc = [[CLDocument alloc]initWithFileURL:url];
    iCloudDoc.data = data;
    [iCloudDoc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            
    }];
}

@end
