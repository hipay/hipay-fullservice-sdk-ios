//
//  HPTAbstractSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTAbstractSerializationMapper.h"
#import "HPTAbstractSerializationMapper+Encode.h"

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

- (NSString *)getURLForKeyPath:(NSString *)keyPath
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSURL class]]) {
        return [object absoluteString];
    }
    
    return nil;
}

- (NSString *)getIntegerForKeyPath:(NSString *)keyPath
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterNoStyle;
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        
        return [formatter stringFromNumber:object];
    }
    
    return nil;
}

- (NSString *)getFloatForKeyPath:(NSString *)keyPath
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 4;
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.decimalSeparator = @".";
        
        return [formatter stringFromNumber:object];
    }
    
    return nil;
}

- (NSString *)getDateForKeyPath:(NSString *)keyPath timeZone:(NSTimeZone *)timeZone
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSDate class]]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateFormatter.timeZone = timeZone;
        
        return [dateFormatter stringFromDate:object];
    }
    
    return nil;
}

- (NSString *)getDateForKeyPath:(NSString *)keyPath
{
    return [self getDateForKeyPath:keyPath timeZone:[NSTimeZone systemTimeZone]];
}

- (NSString *)getStringValuesListForKeyPath:(NSString *)keyPath
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSArray class]]) {
        return [object componentsJoinedByString:@","];
    }
    
    return nil;
}

- (NSString *)getStringForKeyPath:(NSString *)keyPath
{
    id object = [self.request valueForKey:keyPath];
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    return nil;
}

@end
