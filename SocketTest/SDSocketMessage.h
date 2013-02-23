//
//  Created by Andreas Petrov on 2/22/13.
//  Copyright (c) 2013 Reaktor Magma. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SDSocketMessage : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSDictionary *payload;

- (id)initWithId:(NSString *)identifier name:(NSString *)name to:(NSString *)to from:(NSString *)from payload:(NSDictionary *)payload;

/*!
 @abstract
 Serializes the object to a NSString that can be sent as a JSON response.
 */
- (NSString *)jsonData;

@end