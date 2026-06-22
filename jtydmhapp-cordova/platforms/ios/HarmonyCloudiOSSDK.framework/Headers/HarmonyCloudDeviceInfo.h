//
// HarmonyCloudDeviceInfo.h
//
//  Created by Yuli Hu on 2016/12/01.
//  Copyright © 2016年 HarmonyCloud Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Represents the device info class.
 *
 *  @version 1.0
 */
@interface HarmonyCloudDeviceInfo : NSObject

/**
 *  Represents the device id property.
 */
@property (nonatomic, strong) NSString *deviceID;

/**
 *  Get the shared instance of this singleton class.
 *
 *  @return the shared instance.
 */
+ (instancetype)sharedInstance;

/**
 *  Initialize this class with device ID.
 *
 *  @param deviceID The device ID to be initialized with.
 */
- (void)initializeDeviceID:(NSString *)deviceID;

/**
 *  Get zero safe IDFA of current device.
 *
 *  @return the zero safe IDFA.
 */
- (NSString *)zeroSafeIDFA;

/**
 *  Get the device model info.
 *
 *  @return the device model info.
 */
+ (NSString *)device;

/**
 *  Get the device name.
 *
 *  @return the device name.
 */
+ (NSString *)deviceName;

/**
 *  Get the phone number of current device.
 *
 *  @return the phone number of current device.
 */
+ (NSString *)getPhoneNumber;

/**
 *  Get the operating system name of current device.
 *
 *  @return the operating system name.
 */
+ (NSString *)osName;

/**
 *  Get the operating system version of current device.
 *
 *  @return the operating system version.
 */
+ (NSString *)osVersion;

/**
 *  Get the carrier of telephony network in current device.
 *
 *  @return the carrier of telephony network.
 */
+ (NSString *)carrier;

/**
 *  Get the resolution of current device.
 *
 *  @return the resolution.
 */
+ (NSString *)resolution;

/**
 *  Get the screen density of current device.
 *
 *  @return the density.
 */
+ (NSString *)density;

/**
 *  Get the identifier for the locale of current device.
 *
 *  @return the identifier for the locale.
 */
+ (NSString *)locale;

/**
 *  Get the app version.
 *
 *  @return the app version.
 */
+ (NSString *)appVersion;

/**
 *  Get the app build version.
 *
 *  @return the app build version.
 */
+ (NSString *)appBuild;

/**
 *  Get the app build UUID.
 *
 *  @return the app build UUID.
 */
+ (NSString *)buildUUID;

/**
 *  Get the app bundle identifier.
 *
 *  @return the app bundle identifier.
 */
+ (NSString *)bundleId;

/**
 *  Get the device info.
 *
 *  @return the device info.
 */
+ (NSString *)deviceInfo;

/**
 *  Get the environment info of current device.
 *
 *  @return the environment info.
 */
+ (NSString *)envInfo;

/**
 *  Get the environment info when the app is in ANR(application not respond).
 *
 *  @return the anr environment info.
 */
+ (NSString *)anrEnv:(float)prevCpuUsage;

/**
 *  Get current app's threads info.
 *
 *  @return the threads info.
 */
+ (NSString *)threadsInfo;

#if TARGET_OS_IOS
/**
 *  A Boolean indicating whether the current iPhone is paired to an Apple Watch.
 *
 *  @return YES when the iPhone is paired to an Apple Watch or NO when it is not.
 */
+ (NSInteger)hasWatch;

/**
 *  A Boolean value indicating whether the Watch app is installed on the currently paired and active Apple Watch.
 *
 *  @return YES when the Watch app associated with the current iOS app is installed on the user’s Apple Watch or NO when it is not installed.
 */
+ (NSInteger)installedWatchApp;
#endif

/**
 *  Get the app's metrics.
 *
 *  @return the metrics.
 */
+ (NSString *)metrics;

/**
 *  Get the app's connection type, i.e., none, wifi, 2G, 3G, etc.
 *
 *  @return the app's connection type.
 */
+ (NSString *)connectionType;

/**
 *  Get the free RAM of current device.
 *
 *  @return the free RAM number in bytes.
 */
+ (unsigned long long)freeRAM;

/**
 *  Get current app used ram.
 *
 *  @return the app used RAM number in bytes.
 */
+ (unsigned long long)currentAppUsedRAM;

/**
 *  Get total ram of current device.
 *
 *  @return the total RAM number in bytes.
 */
+ (unsigned long long)totalRAM;

/**
 *  Get free disk of current device.
 *
 *  @return the free disk number in bytes.
 */
+ (unsigned long long)freeDisk;

/**
 *  Get total disk of current device.
 *
 *  @return the total disk number in bytes.
 */
+ (unsigned long long)totalDisk;

/**
 *  Get current cpu usage of current device.
 *
 *  @return the cpu usage float number.
 */
+ (float) cpuUsage;

/**
 *  Get current battery level of device.
 *
 *  @return the battery level.
 */
+ (NSInteger)batteryLevel;

/**
 *  Get current orientation of device.
 *
 *  @return the orientation of device.
 */
+ (NSString *)orientation;

/**
 *  Get the cpu architecture of current device.
 *
 *  @return the cpu architecture info.
 */
+ (NSString *)cpuAbi;

/**
 *  Get the OpenGL ES version of current device.
 *
 *  @return the the OpenGL ES version.
 */
+ (float)OpenGLESversion;

/**
 * Returns a Boolean value indicating whether current device is jail broken.
 *
 *  @return YES if current device is jail broken, else NO.
 */
+ (BOOL)isJailbroken;

/**
 * Returns a Boolean value indicating whether location services are enabled on the device.
 *
 *  @return YES if location services are enabled, else NO.
 */
+ (BOOL)isLocationServicesEnabled;

/**
 *  Check if the runtime state of the app is in background.
 *
 *  @return YES if app state is in background, else NO.
 */
+ (BOOL)isInBackground;
@end
