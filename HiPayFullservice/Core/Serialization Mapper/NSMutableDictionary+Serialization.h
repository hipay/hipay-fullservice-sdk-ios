//
//  NSMutableDictionary+Serialization.h
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Serialization)

- (void)setNullableObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)mergeDictionary:(NSDictionary *)dictionary withPrefix:(NSString *)prefix;

@end
