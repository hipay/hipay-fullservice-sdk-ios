//
//  HPTAbstractSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTAbstractSerializationMapper.h"

@implementation HPTAbstractSerializationMapper

+ (instancetype)mapperWithRequest:(id)request
{
    return [[HPTAbstractSerializationMapper alloc] initWithRequest:request];
}

- (instancetype)initWithRequest:(id)request
{
    self = [super init];
    if (self) {
        if (request == nil) {
            return nil;
        }
        
        _request = request;
    }
    return self;
}

- (NSDictionary *)serializedRequest
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ should be overridden in a subclass.", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
