//
//  MPCHandler.m
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/3/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "MPCHandler.h"

@implementation MPCHandler

NSString* const serviceID = @"drawingboard";

- (void)setupPeerWithDisplayName:(NSString *)displayName
{
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession
{
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)advertiseSelf:(BOOL)advertise
{
    if (advertise)
    {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"drawingboard" discoveryInfo:nil session:self.session];
        [self.advertiser start];
        
    }
    else
    {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (void)setupBrowser
{
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"drawingboard" session:_session];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawingBoard_ChangedState"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *userInfo = @{ @"data": data,
                                @"peerID": peerID };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawingBoard_ReceivedData"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    return;
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    return;
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    return;
}

- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}



@end