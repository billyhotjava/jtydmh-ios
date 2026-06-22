//
//  CLUploadInVPNManager.m
//  jtydmhapp
//
//  Created by eccl on 2023/1/14.
//

#import "CLUploadInVPNManager.h"
#import "SDKWrapper.h"
#import <UIKit/UIKit.h>

#define DataFromString(str) ([str dataUsingEncoding:NSUTF8StringEncoding])

CLUploadFileType const CLUploadFileJPEGType = @"image/jpg";
CLUploadFileType const CLUploadFileMP4Type = @"video/mp4";
CLUploadFileType const CLUploadFileMOVType = @"video/mov";
CLUploadFileType const CLUploadFileUnknownType = @"";

/// 上传文件地址
static NSString *const CLUploadAPIUrl = @"https://mobileapi-ydxj.sgeg.ceic.com/fm/addfile";

@implementation CLUploadFile

- (instancetype)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(CLUploadFileType)fileType {
    self = [super init];
    if (self) {
        self.fileData = fileData;
        self.fileName = fileName;
        self.fileType = fileType;
    }
    return self;
}

@end

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    NSLog(@"忽略证书认证 upload");
    return YES;
}

@end


@interface CLUploadInVPNManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSURLSessionDataTask* sessionTask;
@property (nonatomic, copy) NSString *uploadFileBoundary;
@property (nonatomic, strong) NSMutableData* receiveDataBuffer;
@property (nonatomic, copy)completionHandler completion;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CLUploadInVPNManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        self.uploadFileBoundary = [(__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
        CFRelease(uuid);
        NSLog(@"!!! boundary: %@", self.uploadFileBoundary);
    }
    return self;
}

- (void)uploadWithFile:(CLUploadFile *)file completionHandler:(completionHandler)completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        CGFloat width = 30.0;
        self.activityIndicatorView.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width) / 2, (CGRectGetHeight([UIScreen mainScreen].bounds) - width) / 2, width, width);
        [[UIApplication sharedApplication].keyWindow addSubview:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        
        self.completion = completionHandler;
        NSURL *url = [NSURL URLWithString:CLUploadAPIUrl];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        
        // boundary
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.uploadFileBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        NSURLSession *session = [self createSessionWithConfigurationWithTimeoutInterval:30.0f];
        NSData *requestData = [self getSendDataWithFile:file];
        NSURLSessionUploadTask *uploadTask =  [session uploadTaskWithRequest:request fromData:requestData];
        [uploadTask resume];
    });
}

- (NSData *)getSendDataWithFile:(CLUploadFile *)file {
    NSMutableData *data = [NSMutableData data];
    // 表单拼接
//    NSMutableString *headerStrM = [NSMutableString string];
    // name：表单控件名称  filename：上传文件名
    NSString *fileName = [[NSString alloc] initWithFormat:@"file\";filename=\"%@", file.fileName];
    NSString *componentString = @"";
    if (file.fileType == CLUploadFileUnknownType) {
        //TODO: value 传值
        componentString = [self fileUploadContentWithName:fileName fileType:file.fileType value:@""];
    } else {
        componentString = [self fileUploadContentWithName:fileName fileType:file.fileType value:nil];
    }
    [data appendData:[componentString dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:file.fileData];
    
    // boundary
    NSString *footerStrM = [NSString stringWithFormat:@"\r\n--%@--\r\n", self.uploadFileBoundary];
//    [headerStrM appendString:footerStrM];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"准备上传 data: %lu", (unsigned long)data.length);
    return data;
}

- (NSString *)fileUploadContentWithName:(NSString *)name fileType:(CLUploadFileType)fileType value:(NSString *__nullable)value {
    NSMutableString *headerStrM = [NSMutableString string];
    // 表单拼接 boundary
    if (fileType == CLUploadFileUnknownType) {
        [headerStrM appendFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";\r\nContent-Type:multipart/form-data;charset=UTF-8\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n\r\n", self.uploadFileBoundary, name, value];
    } else {
        [headerStrM appendFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";\r\nContent-Type:%@;charset=UTF-8\r\nContent-Transfer-Encoding: 8bit\r\n\r\n", self.uploadFileBoundary, name, fileType];
    }
    return headerStrM;
}

- (NSURLSession *)createSessionWithConfigurationWithTimeoutInterval:(NSTimeInterval)timeOutInterval {
    NSDictionary *proxyConfigDic = nil;
    NSInteger proxyPort = [[SDKWrapper getInstance] queryHttpProxyPort];
    if(proxyPort) {
        NSString *host = @"127.0.0.1";
        proxyConfigDic = @{(NSString*)kCFStreamPropertyHTTPProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPProxyPort: @(proxyPort),
                           (NSString*)kCFNetworkProxiesHTTPEnable:@YES,
                           (NSString*)kCFStreamPropertyHTTPSProxyHost: host,
                           (NSString*)kCFStreamPropertyHTTPSProxyPort:@(proxyPort)
                           };
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = proxyConfigDic;
    config.timeoutIntervalForRequest = timeOutInterval;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    self.receiveDataBuffer = [NSMutableData data];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.receiveDataBuffer appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"完成 error: %@", error);
//    NSString *result = [[NSString alloc] initWithData:self.receiveDataBuffer encoding:NSUTF8StringEncoding];
//    NSLog(@"获取到的数据: %@", result);
    [self.activityIndicatorView stopAnimating];
    if (self.completion) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.receiveDataBuffer options:NSJSONReadingMutableContainers error:nil];
        self.completion(dic);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSLog(@"上传进度: %f",totalBytesSent*1.0/totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

@end
