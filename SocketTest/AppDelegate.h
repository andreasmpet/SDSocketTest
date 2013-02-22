//
//  AppDelegate.h
//  SocketTest
//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocketKeepAliveTestViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SocketKeepAliveTestViewController *viewController;

@end
