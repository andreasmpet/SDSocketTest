//
//  SocketConnectionHandler.m
//  SocketTest
//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "SocketConnectionHandler.h"
#import "SDSocketMessage.h"
#import "SDSocketMessageFactory.h"

#define kDefaultMaxErrorRetryCount 10

@interface SocketConnectionHandler ()

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, readwrite, nonatomic) NSURL *connectionURL;
@property (assign, readwrite, nonatomic) BOOL socketOpen;
@property (assign, readwrite, nonatomic) NSUInteger currentRetryCount;
@property (copy, nonatomic) StartupCompleteBlock startupCompletionBlock;
@property (copy, nonatomic) MessageReceivedBlock messageReceivedBlock;

@end

@implementation SocketConnectionHandler

- (id)init
{
    if ((self = [super init]))
    {
        self.retryOnFailure = NO;
        self.maxRetryCount = kDefaultMaxErrorRetryCount;
    }

    return self;
}

- (void)startWithURL:(NSURL *)webSocketURL
startupCompleteBlock:(StartupCompleteBlock)completionBlock
messageReceivedBlock:(MessageReceivedBlock)messageReceivedBlock
{
    NSAssert(webSocketURL, @"startWithURL: requires a non-nil URL");
    self.connectionURL = webSocketURL;

    // Could probably in the future have blocks for failure and closure.
    // This should do for a POC
    self.startupCompletionBlock = completionBlock;
    self.messageReceivedBlock = messageReceivedBlock;

    // Close any old running socket
    [self.webSocket close];

    self.webSocket = [self createSocketWithURL:webSocketURL];
    [self.webSocket open];
}

- (void)sendMessage:(SDSocketMessage *)message
{
    if (self.socketOpen)
    {
        [self.webSocket send:[message jsonObject]];
    }
    else
    {
        NSLog(@"Tried to send a message without an open socket");
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"####### Socket Message ########\n%@", message);

    SDSocketMessage *sdMessage = [SDSocketMessageFactory createMessageFromDict:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"####### Socket Opened ########");
    self.socketOpen = YES;
    self.currentRetryCount = 0;

    if (self.startupCompletionBlock)
    {
        self.startupCompletionBlock(YES);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"####### Socket Failed ########\n%@", error);
    self.socketOpen = NO;

    BOOL allowedToRetry = self.retryOnFailure && self.currentRetryCount < kDefaultMaxErrorRetryCount;
    if (allowedToRetry)
    {
        [self startWithURL:self.connectionURL
      startupCompleteBlock:self.startupCompletionBlock
      messageReceivedBlock:self.messageReceivedBlock];
    }
    else
    {
        NSLog(@"Socket reached max retry count. Will stop retrying now...");
        self.startupCompletionBlock(NO);
        self.socketOpen = NO;
        self.webSocket = nil;
    }

    self.currentRetryCount++;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"####### Socket Closed ########\n%@", reason);
    self.socketOpen = NO;
    self.webSocket = nil;
}

- (void)closeSocket
{
    [self.webSocket close];
}

- (SRWebSocket *)createSocketWithURL:(NSURL *)url
{
    // I like to hide away construction like this in case it becomes more complex with time.
     return [[SRWebSocket alloc] initWithURL:url];
}

@end