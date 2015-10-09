//
//  AbsractMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTAbstractMapper.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTAbstractMapper

- (instancetype)initWithRawData:(NSDictionary *)rawData
{
    self = [super init];
    if (self) {
        if ([rawData isKindOfClass:[NSDictionary class]]) {
            _rawData = rawData;
        } else {
            return nil;
        }
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

- (NSString *)getStringForKey:(NSString *)key
{
    id object = [self getObjectForKey:key];
    
    if (![object isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return object;
}

- (NSNumber *)getEnumCharForKey:(NSString *)key
{
    NSString *object = [self getStringForKey:key];
    
    if ((object != nil) && (object.length == 1)) {
        return [NSNumber numberWithChar:[object characterAtIndex:0]];
    }
    
    
    return [NSNumber numberWithChar:-1];
}

@end
