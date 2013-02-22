//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//


#import "SDSocketMessage.h"


@implementation SDSocketMessage
{

}

- (id)initWithId:(NSString *)id name:(NSString *)name to:(NSString *)to from:(NSString *)from payload:(NSDictionary *)payload
{
    if ((self = [super init]))
    {
        self.id = id;
        self.name = name;
        self.to = to;
        self.from = from;
        self.payload = payload;
    }

    return self;
}

- (NSDictionary *)jsonObject
{
    return @{
        @"id"   : self.id,
        @"name" : self.name,
        @"to"   : self.to,
        @"from" : self.from,
        @"payload" : self.payload,
    };
}


@end