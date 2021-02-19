//
//  HPFLogger.m
//  Pods
//
//  Created by HiPay on 14/03/2016.
//
//

#import "HPFLogger.h"
#include <OSLog/OSLog.h>
#define hipay_fullservice_log(level, format) \
va_list args; \
va_start(args, format); \
NSString *finalMessage = [[NSString alloc] initWithFormat:message arguments:args]; \
[self logWithLevel:level andMessage:finalMessage]; \
va_end(args);

@implementation HPFLogger

+ (void)err:(NSString *)message, ... {
    hipay_fullservice_log(OS_LOG_TYPE_ERROR, message)
}

+ (void)info:(NSString *)message, ... {
    hipay_fullservice_log(OS_LOG_TYPE_INFO, message)

}

+ (void)debug:(NSString *)message, ... {
    hipay_fullservice_log(OS_LOG_TYPE_DEBUG, message)
}

+ (void)fault:(NSString *)message, ... {
    hipay_fullservice_log(OS_LOG_TYPE_FAULT, message)
}

+ (void)logWithLevel:(int)level andMessage:(NSString *)message {
    NSString *finalMessage = [NSString stringWithFormat:@"<HiPay>: %@", message];
    os_log_with_type(OS_LOG_DEFAULT, level, "%s", [finalMessage UTF8String]);
}

    
@end
