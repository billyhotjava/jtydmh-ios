//
//  PacketTunnelProvider.m
//  PacketTunnel
//
//  Created by eccl on 2024/3/31.
//
//

#import "PacketTunnelProvider.h"

@interface PacketTunnelProvider ()
//@property NWTCPConnection *connection;
//@property (strong) void (^pendingStartCompletion)(NSError *);
@end

@implementation PacketTunnelProvider

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    [super startTunnelWithOptions:options completionHandler:completionHandler];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    [super stopTunnelWithReason:reason completionHandler:completionHandler];
}
@end
