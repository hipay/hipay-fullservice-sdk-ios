//
//  HPFLogger.h
//  Pods
//
//  Created by HiPay on 14/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface HPFLogger : NSObject

+ (void)err:(NSString *)message, ...;
+ (void)info:(NSString *)message, ...;
+ (void)debug:(NSString *)message, ...;
+ (void)fault:(NSString *)message, ...;

@end
