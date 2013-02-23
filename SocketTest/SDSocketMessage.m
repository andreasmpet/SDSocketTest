//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//


#import "SDSocketMessage.h"


@implementation SDSocketMessage
{

}

- (id)initWithId:(NSString *)identifier name:(NSString *)name to:(NSString *)to from:(NSString *)from payload:(NSDictionary *)payload
{
    if ((self = [super init]))
    {
        self.identifier = identifier;
        self.name = name;
        self.to = to;
        self.from = from;
        self.payload = payload;
    }

    return self;
}

- (NSString *)jsonData
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary new];
    
    if (self.identifier != nil)
    {
       [jsonObject setObject:self.identifier forKey:@"_id"];
    }
    
    if (self.name != nil)
    {
       [jsonObject setObject:self.name forKey:@"name"];
    }
    
    if (self.to != nil)
    {
        [jsonObject setObject:self.to forKey:@"to"];
    }
    
    if (self.from != nil)
    {
        [jsonObject setObject:self.from forKey:@"from"];
    }
    
    if (self.payload != nil)
    {
        [jsonObject setObject:self.payload forKey:@"payload"];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:kNilOptions error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


@end