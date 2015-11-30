//
//  HPTExpiryDateTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTExpiryDateTextField.h"
#import "HPTExpiryDateFormatter.h"

@implementation HPTExpiryDateTextField

- (void)textFieldDidChange:(id)sender
{
    self.attributedText = [[HPTExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:self.text];
}

- (BOOL)isValid
{
    if ([[HPTExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text]) {
        
        NSDateComponents *dateComponents = [[HPTExpiryDateFormatter sharedFormatter] dateComponentsForPlainText:self.text];
        NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        
        NSInteger inputNumberOfMonths = (dateComponents.year - 1) * 12 + dateComponents.month;
        NSInteger currentNumberOfMonths = (currentDateComponents.year - 1) * 12 + currentDateComponents.month;
        NSInteger maxtNumberOfMonths = (currentDateComponents.year + 29) * 12 + currentDateComponents.month;
        
        return (inputNumberOfMonths >= currentNumberOfMonths) && (inputNumberOfMonths <= maxtNumberOfMonths);
        
    }
    
    return YES;
}

- (BOOL)isCompleted
{
    return [[HPTExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text];
}

- (NSDateComponents *)dateComponents
{
    return [[HPTExpiryDateFormatter sharedFormatter] dateComponentsForPlainText:self.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *part = [textField.text substringWithRange:range];
    
    if ([part isEqualToString:@"/"] && [string isEqualToString:@""]) {
        
        self.attributedText = [[HPTExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:[self.text substringToIndex:fmax(range.location - 1, 0)]];
        
        return NO;
    }

    return [string isEqualToString:@""] || ![[HPTExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text];

}

@end
