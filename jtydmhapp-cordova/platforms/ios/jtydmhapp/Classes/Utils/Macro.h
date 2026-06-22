//
//  Macro.h
//  jtydmh
//
//  Created by eccl on 2021/6/22.
//

#ifndef Macro_h
#define Macro_h

#define IsAvailableString(_ref)   (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ([_ref isKindOfClass:[NSString class]]) && (_ref.length > 0))

// Weak Self
#define WS(weakSelf)        __weak __typeof(&*self)weakSelf = self;

// 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define DLog(...)
//#endif

/// Ping 主机地址   国神内网地址
static NSString *const kPingHostAddress = @"mgscheck.sgeg.chnenergy.com.cn";

/// netType 判断当前网络类型的地址
static NSString *const kNetTypeHostAddress = @"https://mgs.sgeg.chnenergy.com.cn/";

/// 网络切换 Ping 国神内网地址
static NSString *const kPingGuoShenLANHost = @"mgs.sgeg.chnenergy.com.cn";

/// JPush AppKey
static NSString *const kJPushAppKey = @"abac57ecc5f3628f4aa62268";

/// JPush Channel
static NSString *const kJPushChannel = @"In-House";

/// 获取的 JPush 的 registrationID 本地存储的Key值
static NSString *const kJPushRegistrationID = @"kJPushRegistrationID";

/// 需要手势密码的间隔时间
static NSTimeInterval needGestureVerifyTime = 30;

/// JPush 初始化参数定义
#ifdef DEBUG
#define kIsProduction NO
#else
#define kIsProduction YES
#endif

// 网络状态、VPN连接状态提示
static NSString *const kNetworkStatusCheckTitle = @"网络状态切换中";
/// 网络状态检测
static NSString *const kNetworkStatusCheckTip = @"网络状态检测";
/// 网络环境检测
static NSString *const kNetworkEnvironmentCheckTip = @"网络环境检测";
/// vpn连接状态检测
static NSString *const kVPNStatusCheckTip = @"VPN连接状态";

/// 网络状态已连接
static NSString *const kNetworkStatusConnectedValue = @"已连接";
/// 网络环境国神办公网
static NSString *const kNetworkGuoShenLANValue = @"国神办公网";
/// 网络环境互联网
static NSString *const kNetworkWLANValue = @"互联网";

/// VPN正在连接提示
static NSString *const kVPNConnectingTip = @"认证中";
/// VPN连接成功提示
static NSString *const kVPNConnectedTip = @"认证成功";
/// VPN重新连接提示
static NSString *const kVPNReConnectingTip = @"重连中";
/// VPN断开连接
static NSString *const kVPNDisconnectTip = @"已断开";

// 网络状态检测完毕
static NSString *const kNetworkStatusCheckFinishedTip = @"网络已切换完毕";

/// 网络状态不可用时的提示
static NSString *const kNetworkStatusUnavailableTip = @"当前网络不可用，请打开控制中心切换网络，或到系统设置中检查网络设置";

/// 网络状态提示枚举
typedef NS_ENUM(NSUInteger, CLNetworkStatusType) {
    /// 未知
    CLNetworkStatusUnkown = -1,
    /// 不可用
    CLNetworkStatusNotReachable = 0,
    /// WWAN
    CLNetworkStatusViaWWAN = 1,
    /// WiFi
    CLNetworkStatusViaWiFi = 2
};

/// 网络切换时的网络环境类型
typedef NS_ENUM(NSUInteger, CLNetworkEnvironmentStatus) {
    /// 国神办公网
    CLNetworkGuoShenLAN = 0,
    /// 互联网
    CLNetworkWLAN
};

/// 网络切换时的VPN状态
typedef NS_ENUM(NSUInteger, CLVPNStatus) {
    /// VPN 认证中
    CLVPNConnecting = 0,
    /// VPN 已连接
    CLVPNConnected,
    /// VPN 重连中
    CLVPNReConnecting,
    /// VPN 已断开
    CLVPNDisconnect,
    /// VPN 登录失败
    CLVPNConnectFail
};

/// vpn登录Host
static NSString *const kVPNHost = @"ydvpn.ceic.com";
/// vpn登录Port
static NSString *const kVPNPort = @"443";
/// vpn登录Server
static NSString *const kVPNServer = @"ldap-auth";

#endif /* Macro_h */
