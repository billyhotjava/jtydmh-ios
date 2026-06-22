//
//  CLDownloadInVPNManager.m
//  jtydmhapp
//
//  Created by eccl on 2022/1/14.
//

#import "CLDownloadInVPNManager.h"
#import "SDKWrapper.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//    NSLog(@"忽略证书认证 CLDownloadInVPNManager");
    return YES;
}

@end


@interface CLDownloadInVPNManager () <NSURLSessionDelegate>

@property (nonatomic, copy) NSString *filePath;
// 接收到的数据长度
@property (nonatomic) long long receivedLength;
// 期望的数据长度
@property (nonatomic) long long expectedLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSURLSessionDataTask* sessionTask;
@property (nonatomic, copy)completionHandler completion;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CLDownloadInVPNManager

- (void)download:(NSString *)urlString token:(NSString *)token withSavedFilePath:(NSString *)filePath completionHandler:(completionHandler)completionHandler {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    CGFloat width = 30.0;
    self.activityIndicatorView.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width) / 2, (CGRectGetHeight([UIScreen mainScreen].bounds) - width) / 2, width, width);
    [[UIApplication sharedApplication].keyWindow addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    self.filePath = filePath;
    self.completion = completionHandler;
    NSURL *url = [NSURL URLWithString:urlString];
//    NSString *httpPreffix = [NSString stringWithFormat:@"%@://", url.scheme];
//    NSString *host = url.host;
//    NSString *baseUrl = [NSString stringWithFormat:@"%@%@", httpPreffix, host];
//    NSLog(@"获取文件的baseUrl: %@", baseUrl);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:token forHTTPHeaderField:@"token"];
    
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
    self.sessionTask = [self createSessionWithRequest:request withProxyConfig:proxyConfigDic];
    [self.sessionTask resume];
}

- (NSURLSessionDataTask*)createSessionWithRequest:(NSURLRequest*)aRequest withProxyConfig:(NSDictionary*)proxyConfigDic {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = proxyConfigDic;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask* sessionTask = [session dataTaskWithRequest:aRequest];
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
    self.receivedLength = [attributes[@"NSFileSize"] longLongValue];
    
    return sessionTask;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
//    NSLog(@"下载 response: %@, expectedContentLength: %lld", response, response.expectedContentLength);
//    self.expectedLength = response.expectedContentLength + self.receivedLength;
    //文件句柄指向指定路径
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    [self.fileHandle seekToEndOfFile];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
//    NSLog(@"下载 didReceiveChallenge: %@", challenge);
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSLog(@"data: %@", data);
    //写入数据
    [self.fileHandle writeData:data];
    self.receivedLength += data.length;
//    NSLog(@"下载 收到 %lld", self.receivedLength);
//    CGFloat taskProgress = self.receivedLength * 1.0 / self.expectedLength;
//    NSLog(@"下载进度：%.2f", taskProgress);
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
//    NSLog(@"下载 完成 error: %@", error);
    //关闭文件句柄
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    //清空参数
    self.sessionTask = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicatorView stopAnimating];
        if (self.completion) {
            self.completion(self.filePath);
        }
    });
}

@end
