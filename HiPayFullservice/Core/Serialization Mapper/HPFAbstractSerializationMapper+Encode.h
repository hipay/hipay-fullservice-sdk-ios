//
//  HPFAbstractSerializationMapper+Encode.h
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFAbstractSerializationMapper (Encode)

- (NSString *)getURLForKey:(NSString *)keyPath;
- (NSString *)getIntegerForKey:(NSString *)keyPath;
- (NSString *)getFloatForKey:(NSString *)keyPath;
- (NSString *)getDateForKey:(NSString *)keyPath;
- (NSString *)getDateForKey:(NSString *)keyPath timeZone:(NSTimeZone *)timeZone;
- (NSString *)getStringValuesListForKey:(NSString *)keyPath;
- (NSString *)getStringForKey:(NSString *)keyPath;
- (NSString *)getCharEnumValueForKey:(NSString *)key;
- (NSString *)getIntegerEnumValueForKey:(NSString *)key;
- (NSString *)getSerializedJSONForKey:(NSString *)key;

- (NSMutableDictionary *)createResponseDictionary;
- (NSDictionary *)createImmutableDictionary:(NSMutableDictionary *)dictionary;

@end
