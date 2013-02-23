//
//  SDSessionManager.m
//  SocketTest
//
//  Created by Andreas Petrov on 2/23/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "SDSessionManager.h"
#import "SocketConnectionHandler.h"
#import "SDSocketMessageFactory.h"

@interface SDSessionManager ()

@property (strong, nonatomic) SocketConnectionHandler *socketConnectionHandler;
@property (assign, readwrite, nonatomic) SDSessionManagerState sessionState;
@property (copy, readwrite, nonatomic) NSString *sessionID;
@property (copy, nonatomic) StartupCompleteBlock sessionStartupBlock;

@end

@implementation SDSessionManager

- (void)startSessionWithURL:(NSURL *)url onComplete:(StartupCompleteBlock)sessionStartupBlock
{
    self.sessionStartupBlock = sessionStartupBlock;
    self.socketConnectionHandler = [SocketConnectionHandler new];
    [self.socketConnectionHandler openWithURL:url
     startupCompleteBlock:^(BOOL success)
     {
         if (success)
         {
             self.sessionState = SDSessionManagerStateHandshakeStarted;
             // Once the connection starts up, lets send an init message to do the handshake
             [self.socketConnectionHandler sendMessage:[SDSocketMessageFactory createInitMessage]
                                            onResponse:^(SDSocketMessage *message)
             {
                 self.sessionState = SDSessionManagerStateHandshakeConfirmed;
                 [self createSession];
             }];
         }
         else
         {
             self.sessionState = SDSessionManagerStateSessionFailed;
         }
     }];
}

// Tell the server to create a session for you
- (void)createSession
{
     // After the handshake has taken place, send a message to the server to create a new session
     [self.socketConnectionHandler sendMessage:[SDSocketMessageFactory createCreateSessionMessage]
                                    onResponse:^(SDSocketMessage *message)
     {
         self.sessionState = SDSessionManagerStateSessionCreationConfirmed;
         [self requestSessionInfo];
     }];
}

// WARNING: Only to be called from within createSession response block
- (void)requestSessionInfo
{
     // After the handshake has taken place, send a message to the server to create a new session
     [self.socketConnectionHandler sendMessage:[SDSocketMessageFactory createEmptyGetMessage]
                                    onResponse:^(SDSocketMessage *message)
     {
         NSAssert(self.sessionID == nil, @"Should only be called if there is no current session");

         self.sessionState  = SDSessionManagerStateSessionDataReceived;
         self.sessionID     = [message.payload objectForKey:@"_id"];

         BOOL success = self.sessionID != nil;
         if (success)
         {
             NSLog(@"Session started: %@",self.sessionID);
             if (self.sessionStartupBlock)
             {
                 // Call back to the startup block to say our session has been created successfully
                 self.sessionStartupBlock(YES);
             }
         }
         else
         {
             NSLog(@"Failed to get session id from session creation message.");
             self.sessionState = SDSessionManagerStateSessionFailed;
             if (self.sessionStartupBlock)
             {
                 self.sessionStartupBlock(NO);
             }
         }
     }];
}


@end
