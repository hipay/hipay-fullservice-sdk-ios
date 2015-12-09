//
//  HPFHTTPResponse.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPFHTTPResponse.h"

@implementation HPFHTTPResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body
{
    self = [super init];
    if (self) {
        _statusCode = statusCode;
        _body = [body copy];
    }
    return self;
}

@end
