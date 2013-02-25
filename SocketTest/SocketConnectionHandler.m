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


NSString *const SocketConnectionHandlerShouldPerformPingNotification = @"SocketConnectionHandlerShouldPerformPingNotification";

@interface SocketConnectionHandler ()

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, readwrite, nonatomic) NSURL *connectionURL;
@property (assign, readwrite, nonatomic) BOOL socketOpen;
@property (assign, readwrite, nonatomic) NSUInteger currentRetryCount;
@property (copy, nonatomic) StartupCompleteBlock startupCompletionBlock;

@property (strong, nonatomic) NSMutableDictionary *messageReceivedBlocks;

@end

@implementation SocketConnectionHandler

- (id)init
{
    if ((self = [super init]))
    {
        self.retryOnFailure = NO;
        self.maxRetryCount = kDefaultMaxErrorRetryCount;
        self.messageReceivedBlocks = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(performPing)
                                                    name:SocketConnectionHandlerShouldPerformPingNotification
                                                  object:nil];
    }

    return self;
}

- (void)openWithURL:(NSURL *)webSocketURL
startupCompleteBlock:(StartupCompleteBlock)completionBlock
{
    NSAssert(webSocketURL, @"startWithURL: requires a non-nil URL");
    self.connectionURL = webSocketURL;

    // Could probably in the future have blocks for failure and closure.
    // This should do for a POC
    self.startupCompletionBlock = completionBlock;

    // Close any old running socket
    [self.webSocket close];

    self.webSocket = [self createSocketWithURL:webSocketURL];
    [self.webSocket open];
}

- (void)sendMessage:(SDSocketMessage *)message onResponse:(MessageReceivedBlock)responseBlock
{
    if (self.socketOpen)
    {
        [self storeResponseBlock:responseBlock forMessage:message];
        [self.webSocket send:[message jsonData]];
    }
    else
    {
        NSLog(@"Tried to send a message without an open socket");
    }
}

- (void)storeResponseBlock:(MessageReceivedBlock)responseBlock forMessage:(SDSocketMessage *)message
{
    [self.messageReceivedBlocks setObject:responseBlock forKey:message.identifier];
}

- (void)clearCompletionBlockForMessage:(SDSocketMessage *)message
{
    [self.messageReceivedBlocks removeObjectForKey:message.identifier];
}

- (MessageReceivedBlock)findBlockToCallForMessage:(SDSocketMessage *)message
{
    return [self.messageReceivedBlocks objectForKey:message.identifier];
}

- (void)performPing
{
    [self.webSocket sendPing];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"####### Socket Message ########\n%@", message);

    SDSocketMessage *sdMessage = [SDSocketMessageFactory createMessageFromJSONString:message];
    MessageReceivedBlock blockToCallForMessage = [self findBlockToCallForMessage:sdMessage];
    if (blockToCallForMessage)
    {
        blockToCallForMessage(sdMessage);
        [self clearCompletionBlockForMessage:sdMessage];
    }
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
        [self openWithURL:self.connectionURL
     startupCompleteBlock:self.startupCompletionBlock];
    }
    else
    {
        NSLog(@"Socket reached max retry count. Will stop retrying now...");
        self.startupCompletionBlock(NO);
        [self resetSocket];
    }

    self.currentRetryCount++;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"####### Socket Closed ########\n%@", reason);
    [self resetSocket];
}

- (void)closeSocket
{
    [self.webSocket close];
}

- (void)resetSocket
{
    self.socketOpen = NO;
    self.webSocket = nil;
}

- (SRWebSocket *)createSocketWithURL:(NSURL *)url
{
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURL:url];
    socket.delegate = self;
    return socket;
}

@end
