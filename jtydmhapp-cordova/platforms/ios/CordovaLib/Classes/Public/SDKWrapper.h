//
//  SDKWrapper.h
//  SdkDemo
//
//

#import <Foundation/Foundation.h>

@interface SDKWrapper : NSObject

+ (SDKWrapper*)getInstance;

- (void)runWithParams:(NSDictionary*)params responseHandler:(void (^)( BOOL result))responseHandler;
- (void)stop;
- (BOOL)isConnected;

- (NSArray*)getServiceList;

- (NSInteger)queryHttpProxyPort;
- (NSInteger)queryMappingPortWithHost:(NSString*)host port:(NSInteger)port;

@end
