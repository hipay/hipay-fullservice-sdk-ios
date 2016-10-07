//
//  AbsractMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPFAbstractMapper.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFAbstractMapper

+ (instancetype)mapperWithRawData:(id)rawData
{
    return [[[self class] alloc] initWithRawData:rawData];
}

- (instancetype)initWithRawData:(id)rawData
{
    self = [super init];
    if (self) {
        _rawData = rawData;
        
        if (![self isClassValid] || ![self isValid]) {
            return nil;
        }
    }
    return self;
}

- (id _Nonnull)mappedObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ should be overridden in a subclass.", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)isClassValid
{
    return [_rawData isKindOfClass:[NSDictionary class]];
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
            formatter.decimalSeparator = @".";
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

- (NSDictionary *)getDictionaryForKey:(NSString *)key
{
    id object = [self getObjectForKey:key];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    
    return nil;
}

- (NSDateComponents *)getYearAndMonthForKey:(NSString *)key
{
    NSString *stringDate = [self getStringForKey:key];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyyMM"];
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    if (date == nil) {
        return nil;
    }
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
}

- (NSURL *)getURLForKey:(NSString *)key
{
    id object = [self getStringForKey:key];
    
    if ((object != nil) && (![object isEqualToString:@""])) {
        return [NSURL URLWithString:object];
    }
    
    return nil;
}

- (NSArray *)getObjectsArrayForObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj isKindOfClass:[NSDictionary class]];
        }].count == [object count]) {
            return object;
        }
    }
    
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if ([[object allKeys] indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![obj isKindOfClass:[NSString class]]) {
                return NO;
            }
            
            NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            NSRange r = [obj rangeOfCharacterFromSet:nonNumbers];
            
            return r.location == NSNotFound && [[object objectForKey:obj] isKindOfClass:[NSDictionary class]];
            
        }].count == [object count]) {
            return [object allValues];
        }
    }
    
    return nil;
}

@end
