//
//  HPTCardNumberTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import "HPTCardNumberTextField.h"

@implementation HPTCardNumberTextField

- (void)textFieldDidChange:(id)sender
{
    _paymentProductCodes = [HPTCardNumberFormatter.sharedFormatter paymentProductCodesForPlainTextNumber:self.text];
    
    NSInteger offset = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    
    if (self.paymentProductCodes.count == 1) {
        self.attributedText = [HPTCardNumberFormatter.sharedFormatter formatPlainTextNumber:self.text forPaymentProductCode:self.paymentProductCodes.firstObject];
        self.typingAttributes = self.defaultTextAttributes;
    }
    
    UITextPosition *newPosition = [self positionFromPosition:self.beginningOfDocument offset:offset];
    UITextRange *selectedRange = [self textRangeFromPosition:newPosition toPosition:newPosition];
    
    [self setSelectedTextRange:selectedRange];
}

- (BOOL)isValid
{
    if (self.paymentProductCodes.count == 1) {
        if ([HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject]) {
            return [HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
        }
        
        return YES;
    }
    
    return (self.paymentProductCodes.count > 0) || (self.text.length == 0);
}

- (BOOL)isCompleted
{
    if (self.paymentProductCodes.count == 1) {
        return [HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (self.paymentProductCodes.count == 1) {
        if (range.location >= self.text.length) {
            return ![HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject];
        }
    }
    
    return YES;
}

@end
