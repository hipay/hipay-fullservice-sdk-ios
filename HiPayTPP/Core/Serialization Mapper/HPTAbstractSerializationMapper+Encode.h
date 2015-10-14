//
//  HPTAbstractSerializationMapper+Encode.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTAbstractSerializationMapper (Encode)

- (NSString *)getURLForKeyPath:(NSString *)keyPath;
- (NSString *)getIntegerForKeyPath:(NSString *)keyPath;
- (NSString *)getFloatForKeyPath:(NSString *)keyPath;
- (NSString *)getDateForKeyPath:(NSString *)keyPath;
- (NSString *)getDateForKeyPath:(NSString *)keyPath timeZone:(NSTimeZone *)timeZone;
- (NSString *)getStringValuesListForKeyPath:(NSString *)keyPath;

@end
