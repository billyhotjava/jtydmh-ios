//
//  CLUploadInVPNManager.h
//  jtydmhapp
//
//  Created by eccl on 2023/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionHandler)(NSDictionary *result);

// 上传文件类型
typedef NSString *CLUploadFileType NS_STRING_ENUM;
/// 图片
extern CLUploadFileType const CLUploadFileJPEGType;
/// 视频
extern CLUploadFileType const CLUploadFileMP4Type;
extern CLUploadFileType const CLUploadFileMOVType;
// 未知类型
extern CLUploadFileType const CLUploadFileUnknownType;

@interface CLUploadFile : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) CLUploadFileType fileType;
@property (nonatomic, strong) NSData *fileData;

- (instancetype)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(CLUploadFileType)fileType;

@end

@interface CLUploadInVPNManager : NSObject

- (void)uploadWithFile:(CLUploadFile *)file completionHandler:(completionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
