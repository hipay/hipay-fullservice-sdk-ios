//
//  HPTAbstractSerializationMapper+Encode.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTAbstractSerializationMapper (Encode)

- (NSString *)getURLForKey:(NSString *)keyPath;
- (NSString *)getIntegerForKey:(NSString *)keyPath;
- (NSString *)getFloatForKey:(NSString *)keyPath;
- (NSString *)getDateForKey:(NSString *)keyPath;
- (NSString *)getDateForKey:(NSString *)keyPath timeZone:(NSTimeZone *)timeZone;
- (NSString *)getStringValuesListForKey:(NSString *)keyPath;
- (NSString *)getStringForKey:(NSString *)keyPath;
- (NSString *)getCharEnumValueForKey:(NSString *)key;
- (NSString *)getIntegerEnumValueForKey:(NSString *)key;

@end
