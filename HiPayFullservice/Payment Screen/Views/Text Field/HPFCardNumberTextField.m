//
//  HPFCardNumberTextField.m
//  Pods
//
//  Created by HiPay on 04/11/2015.
//
//

#import "HPFCardNumberTextField.h"

@implementation HPFCardNumberTextField

- (void)textFieldDidChange:(id)sender
{
    UITextRange *selection = self.selectedTextRange;
    NSInteger cursorOffset =
        [self offsetFromPosition:self.beginningOfDocument
                      toPosition:selection.start];

    NSString *digits = [HPFCardNumberFormatter.sharedFormatter
           digitsOnlyFromPlainText:self.text];

       self.rawCardNumber = digits;
    
    _paymentProductCodes =
        [HPFCardNumberFormatter.sharedFormatter
            paymentProductCodesForPlainTextNumber:self.text];

    if (self.paymentProductCodes.count == 1) {
        NSString *code = self.paymentProductCodes.anyObject;

        NSAttributedString *formatted =
            [HPFCardNumberFormatter.sharedFormatter
                formatPlainTextNumber:self.text
                forPaymentProductCode:code];

        self.attributedText = formatted;

        NSInteger safeOffset =
            MIN(formatted.string.length, cursorOffset);
        UITextPosition *newPos =
            [self positionFromPosition:self.beginningOfDocument
                                offset:safeOffset];
        if (newPos) {
            self.selectedTextRange =
                [self textRangeFromPosition:newPos toPosition:newPos];
        }
    }
}

- (void)reapplyFormatting
{
    NSString *digits = [HPFCardNumberFormatter.sharedFormatter
                        digitsOnlyFromPlainText:self.text];

    self.text = digits;

    [self textFieldDidChange:self];
}


- (void)refreshFormattingForNetwork:(NSString *)productCode
{
    if (self.rawCardNumber.length == 0) { return; }

    NSAttributedString *formatted =
        [HPFCardNumberFormatter.sharedFormatter
         formatPlainTextNumber:self.rawCardNumber
         forPaymentProductCode:productCode];

    self.attributedText = formatted;
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

- (void)refreshFormatting
{
    if (self.rawCardNumber.length == 0) { return; }

    NSAttributedString *formatted =
        [HPFCardNumberFormatter.sharedFormatter
            formatPlainTextNumber:self.rawCardNumber
            forPaymentProductCode:nil];

    self.attributedText = formatted;
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
