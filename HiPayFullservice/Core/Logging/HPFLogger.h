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


// Swift bridge
+ (void)logErr:(NSString *)message NS_SWIFT_NAME(err(_:));
+ (void)logInfo:(NSString *)message NS_SWIFT_NAME(info(_:));
+ (void)logDebug:(NSString *)message NS_SWIFT_NAME(debug(_:));
+ (void)logFault:(NSString *)message NS_SWIFT_NAME(fault(_:));

@end
