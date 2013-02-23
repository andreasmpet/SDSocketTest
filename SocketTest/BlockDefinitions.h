//
//  BlockDefinitions.h
//  SocketTest
//
//  Created by Andreas Petrov on 2/23/13.
//  Copyright (c) 2013 Knowit. All rights reserved.
//

@class SDSocketMessage;

typedef void (^StartupCompleteBlock)(BOOL success);
typedef void (^MessageReceivedBlock)(SDSocketMessage *message);