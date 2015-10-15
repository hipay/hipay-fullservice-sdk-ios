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

- (NSString *)getURLForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSURL class]]) {
        return [object absoluteString];
    }
    
    return nil;
}

- (NSString *)getIntegerForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterNoStyle;
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        
        return [formatter stringFromNumber:object];
    }
    
    return nil;
}

- (NSString *)getFloatForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
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

- (NSString *)getDateForKey:(NSString *)key timeZone:(NSTimeZone *)timeZone
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSDate class]]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateFormatter.timeZone = timeZone;
        
        return [dateFormatter stringFromDate:object];
    }
    
    return nil;
}

- (NSString *)getDateForKey:(NSString *)key
{
    return [self getDateForKey:key timeZone:[NSTimeZone systemTimeZone]];
}

- (NSString *)getStringValuesListForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSArray class]]) {
        return [object componentsJoinedByString:@","];
    }
    
    return nil;
}

- (NSString *)getStringForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    return nil;
}

- (NSString *)getCharEnumValueForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        char character = [object charValue];
        
        if (character != ' ') {
            return [NSString stringWithFormat:@"%c" , character];
        }
    }
    
    return nil;
}

- (NSString *)getIntegerEnumValueForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        if ([object integerValue] != NSIntegerMax) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterNoStyle;
            formatter.roundingMode = NSNumberFormatterRoundFloor;
            
            return [formatter stringFromNumber:object];
        }
    }
    
    return nil;
}

@end
