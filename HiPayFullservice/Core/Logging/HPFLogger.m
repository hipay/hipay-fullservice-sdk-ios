//
//  HPFLogger.m
//  Pods
//
//  Created by Jonathan TIRET on 14/03/2016.
//
//

#import "HPFLogger.h"
#include <asl.h>

#define hipay_fullservice_log(level, format) \
va_list args; \
va_start(args, format); \
NSString *finalMessage = [[NSString alloc] initWithFormat:message arguments:args]; \
[self logWithLevel:level andMessage:finalMessage]; \
va_end(args);

@implementation HPFLogger

+ (instancetype)sharedLogger
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        asl_add_log_file(NULL, STDERR_FILENO);
    }
    return self;
}

- (void)emerg:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_EMERG, message);
}

- (void)alert:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_ALERT, message);
}

- (void)crit:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_CRIT, message);
}

- (void)err:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_ERR, message);
}

- (void)warning:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_WARNING, message);
}

- (void)notice:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_NOTICE, message);
}

- (void)info:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_INFO, message);
}

- (void)debug:(NSString *)message, ... {
    hipay_fullservice_log(ASL_LEVEL_DEBUG, message);
}

- (void)logWithLevel:(int)level andMessage:(NSString *)message {
    
    NSString *finalMessage = [NSString stringWithFormat:@"<HiPay>: %@", message];
    
    asl_log(NULL, NULL, level, "%s", [finalMessage UTF8String]);
}

@end
