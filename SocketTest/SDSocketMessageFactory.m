//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//

#import "SDSocketMessageFactory.h"

static NSUInteger sCurrentMessageId = 0;

@implementation SDSocketMessageFactory
{

}

+ (SDSocketMessage *)createMessageFromJSONString:(NSString *)jsonString
{

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

    return [[SDSocketMessage alloc] initWithId:[dict objectForKey:@"_id"]
                                          name:[dict objectForKey:@"name"]
                                            to:[dict objectForKey:@"to"]
                                          from:[dict objectForKey:@"from"]
                                       payload:[dict objectForKey:@"payload"]];
}

+ (SDSocketMessage *)createInitMessage
{
    return [[SDSocketMessage alloc] initWithId:@"websocket-0"
                                          name:@".init"
                                            to:nil
                                          from:nil
                                       payload:nil];
}

+ (SDSocketMessage *)createCreateSessionMessage
{
    // Seeing as I don't know how to generate the payload
    // of the create-session frame I will just copy paste something
    // I found by inspecting the web-player
    NSString * copyPasta = @"{\"_id\":\"websocket-1\",\"name\":\".create-session\",\"payload\":{\"client\":{\"_id\":\"WLWwkbJR12W28zFXpoY1rSq4tHgzUdjktYFFoGzdeCe\",\"instance\":\"05679d2f4e6d1f4b272083bbd246ebb965bbfd26\",\"version\":\"5cce211\",\"language\":\"en\",\"protocol\":2}}}";
    
    return [self createMessageFromJSONString:copyPasta];
}


+ (SDSocketMessage *)createEmptyGetMessage
{
    return [[SDSocketMessage alloc] initWithId:[self createMessageId]
                                          name:@".get"
                                            to:nil
                                          from:nil
                                       payload:[NSDictionary new]];
}

+ (NSString *)createMessageId
{
    // Convert from decimal to hex
    NSString *msgId = [NSString stringWithFormat:@"%x",sCurrentMessageId];
    sCurrentMessageId++;
    return msgId;
}


@end