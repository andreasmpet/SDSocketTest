//
//  SocketConnectionHandler.h
//  SocketTest
//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class SDSocketMessage;

typedef void (^StartupCompleteBlock)(BOOL success);
typedef void (^MessageReceivedBlock)(SDSocketMessage *message);

@interface SocketConnectionHandler : NSObject <SRWebSocketDelegate>

/*!
 @abstract
 Opens a socket to the given URL.
 Two blocks can be provided to execute code when the opening has been completed and when
 messages have been received.
 */
- (void)openWithURL:(NSURL *)webSocketURL
startupCompleteBlock:(StartupCompleteBlock)completionBlock
messageReceivedBlock:(MessageReceivedBlock)messageReceivedBlock;


/*!
 @abstract
 Sends a message if the socket is open.
 */
- (void)sendMessage:(SDSocketMessage *)message;

/*!
 @abstract
 Explicitly close the socket.
 */
- (void)closeSocket;

/*!
 @abstract
 The URL used to connect to the WebSocket.
 Set by using startWithURL
 */
@property (strong, readonly, nonatomic) NSURL *connectionURL;

/*!
 @abstract
 If the websocket fails at some point setting this property to YES
 will cause the handler to retry connection to that socket.
 default value is NO
 */
@property (assign, nonatomic) BOOL retryOnFailure;

/*!
 @abstract
 The number of times to retry connection upon failure.
 Only relevant if retryOnFailure is YES
 */
@property (assign, nonatomic) NSUInteger maxRetryCount;

/*!
 @abstract
 returns whether or not the handler currently has a socket open.
 */
@property (assign, readonly, nonatomic, getter=isSocketOpen) BOOL socketOpen;

@end
