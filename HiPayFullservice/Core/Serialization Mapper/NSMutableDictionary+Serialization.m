//
//  NSMutableDictionary+Serialization.m
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import "NSMutableDictionary+Serialization.h"

@implementation NSMutableDictionary (Serialization)

- (void)setNullableObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject != nil) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)mergeDictionary:(NSDictionary *)dictionary withPrefix:(NSString *)prefix
{
    if (dictionary != nil) {
        if (prefix == nil) {
            prefix = @"";
        }
        
        for (NSString *key in [dictionary allKeys]) {
            [self setObject:[dictionary objectForKey:key] forKey:[prefix stringByAppendingString:key]];
        }        
    }
}

@end
