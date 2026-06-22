//
//  CLJailbreakDetectTool.m
//  jtdgdw
//
//  Created by eccl on 2022/5/26.
//  Copyright © 2022 ECCL. All rights reserved.
//

#import "CLJailbreakDetectTool.h"
#include <mach-o/dyld.h>

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

static NSString *const kTeamID = @"573E9DC2FE";
static NSString *const kAppBundleID = @"com.eccl.jtmh";

@implementation CLJailbreakDetectTool

// 四种检查是否越狱的方法, 只要命中一个, 就说明已经越狱.
+ (BOOL)detectCurrentDeviceIsJailbroken {
    BOOL result =  NO;
    
    result = [self detectJailBreakByJailBreakFileExisted];
    
    if (!result) {
        result = [self detectJailBreakByAppPathExisted];
    }
    
    if (!result) {
        result = [self detectJailBreakByEnvironmentExisted];
    }
    
    if (!result) {
        result = [self detectJailBreakByCydiaPathExisted];
    }
    
    if (result) { // 疑似越狱
        // 疑似越狱后，检测是否疑似有注入动态库
//        result = IJMCheckInsertLib();
    } else {
        // 疑似未越狱，检测是否疑似有注入动态库
        result = IJMCheckInsertWhiteList();
    }
    if (result) {
        return result;
    } else {
        result = [self isResignedApp];
        return result;
    }
}
/**
 * 判定常见的越狱文件
 * /Applications/Cydia.app
 * /Library/MobileSubstrate/MobileSubstrate.dylib
 * /bin/bash
 * /usr/sbin/sshd
 * /etc/apt
 * 这个表可以尽可能的列出来，然后判定是否存在，只要有存在的就可以认为机器是越狱了。
 */
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};
+ (BOOL)detectJailBreakByJailBreakFileExisted {
    for (int i = 0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            return YES;
        }
    }
    return NO;
}
/**
 * 判断cydia的URL scheme.
 */
+ (BOOL)detectJailBreakByCydiaPathExisted {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}
/**
 * 读取系统所有应用的名称.
 * 这个是利用不越狱的机器没有这个权限来判定的。
 */
#define USER_APP_PATH                 @"/User/Applications/"
+ (BOOL)detectJailBreakByAppPathExisted {
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
//        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        return YES;
    }
    return NO;
}
/**
 * 这个DYLD_INSERT_LIBRARIES环境变量，在非越狱的机器上应该是空，越狱的机器上基本都会有Library/MobileSubstrate/MobileSubstrate.dylib.
 */
char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}
+ (BOOL)detectJailBreakByEnvironmentExisted {
    if (printEnv()) {
        return YES;
    }
    return NO;
}

// 在越狱环境中，通过检测当前进程环境变量的值来判断应用是否被注入攻击，示例代码如下：
//如果 env 不为 NULL，则应用被动态注入
typedef char* _Nullable (*GET_ENV_TYPE)(const char *);

static inline bool __attribute__((optnone))IJMCheckInsertLib() {
    GET_ENV_TYPE get_env = getenv;
    char *env = get_env("DYLD_INSERT_LIBRARIES");
    //不为 NULL 表示有动态库注入
    return env != NULL;
}

// 非越狱环境中，检索应用程序所加载的动态库是否是我们源程序所有，示例代码如下：
typedef uint32_t (*GET_IMAGE_COUNT)(void);
typedef const char* _Nullable (*GET_IMAGE_NAME)(uint32_t);
typedef char* _Nullable (*GET_STRSTR)(const char *, const char *);
const char *WHITE_LIST_LIBRARIES = "jtydmhapp、Frameworks/SecurePortal.framework/SecurePortal";

static inline bool __attribute__((optnone))IJMCheckInsertWhiteList() {
    GET_IMAGE_COUNT get_image_count = _dyld_image_count;
    GET_IMAGE_NAME get_image_name = _dyld_get_image_name;
    GET_STRSTR get_strstr = strstr;
    int count = get_image_count();
    for (int i = 0; i < count; i++) {
        //遍历拿到库名称！
        const char * imageName = get_image_name(i);
        NSString*filePath = [[NSString alloc] initWithBytes:imageName length:strlen(imageName) encoding:NSUTF8StringEncoding];
        NSArray *paths = [filePath componentsSeparatedByString:@".app/"];
        //判断应用内的动态库是否在白名单内(白名单需要包含应用内所有可执行文件名)
        if (paths.count > 1 && !get_strstr(WHITE_LIST_LIBRARIES, [paths[1] UTF8String])) {//该库非白名单之内
            return true;
        }
    }
    return false;
}

/// 是否重签名
+ (BOOL)isResignedApp {
    if(TARGET_IPHONE_SIMULATOR) {
        return NO;
    }
    /* 通过检测ipa中的embedded.mobileprovision中的我们打包Mac的公钥来确定是否签名被修改，
       但是需要注意的是此方法只适用于Ad Hoc或企业证书打包的情况，
       App Store上应用由苹果私钥统一打包，不存在embedded.mobileprovision文件
    */
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    if (!embeddedPath) {
        return NO;
    }
    NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
    NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (int i = 0; i < embeddedProvisioningLines.count; i++) {
        if ([embeddedProvisioningLines[i] rangeOfString:@"application-identifier"].location != NSNotFound) {
            NSInteger fromPosition = [embeddedProvisioningLines[i+1] rangeOfString:@"<string>"].location+8;
            NSInteger toPosition = [embeddedProvisioningLines[i+1] rangeOfString:@"</string>"].location;
            NSRange range;
            range.location = fromPosition;
            range.length = toPosition - fromPosition;
            NSString *fullIdentifier = [embeddedProvisioningLines[i+1] substringWithRange:range];
            NSMutableArray *identifierComponents = [[fullIdentifier componentsSeparatedByString:@"."] mutableCopy];
            if (identifierComponents.count) {
                NSString *appIdentifier = [identifierComponents firstObject];
                [identifierComponents removeObjectAtIndex:0];
                NSString *bundleIdentifier = [identifierComponents componentsJoinedByString:@"."];
                if (![appIdentifier isEqualToString:kTeamID] || ![bundleIdentifier isEqualToString:kAppBundleID]) {
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return YES;
            }
        }
    }
    return NO;
}

@end
