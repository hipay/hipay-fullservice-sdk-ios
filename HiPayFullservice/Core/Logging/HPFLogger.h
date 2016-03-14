//
//  HPFLogger.h
//  Pods
//
//  Created by Jonathan TIRET on 14/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface HPFLogger : NSObject

+ (instancetype)sharedLogger;

- (void)emerg:(NSString *)message, ...;
- (void)alert:(NSString *)message, ...;
- (void)crit:(NSString *)message, ...;
- (void)err:(NSString *)message, ...;
- (void)warning:(NSString *)message, ...;
- (void)notice:(NSString *)message, ...;
- (void)info:(NSString *)message, ...;
- (void)debug:(NSString *)message, ...;

@end
