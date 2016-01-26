//
//  HPFAbstractSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFAbstractSerializationMapper.h"
#import "HPFAbstractSerializationMapper+Encode.h"

@implementation HPFAbstractSerializationMapper

+ (instancetype)mapperWithRequest:(id)request
{
    return [[[self class] alloc] initWithRequest:request];
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

- (NSDictionary *)createImmutableDictionary:(NSMutableDictionary *)dictionary
{
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)serializedRequest
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ should be overridden in a subclass.", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (NSMutableDictionary *)createResponseDictionary
{
    return [NSMutableDictionary dictionary];
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
        formatter.groupingSeparator = @"";

        return [formatter stringFromNumber:object];
    }
    
    return nil;
}

+ (NSString *)formatAmountNumber:(NSNumber *)amountNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 4;
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.groupingSeparator = @"";
    formatter.decimalSeparator = @".";
    
    return [formatter stringFromNumber:amountNumber];
}

- (NSString *)getFloatForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        return [HPFAbstractSerializationMapper formatAmountNumber:object];
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
            formatter.groupingSeparator = @"";

            return [formatter stringFromNumber:object];
        }
    }
    
    return nil;
}

- (NSString *)getSerializedJSONForKey:(NSString *)key
{
    id object = [self.request valueForKey:key];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        
        // Dictionary convertable to JSON ?
        if ([NSJSONSerialization isValidJSONObject:object])
        {
            // Serialize the dictionary
            NSError *error = nil;
            NSData * JSONData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            
            // If no errors, let's view the JSON
            if (JSONData != nil && error == nil)
            {
                return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
            }
        }
        
    }
    
    return nil;
}

@end
