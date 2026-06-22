//
//  HCPDataDownloader.m
//
//  Created by Nikolay Demyankov on 04.11.16.
//

#import "HCPDataDownloader.h"

@interface HCPDataDownloader () <NSURLSessionDelegate>

@end

@implementation HCPDataDownloader

- (void) downloadDataFromUrl:(NSURL*) url requestHeaders:(NSDictionary *)headers completionBlock:(HCPDataDownloadCompletionBlock) block {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    if (headers) {
        [configuration setHTTPAdditionalHeaders:headers];
    }
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask* dowloadTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        block(data, error);
    }];
    
    [dowloadTask resume];
}

# pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    DLog(@"热更新忽略证书验证 out");
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){//服务器信任证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
        if (completionHandler) {
            DLog(@"热更新忽略证书验证 in");
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

@end
