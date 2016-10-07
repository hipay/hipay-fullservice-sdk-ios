//
//  HPFExpiryDateFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPFExpiryDateFormatter.h"

@implementation HPFExpiryDateFormatter

+ (instancetype)sharedFormatter
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSAttributedString *)formattedDateWithPlainText:(NSString *)plainText
{
    NSMutableAttributedString *digits = [[NSMutableAttributedString alloc] initWithString:[self digitsOnlyFromPlainText:plainText] attributes:@{NSKernAttributeName: @0}];
    
    if ((digits.length == 1) && (digits.string.integerValue > 1)) {
        [digits insertAttributedString:[[NSAttributedString alloc] initWithString:@"0"] atIndex:0];
    }
    
    if (digits.length >= 2) {
        [digits addAttribute:NSKernAttributeName value:@5 range:(NSRange){1, 1}];
        [digits insertAttributedString:[[NSAttributedString alloc] initWithString:@"/" attributes:@{NSKernAttributeName: @5}] atIndex:2];
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
        
        if (NSLocationInRange(month, (NSRange){1, 12}) && NSLocationInRange(year, (NSRange){0, 100})) {
            
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
