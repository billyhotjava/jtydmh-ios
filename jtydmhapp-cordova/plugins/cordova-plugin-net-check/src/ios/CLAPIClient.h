//
//  CLAPIClient.h
//  jtdgdw
//
//  Created by eccl on 2020/8/6.
//  Copyright © 2020 ECCL. All rights reserved.
//

#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLAPIClient : AFHTTPSessionManager

/// BaseUrl
typedef NSString *CLAPIBaseURL NS_STRING_ENUM;
/// 国神内网
extern CLAPIBaseURL const CLAPIBaseGuoShenLANURL;
/// 国神新内网
extern CLAPIBaseURL const CLAPIBaseNewGuoShenLANURL;
/// 国神外网及蜂窝移动数据
extern CLAPIBaseURL const CLAPIBaseGuoShenWLANURL;

/// 因版本更新单独走外网，manifest.plist 需要放到 可信任的 CA 证书的 https 服务上 （不校验自签证书，不走 VPN Proxy 模式）
//+ (void)checkAppUpdateVersion:(void(^ __nullable)(BOOL needUpdate, NSError * __nullable error))completion;

+ (instancetype)sharedInstance;
/// 超时时间 2s，用于切换网络时判断内外网的接口使用
+ (instancetype)sharedInstanceShortTimeOut;

/// GET请求
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param parameters 网络请求参数
/// @param animated 是否显示网络请求指示器动画
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (void)GET:(NSString *)url baseURLType:(CLAPIBaseURL _Nullable)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure;

/// GET请求 Default Content-Type
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param parameters 网络请求参数
/// @param animated 是否显示网络请求指示器动画
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (void)GETDefaultContentType:(NSString *)url baseURLType:(CLAPIBaseURL _Nullable)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure;

/// POST请求
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param parameters 网络请求参数
/// @param animated 是否显示网络请求指示器动画
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (void)POST:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure;


/// POST 请求 ContentType - Json
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param parameters 网络请求参数
/// @param animated 是否显示网络请求指示器动画
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (void)POSTJsonContentType:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure;

/// PUT 请求 ContentType - Json
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param parameters 网络请求参数
/// @param animated 是否显示网络请求指示器动画
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (void)PUT:(NSString *)url baseURLType:(CLAPIBaseURL)urlType parameters:(id _Nullable)parameters animated:(BOOL)animated success:(nullable void (^)(NSDictionary *_Nullable responseObject))success failure:(nullable void (^)(NSError *_Nonnull error))failure;


/// download 下载文件
/// @param url 网络请求URL
/// @param urlType BaseURL 类型
/// @param animated 是否显示网络请求指示器动画
/// @param destination 下载目录地址
/// @param completionHandler 请求完成回调
- (void)download:(NSString *)url baseURLType:(CLAPIBaseURL)urlType animated:(BOOL)animated destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
