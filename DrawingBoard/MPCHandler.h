//
//  MPCHandler.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/3/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MPCHandler : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCBrowserViewController *browser;

// Setup Peer
- (void)setupPeerWithDisplayName:(NSString *)displayName;

// Setup Session
- (void)setupSession;

// Advertise
- (void)advertiseSelf:(BOOL)advertise;

// Setup connection browser
- (void)setupBrowser;


@end