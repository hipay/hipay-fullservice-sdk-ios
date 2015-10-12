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
            
            if (![self isValid]) {
                return nil;
            }
            
        } else {
            return nil;
        }
    }
    return self;
}

- (id _Nonnull)mappedObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ should be overridden in a subclass.", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)isValid
{
    return YES;
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
        
        if ([object isKindOfClass:[NSNumber class]]) {
            return [object stringValue];
        }
        
        return nil;
    }
    
    return object;
}

- (NSString *)getLowercaseStringForKey:(NSString *)key
{
    return [[self getStringForKey:key] lowercaseString];
}

- (NSNumber *)getEnumCharForKey:(NSString *)key
{
    NSString *object = [self getStringForKey:key];
    
    if ((object != nil) && (object.length == 1)) {
        return [NSNumber numberWithChar:[object characterAtIndex:0]];
    }
    
    
    return [NSNumber numberWithChar:' '];
}

- (NSNumber *)getNumberForKey:(NSString *)key
{
    id object = [self getObjectForKey:key];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            return [formatter numberFromString:object];
        }
        
        return nil;
    }
    
    return object;
}

- (NSInteger)getIntegerForKey:(NSString *)key
{
    NSNumber *object = [self getNumberForKey:key];
    
    if (object == nil) {
        return 0;
    }
    
    return [object integerValue];
}

- (NSInteger)getIntegerEnumValueWithKey:(NSString *)key defaultEnumValue:(NSInteger)defaultValue allValues:(NSDictionary *)allValues
{
    NSString *stringValue = [self getLowercaseStringForKey:key];
    
    if (stringValue != nil) {
        NSNumber *enumValue = [allValues objectForKey:stringValue];
        
        if (enumValue != nil) {
            return enumValue.integerValue;
        }
    }
    
    return defaultValue;
    
}

- (NSDate *)getDateISO8601ForKey:(NSString *)key
{
    NSString *stringDate = [self getStringForKey:key];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    return [dateFormatter dateFromString:stringDate];
}

- (NSDate *)getDateBasicForKey:(NSString *)key
{
    NSString *stringDate = [self getStringForKey:key];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    
    return [dateFormatter dateFromString:stringDate];
}

- (NSDate *)getDateForKey:(NSString *)key
{
    NSDate *date = [self getDateBasicForKey:key];
    
    if (date != nil) {
        return date;
    }
    
    return [self getDateISO8601ForKey:key];
}

- (NSNumber *)getBoolNumberForKey:(NSString *)key
{
    id object = [self getObjectForKey:key];
    
    if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@"true"]) {
            return @(YES);
        }
        else if ([object isEqualToString:@"false"]) {
            return @(NO);
        }
    }
    
    else if ([object isKindOfClass:[NSNumber class]]) {
        return @([object boolValue]);
    }
    
    return nil;
}

- (BOOL)getBoolForKey:(NSString *)key
{
    NSNumber *number = [self getBoolNumberForKey:key];
    
    if (number != nil) {
        return number.boolValue;
    }
    
    return NO;
}

@end
