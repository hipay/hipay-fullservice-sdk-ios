//
//  HPTExpiryDateFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTExpiryDateFormatter.h"
#import "HPTFormatter_Private.h"

HPTExpiryDateFormatter *HPTExpiryDateFormatterSharedInstance = nil;

@implementation HPTExpiryDateFormatter

+ (instancetype)sharedFormatter
{
    if (HPTExpiryDateFormatterSharedInstance == nil) {
        HPTExpiryDateFormatterSharedInstance = [[HPTExpiryDateFormatter alloc] init];
    }
    
    return HPTExpiryDateFormatterSharedInstance;
}

- (NSString *)formattedDateWithPlainText:(NSString *)plainText
{
    NSString *digits = [self digitsOnlyFromPlainText:plainText];
    
    if (digits.length >= 2) {
        NSMutableString *mutableDigits = [NSMutableString stringWithString:digits];
        [mutableDigits insertString:@" / " atIndex:2];
        return mutableDigits;
    }
    
    return digits;
}

- (BOOL)dateIsCompleteForPlainText:(NSString *)plainText
{
    NSString *digits = [self digitsOnlyFromPlainText:plainText];

    return digits.length >= 4;
}

- (NSDateComponents *)dateComponentsForPlainText:(NSString *)plainText
{
    NSString *digits = [self digitsOnlyFromPlainText:plainText];

    if (digits.length == 4) {
        
        NSInteger month = [[digits substringToIndex:2] integerValue];
        NSInteger year = [[digits substringFromIndex:2] integerValue];
        
        if (NSLocationInRange(month, NSMakeRange(1, 12)) && NSLocationInRange(year, NSMakeRange(0, 100))) {
            
            NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
            NSUInteger currentYear = currentDateComponents.year;
            
            NSInteger lowerBoundYear = currentYear - 50;
            NSInteger upperBoundYear = currentYear + 50;
            
            NSInteger lowerCentury = floor(lowerBoundYear / 100.) * 100;
            NSInteger upperCentury = floor(upperBoundYear / 100.) * 100;
            
            NSInteger lowerYearOption = lowerCentury + year;
            NSInteger upperYearOption = upperCentury + year;
            
            NSDateComponents *resultDateComponents = [[NSDateComponents alloc] init];
            resultDateComponents.month = month;
            
            if (lowerYearOption >= lowerBoundYear) {
                resultDateComponents.year = lowerYearOption;
            } else {
                resultDateComponents.year = upperYearOption;
            }
            
            return resultDateComponents;
        }
    }
    
    return nil;
}

@end
