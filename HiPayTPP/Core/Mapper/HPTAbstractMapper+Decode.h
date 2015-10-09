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

- (BOOL)isValid;

@end
