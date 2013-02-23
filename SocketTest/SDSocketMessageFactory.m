//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//

#import "SDSocketMessageFactory.h"
#import "SDSocketMessage.h"


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


@end