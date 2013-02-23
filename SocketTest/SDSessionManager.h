//
//  SDSessionManager.h
//  SocketTest
//
//  Created by Andreas Petrov on 2/23/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockDefinitions.h"

@interface SDSessionManager : NSObject

typedef enum {
    SDSessionManagerStateNotStarted,
    SDSessionManagerStateHandshakeStarted,
    SDSessionManagerStateHandshakeConfirmed,
    SDSessionManagerStateSessionCreationConfirmed,
    SDSessionManagerStateSessionDataReceived,
    SDSessionManagerStateSessionFailed
} SDSessionManagerState;

@property (copy, readonly, nonatomic) NSString *sessionID;
@property (strong, readonly, nonatomic) NSArray *sdSpaces;
@property (assign, readonly, nonatomic) SDSessionManagerState sessionState;


- (void)startSessionWithURL:(NSURL *)url onComplete:(StartupCompleteBlock)sessionStartupBlock;

@end
