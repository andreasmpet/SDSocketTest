//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SDSocketMessage.h"

@class SDSocketMessage;


@interface SDSocketMessageFactory : NSObject

/*!
 @abstract
 Creates a Soundrop socket message based on a response from the websocket.
 */
+ (SDSocketMessage *)createMessageFromJSONString:(NSString *)jsonString;

/*!
 @abstract
 Creates a Soundrop handshake message.
 */
+ (SDSocketMessage *)createInitMessage;


+ (SDSocketMessage *)createCreateSessionMessage;

+ (SDSocketMessage *)createEmptyGetMessage;
@end