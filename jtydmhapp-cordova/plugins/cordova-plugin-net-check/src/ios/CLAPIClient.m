//
//  CLAPIClient.m
//  jtdgdw
//
//  Created by eccl on 2020/8/6.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "CLAPIClient.h"
#import <SecurePortal/SPVPNClient.h>
#import "SDKWrapper.h"

// 集团 域名
/// 服务器TLS证书名
//static NSString *const CLAPIServerTLSCert = @"server";

// 国神内网
CLAPIBaseURL const CLAPIBaseGuoShenLANURL = @"https://mgscheck.sgeg.chnenergy.com.cn";
/// netType 判断当前网络类型的地址
CLAPIBaseURL const CLAPIBaseNewGuoShenLANURL = @"https://mgs.sgeg.chnenergy.com.cn";
// 国神外网及蜂窝移动数据
CLAPIBaseURL const CLAPIBaseGuoShenWLANURL = @"https://m.sgeg.ceic.com";


@implementation CLAPIClient


#pragma mark - 全局网络单例方法封装
+ (instancetype)sharedInstance {
    static CLAPIClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:CLAPIBaseNewGuoShenLANURL];
        _sharedInstance = [[CLAPIClient alloc] initWithBaseURL:baseURL isSelfSignedCertificate:YES];
//        _sharedInstance = [[CLAPIClient alloc] initWithBaseURL:baseURL sessionConfiguration:[CLAPIClient configHTTPVPNProxy]];
    });
    _sharedInstance.requestSerializer.timeoutInterval = 30.0f;
    return _sharedInstance;
}

+ (instancetype)sharedInstanceShortTimeOut {
    static CLAPIClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:CLAPIBaseNewGuoShenLANURL];
        _sharedInstance = [[CLAPIClient alloc] initWithBaseURL:baseURL isSelfSignedCertificate:YES];
//        _sharedInstance = [[CLAPIClient alloc] initWithBaseURL:baseURL sessionConfiguration:[CLAPIClient configHTTPVPNProxy]];
    });
    _sharedInstance.requestSerializer.timeoutInterval = 2.0f;
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url isSelfSignedCertificate:(BOOL)isSelfSignedCertificate {
    self = [super initWithBaseURL:url];
    if (self) {
        [self configRequestSerializer];
        if (isSelfSignedCertificate && url && [[url scheme] isEqualToString:@"https"]) {
            [self trustTheSelfSignedCertificate];
        }
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self configRequestSerializer];
        if (url && [url.absoluteString hasPrefix:@"https"]) {
            [self trustTheSelfSignedCertificate];
        }
    }
    return self;
}

/// VPN 代理模式
+ (NSURLSessionConfiguration *)configHTTPVPNProxy {
    if(![[SDKWrapper getInstance] isConnected]) {
        return nil;
    }
    NSDictionary *proxyConfigInfo = nil;
    NSInteger proxyPort = [SPVPNClient queryProxyPort];
    if (proxyPort) {
        NSString *host = kVPNHost;
        proxyConfigInfo = @{
            (NSString*)kCFStreamPropertyHTTPProxyHost: host,
            (NSString*)kCFStreamPropertyHTTPProxyPort: @(proxyPort),
            (NSString*)kCFNetworkProxiesHTTPEnable:@YES,
            (NSString*)kCFStreamPropertyHTTPSProxyHost: host,
            (NSString*)kCFStreamPropertyHTTPSProxyPort:@(proxyPort)
        };
    }
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    urlSessionConfiguration.connectionProxyDictionary = proxyConfigInfo;
    return urlSessionConfiguration;
}

- (void)configRequestSerializer {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 15.0;
    [self.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"application/xml", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"multipart/form-data", @"charset=utf-8", @"image/jpeg", /*@"video/mp4",*/ nil];
}
    
- (void)trustTheSelfSignedCertificate {
    /// 使用server 端的证书进行自签证书的校验
//    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:CLAPIServerTLSCert ofType:@"cer"];
//    if (!IsAvailableString(certFilePath)) {
//        return;
//    }
//    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
//    NSSet *certSet = [NSSet setWithObject:certData];
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    [self setSecurityPolicy:policy];
    
    // 去掉证书校验
    // 客户端是否信任非法证书
    self.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
    [self.securityPolicy setValidatesDomainName:NO];
    
    [self setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"setSessionDidBecomeInvalidBlock");
    }];
    
    // 服务端证书验证
    //客服端请求验证 重写 setSessionDidReceiveAuthenticationChallengeBlock 方法
    WS(weakSelf)
    [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([weakSelf.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } 
        *_credential = credential;
        return disposition;
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    // 判断是否是信任服务器证书
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 告诉服务器，客户端信任证书
        // 创建凭据对象
        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 通过completionHandler告诉服务器信任证书
        completionHandler(NSURLSessionAuthChallengeUseCredential,credntial);
    }
//    NSLog(@"protectionSpace = %@",challenge.protectionSpace);
}

- (void)GET:(NSString *)url baseURLType:(CLAPIBaseURL _Nullable)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure {
//    NSLog(@"header: %@", self.requestSerializer.HTTPRequestHeaders);
    if (IsAvailableString(urlType)) {
        [self setValue:[NSURL URLWithString:urlType] forKey:@"baseURL"];
    }
    [self GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        NSLog(@"url: %@, responseObject: %@", task.currentRequest.URL, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        NSLog(@"url: %@", task.currentRequest.URL);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)GETDefaultContentType:(NSString *)url baseURLType:(CLAPIBaseURL _Nullable)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure {
//    NSLog(@"header: %@", self.requestSerializer.HTTPRequestHeaders);
    if (IsAvailableString(urlType)) {
        [self setValue:[NSURL URLWithString:urlType] forKey:@"baseURL"];
        if (url && [[[NSURL URLWithString:url] scheme] isEqualToString:@"https"]) {
            [self trustTheSelfSignedCertificate];
        }
    }
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        NSLog(@"url: %@, responseObject: %@", task.currentRequest.URL, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        NSLog(@"url: %@", task.currentRequest.URL);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure {
    if (IsAvailableString(urlType)) {
        [self setValue:[NSURL URLWithString:urlType] forKey:@"baseURL"];
    }
    
    [self setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
//        NSLog(@"response: %@ \n\n\n\n request: %@", response, request.allHTTPHeaderFields);
        return nil;
    }];
    
    [self POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        NSLog(@"url: %@", task.currentRequest.URL);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POSTJsonContentType:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure {
    [self.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [self POST:url baseURLType:urlType parameters:parameters animated:animated success:success failure:failure];
}

- (void)PUT:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure {
    [self.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    if (IsAvailableString(urlType)) {
        [self setValue:[NSURL URLWithString:urlType] forKey:@"baseURL"];
    }
    [self PUT:url parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"url: %@", task.currentRequest.URL);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)download:(NSString *)url baseURLType:(CLAPIBaseURL)urlType animated:(BOOL)animated destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    if (IsAvailableString(urlType)) {
        [self setValue:[NSURL URLWithString:urlType] forKey:@"baseURL"];
        if (url && [[[NSURL URLWithString:url] scheme] isEqualToString:@"https"]) {
            [self trustTheSelfSignedCertificate];
        }
    }
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *dataTask = [self downloadTaskWithRequest:request progress:nil destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [dataTask resume];
}

@end
