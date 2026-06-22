#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//! Project version number for SportalSDK.
FOUNDATION_EXPORT double SportalSDKVersionNumber;

//! Project version string for SportalSDK.
FOUNDATION_EXPORT const unsigned char SportalSDKVersionString[];

FOUNDATION_EXTERN NSString *const SPSDKSetGesturePwdLockNotification;
FOUNDATION_EXTERN NSString *const SPSDKCleanReLoginNotification;
FOUNDATION_EXTERN NSString *const SPSDKAutoLoginNotification;
FOUNDATION_EXTERN NSString *const SPSDKChangeAccountNotification;
FOUNDATION_EXTERN NSString *const SPSDKUpdatePasswordNotification;
FOUNDATION_EXTERN NSString *const SPSDKNewVersionNotification;

//nc tunnel 状态通知
FOUNDATION_EXTERN NSString *const SPSDKNCStatusDisconnectedNotification;
FOUNDATION_EXTERN NSString *const SPSDKNCStatusConnectedNotification;
FOUNDATION_EXTERN NSString *const SPSDKNCStatusReConnectedNotification;

FOUNDATION_EXTERN NSString *const SPSDKNCStatusConnectingNotification;

FOUNDATION_EXTERN NSString *const SPSDKNCStatusErrorNotification;

//SSLVPN topic 通知
FOUNDATION_EXTERN NSString *const SPSDKSSLVPNTopicNotification;

typedef NS_ENUM(NSInteger, SPNCStatus) {
    /* 没有配置NC插件 */
    SPNCStatusNotFound = 0,
    /* 断开连接 */
    SPNCStatusDisconnected = 1,
    /* 正在连接中 */
    SPNCStatusConnecting = 2,
    /* 已经连接 */
    SPNCStatusConnected = 3,
};

//0用户名密码登录，1，证书登录, 2 动态口令， 3 二维码, 4 外部认证
typedef NS_ENUM(NSInteger, SPAuthMode) {
    /* 用户名密码认证 */
    SPAuthModeUsernamePassword = 0,
    /* 证书认证 */
    SPAuthModeCer = 1,
    /* 动态口令 */
    SPAuthModeTotp = 2,
    /* 二维码 */
    SPAuthModeQrcode = 3,
    /* extra 外部认证*/
    SPAuthModeExtra = 4,
};

//多因素认证
typedef enum : NSUInteger {
    /* 用户名密码认证 */
    SPNextAuthUsernameAndPassword = 0,
    /* 证书内容和密码认证 */
    SPNextAuthCerAndPassword = 1,
    /* 密码或动态口令或验证码 */
    SPNextAuthPassword = 2,
    /* 需要电话号码，以用于发送短信验证码 */
    SPNextAuthNeedPhoneNum = 3, 
    /* 需要邮箱，以用于发送短信验证码 */
    SPNextAuthNeedEMailAddr = 4,
    /* 短信验证码认证 */
    SPNextAuthNeedVCCodeSMS = 5,
    /* 邮箱验证码认证 */
    SPNextAuthNeedVCCodeEMail = 6, 
    /* 动态口令认证 */
    SPNextAuthTOTP = 7,
    /* 二维码认证获取二维码数据 */
    SPNextAuthQRCodeGetQrData = 8,
    /* 二维码认证查询二维码状态 */
    SPNextAuthQRCodeAuthStatusQuery = 9,
} SPNextAuthSubAuthType;


FOUNDATION_EXTERN NSString *const SPSDKSubAuthName;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthType;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthRspID;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthQrFlag;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthIAMFlag;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthDesc;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthNeedValues;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthNeedValueKey;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthNeedValue;
FOUNDATION_EXTERN NSString *const SPSDKSubAuthMode;


// API 详细说明，参考Android版java文件

@protocol SPVPNClientDelegate;

@interface SPVPNClient : NSObject


//初始化SDK,可以不调用，不调用的话会在登录接口初始化
+ (void)initSDK;

/**
 * 设置SDK底层SSL连接的超时
 * @param conn 连接超时，单位为秒
 * @param so   数据超时，单位为秒，相当于SO_RCVTIMEO
 */
+ (void)setSSLConnectTimeout:(NSInteger)conn soTimeout:(NSInteger)so;

/*
 * 证书指纹添加
 * cerFingerArray 证书指纹的数组
 * NSDictionary 的数组，
 * NSDictionary *FingerDic = @{ @"fingerprint" : @"xxxxx",
 *                              @"host" : @"xxxxx",
 *                              @"port" : @"xxxxx"};
 * param fingerprint   服务器证书的sha1指纹，这个指纹是一个40个16进制字符串
 *                      例如：5C:E4:DF:B4:16:94:36:C1:50:13:1D:15:1F:FB:FB:9A:94:0B:D2:FD
 *                      或：5CE4DFB4169436C150131D151FFBFB9A940BD2FD
 * param host          服务器主机名或IP
 * param port          服务器端口号
 */

+ (void)putSSLCerFingerprintArray:(NSArray*)cerFingerArray;

/*
 * 删除所有证书指纹
 */

+ (void)clearSSLFingerprint;

/**
 *  登录到网关
 *
 * 登录服务器，登录参数说明<br>
 * <code>
    NSDictionary *loginDic = @{
    @"vpn_host"      : @"SSLVPN网关的域名或IP",
    @"vpn_port"      : @"SSLVPN网关的端口，默认为443",
    @"auth_server"   : @"认证服务器名，默认选取第一个",
    @"custom_error"   : @1,
    @"auth_username" : @"登录用户名",
    @"auth_password" : @"登录密码",
    @"custom_error" : @"1",
    @"auth_mode"     : @0, //0用户名密码登录，1，证书登录, 2 动态口令， 3 二维码
    @"auth_autologin": @1, //1自动登录，0手动登录，需要实现登录界面
    @"extra_xxxxxx" :  extra_ 开头的额外的参数
 };
 * <code>
 *
 * @param params
 *        登录参数
 *
 */

+ (SPVPNClient*)login:(NSDictionary*)params listener:(id<SPVPNClientDelegate>)delegate;

/**
 *  登出网关
 */

- (void)logOut;


/**
 *  开启Hool模式，支持代理业务
 */
+ (void)startHookProxy;

/**
 *  关闭Hool模式
 */
+ (void)stopHookProxy;

/**
 *  注册自定义协议，注册后 http、https请求可以通过代理模式连接到网关
 */

+ (void)registerHttpProxyProtocol;


/**
 *  注销自定义协议
 */

+ (void)unregisterHttpProxyProtocol;


/**
 *  开始 CFSocket,CFStream 自动设置代理
 */

+ (void)startAutoSetProxyCFNetwork;

/**
 *  停止 CFSocket,CFStream 自动设置代理
 */

+ (void)stopAutoSetProxyCFNetwork;


+ (void)startAutoSetWKWebViewSchemeHandle;
+ (void)stopAutoSetWKWebViewSchemeHandle;

/**
 *  获取代理的监听端口
 */

+ (NSInteger)queryProxyPort;

/**
 *  获取Relay模式的监听端口
 */

+ (NSInteger)queryRelayProxyPort;

/**
 *  获取Mapping模式的监听端口
 */

+ (NSInteger)queryProxyPortWithHost:(NSString*)host port:(NSInteger)port;


/**
 *  将NSURLRequest转换为代理的NSURLRequest请求
 */

+ (NSURLRequest*)convertToProxyURLRequest:(NSURLRequest*)aRequest;

/**
 *  将NSURL转换为代理的NSURL请求
 */

+ (NSURL*)convertToProxyURL:(NSURL*)aURL;


/**
 *  关闭特殊场景下上一次启动残留的VPN
 */

+ (void)stopAnyNC;
/**
 * 返回服务信息列表
 *
 * @return 返回ServiceInfo的数组
 */

- (NSArray*)getServicesArray;

/**
 *  启动NC
 *  nc插件参数说明 
 *  @"vpnplugin_name"，在系统VPN配置显示的名称
 *  @"vpnplugin_bundleId"， 插件工程的BUndleID
 *  @"open_ncexclusive"， 是否开启NC独占模式
 *
 *   NSDictionary *ncDic = @{
 *       @"vpnplugin_name": @vpnplugin name 
 *       //vpn插件显示的名称，如果不填写这个参数默认为SportalVPN。注：如果不使用nc，可以不要这个参数
 *       @"vpnplugin_bundleId": @vpnplugin extension bundleIdentifier 
 *       //vpn插件的Bundle Id 如果不填写这个参数，默认的为Parent App Bundle Identifier.PacketTunnel
 *   };
 *   @param params
 */

- (void)startNC:(NSDictionary* _Nullable)params;

/**
 *  停止NC
 */
- (void)stopNC;


/*
 * 查找NC的状态
 */

+ (void)queryNCStatus:(void(^)(SPNCStatus status))resultBlock;


/*
 * 更新extra参数，如果登录使用了extra参数，extra参数过期了，需要更新以便SSLVPN续租时用到
 */
+ (void)updateSessionExtras:(NSDictionary<NSString*, NSString*>*)extras;

/*
 * 设置加密算法的模式,目前支持CBC和ECB模式，默认ECB
 */
+ (void)setSSLSM4CBCMode:(BOOL)cbcMode;

/*
 * 导出日志，返回所有日志文件的路径的数组
 */
+ (NSArray*)dumpLogs;


/*
 * 打开震动导出日志的功能
 */

+ (void)openLogsTikCheck;

/*
 * 请求二维码认证
 * 如果是主认证请求二维码，params为nil，
 * 如果是从认证请求二维码，params是从认证传过来的参数
 */
- (void)requestQRAuthCodeInfoParams:(NSDictionary* _Nullable)params
                        complection:(void(^)(NSDictionary* qrauthInfo, NSString* qrcodeStr))complection;


//修改密码 通过SPSDKUpdatePasswordNotification通知返回执行回调
//oldpassword 旧密码
//newpassword 新密码
- (void)changePasswordWithInfo:(NSDictionary*)dic;

// offline | online 离线|在线
- (void)checkAppLoginStatus:(void(^)(NSString* status))resultBlock;

@end

@protocol SPVPNClientDelegate <NSObject>
@optional
- (void)didLoginSuccess;
- (void)onLoginErrorID:(NSInteger)errid msg:(NSString*)errmsg;
- (void)onRuntimeErrorID:(NSInteger)errid msg:(NSString*)errmsg;

- (void)onRuntimeErrorRenew;
- (void)didLogoutCompleted;

// 多因素认证, 目前支持短信认证，动态口令， 二维码等
// authInfo：认证需要的信息，类型, 描述等
- (void)onLoginDoNextAuth:(NSDictionary*)authInfo;
- (void)onLoginDoNextAuthErrorID:(NSInteger)errid msg:(NSString*)errmsg;

//登录成功后，会回调这个函数
//返回更新的Token, 下次登录可以尝试使用此Token登录，如果Token登录失败，需要重新，登录参数和第一次登录相同
- (void)onUpdateToken:(NSString*)token;

//返回认证成功后的user_token
- (void)responseUserToken:(NSString *)user_token;

@end

NS_ASSUME_NONNULL_END

