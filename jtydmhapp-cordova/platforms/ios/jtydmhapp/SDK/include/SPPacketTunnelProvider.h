//
//  PacketTunnelProvider.h
//  TunnelServices
//
//  Created by HalloWorld on 15/12/31.
//  Copyright © 2015年 HalloWorld. All rights reserved.
//

//Abstract:
//This file contains the PacketTunnelProvider class. The PacketTunnelProvider class is a sub-class of NEPacketTunnelProvider, and is the integration point between the Network Extension framework and the SimpleTunnel tunneling protocol.

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>

//// MARK: Properties

typedef void (^pendingStartCompletionHander)(NSError* error);
typedef void (^pendingStopCompletionHandler)();

/// A packet tunnel provider object.
@interface SPPacketTunnelProvider : NEPacketTunnelProvider

/// The completion handler to call when the tunnel is fully established.
@property (copy) pendingStartCompletionHander pendingStartCompletion;
/// The completion handler to call when the tunnel is fully disconnected.
@property (copy) pendingStopCompletionHandler pendingStopCompletion;
@end


