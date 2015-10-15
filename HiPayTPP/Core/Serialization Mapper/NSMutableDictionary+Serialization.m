//
//  NSMutableDictionary+Serialization.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
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

@end
