//
//  ViewController.m
//  SocketTest
//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "SocketKeepAliveTestViewController.h"
#import "SocketConnectionHandler.h"
#import "SDSocketMessageFactory.h"

#define kSocketConnectionURLString @"ws://wocket.soundrop.fm/websocket"

@interface SocketKeepAliveTestViewController ()

@property (strong, nonatomic) SocketConnectionHandler *socketConnectionHandler;

@end

@implementation SocketKeepAliveTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.socketConnectionHandler = [SocketConnectionHandler new];
    [self.socketConnectionHandler openWithURL:[NSURL URLWithString:kSocketConnectionURLString]
                         startupCompleteBlock:^(BOOL success)
                         {
                             if (success)
                             {
                                 // Once the connection starts up, lets send an init message to do the handshake
                                 [self.socketConnectionHandler sendMessage:[SDSocketMessageFactory createInitMessage]];
                             }
                         }
                         messageReceivedBlock:^(SDSocketMessage *message)
                         {
                             // Do some stuff with your received message. Either parse it or formulate a response depending on the message.
                             // Preferably delegate that task to some kind of message handling center.
                         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
