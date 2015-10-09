//
//  AbsractMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTAbstractMapper (Decode)

- (id)getObjectForKey:(NSString *)key;
- (NSString *)getStringForKey:(NSString *)key;
- (NSNumber *)getEnumCharForKey:(NSString *)key;
- (NSString *)getLowercaseStringForKey:(NSString *)key;
- (NSNumber *)getNumberForKey:(NSString *)key;
- (NSInteger)getIntegerFromKey:(NSString *)key;
- (NSInteger)getIntegerEnumValueWithKey:(NSString *)key defaultEnumValue:(NSInteger)defaultValue allValues:(NSDictionary *)allValues;

- (BOOL)isValid;

@end
