//
//  HPFExpiryDateTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPFExpiryDateTextField.h"
#import "HPFExpiryDateFormatter.h"

@implementation HPFExpiryDateTextField

- (void)textFieldDidChange:(id)sender
{
    self.attributedText = [[HPFExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:self.text];
}

- (BOOL)isValid
{
    if ([[HPFExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text]) {
        
        NSDateComponents *dateComponents = [[HPFExpiryDateFormatter sharedFormatter] dateComponentsForPlainText:self.text];
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
    return [[HPFExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text];
}

- (NSDateComponents *)dateComponents
{
    return [[HPFExpiryDateFormatter sharedFormatter] dateComponentsForPlainText:self.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *part = [textField.text substringWithRange:range];
    
    if ([part isEqualToString:@"/"] && [string isEqualToString:@""]) {
        
        self.attributedText = [[HPFExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:[self.text substringToIndex:fmax(range.location - 1, 0)]];
        
        return NO;
    }

    return [string isEqualToString:@""] || ![[HPFExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text];

}

@end
