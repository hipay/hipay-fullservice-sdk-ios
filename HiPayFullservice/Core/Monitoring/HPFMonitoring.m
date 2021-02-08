//
//  HPFMonitoring.m
//  HiPayFullservice_Example
//
//  Created by HiPay on 02/09/2019.
//  Copyright © 2019 HiPay. All rights reserved.
//

#import "HPFMonitoring.h"

#define kDateInitKey @"date_init"
#define kDateDisplayKey @"date_display"
#define kDatePayKey @"date_pay"
#define kDateRequestKey @"date_request"
#define kDateResponseKey @"date_response"

@implementation HPFMonitoring

- (NSString *)getStringFromDateISO8601:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    return [dateFormatter stringFromDate:date];;
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *dict = [NSMutableDictionary new];

    if (self.initializeDate) {
        [dict setValue:[self getStringFromDateISO8601:self.initializeDate] forKey:kDateInitKey];
    }
 
    if (self.displayDate) {
        [dict setValue:[self getStringFromDateISO8601:self.displayDate] forKey:kDateDisplayKey];
    }
    
    if (self.payDate) {
        [dict setValue:[self getStringFromDateISO8601:self.payDate] forKey:kDatePayKey];
    }
    
    if (self.requestDate) {
        [dict setValue:[self getStringFromDateISO8601:self.requestDate] forKey:kDateRequestKey];
    }
    
    if (self.responseDate) {
        [dict setValue:[self getStringFromDateISO8601:self.responseDate] forKey:kDateResponseKey];
    }
    
    return dict;
}

@end
