//
//  ViewController.m
//  SocketTest
//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import "SocketKeepAliveTestViewController.h"
#import "SDSessionManager.h"

#define kSocketConnectionURLString @"ws://wocket.soundrop.fm/websocket"

@interface SocketKeepAliveTestViewController ()

@property (strong, nonatomic) SDSessionManager *sessionManager;
@property (weak, nonatomic) IBOutlet UILabel *sessionIdLabel;
@end

@implementation SocketKeepAliveTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sessionManager = [SDSessionManager new];
    self.sessionIdLabel.text = @"Starting session...";
    [self.sessionManager startSessionWithURL:[NSURL URLWithString:kSocketConnectionURLString] onComplete:^(BOOL success)
    {
        self.sessionIdLabel.text = self.sessionManager.sessionID;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
