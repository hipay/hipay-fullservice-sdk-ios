//
//  HPTHTTPResponse.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPTHTTPResponse.h"

@implementation HPTHTTPResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(NSDictionary *)body
{
    self = [super init];
    if (self) {
        _statusCode = statusCode;
        _body = [body copy];
    }
    return self;
}

@end
