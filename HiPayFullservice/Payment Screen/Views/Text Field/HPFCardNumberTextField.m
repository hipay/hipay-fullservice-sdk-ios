//
//  HPFCardNumberTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import "HPFCardNumberTextField.h"

@implementation HPFCardNumberTextField

- (void)textFieldDidChange:(id)sender
{
    _paymentProductCodes = [HPFCardNumberFormatter.sharedFormatter paymentProductCodesForPlainTextNumber:self.text];
    
    NSInteger offset = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    
    if (self.paymentProductCodes.count == 1) {
        self.attributedText = [HPFCardNumberFormatter.sharedFormatter formatPlainTextNumber:self.text forPaymentProductCode:self.paymentProductCodes.anyObject];
    }

    UITextPosition *newPosition = [self positionFromPosition:self.beginningOfDocument offset:offset];
    UITextRange *selectedRange = [self textRangeFromPosition:newPosition toPosition:newPosition];
    
    [self setSelectedTextRange:selectedRange];
}

- (BOOL)isValid
{
    if (self.paymentProductCodes.count == 1) {
        if ([HPFCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.anyObject]) {
            return [HPFCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.anyObject];
        }
        
        return YES;
    }
    
    return (self.paymentProductCodes.count > 0) || (self.text.length == 0);
}

- (BOOL)isCompleted
{
    if (self.paymentProductCodes.count == 1) {
        return [HPFCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.anyObject];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (self.paymentProductCodes.count == 1) {
        if (range.location >= self.text.length) {
            return ![HPFCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.anyObject];
        }
    }
    
    return YES;
}

@end
