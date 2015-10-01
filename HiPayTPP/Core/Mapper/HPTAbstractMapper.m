//
//  AbsractMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTAbstractMapper.h"

@implementation HPTAbstractMapper

- (instancetype)initWithRawData:(NSDictionary *)rawData
{
    self = [super init];
    if (self) {
        _rawData = rawData;
    }
    return self;
}

- (id _Nullable)mappedObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ should be overridden in a subclass.", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (id)getObjectForKey:(NSString *)key
{
    id object = [[self rawData] objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return object;
}

@end
