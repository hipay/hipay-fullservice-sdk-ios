//
//  HPFSecurityCodeTextField.m
//  Pods
//
//  Created by HiPay on 10/11/2015.
//
//

#import "HPFSecurityCodeTextField.h"
#import "HPFSecurityCodeFormatter.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFSecurityCodeTextField

- (void)textFieldDidChange:(id)sender
{
    self.text = [[HPFSecurityCodeFormatter sharedFormatter] formattedCodeWithPlainText:self.text];
}

- (BOOL)isValid
{
    return YES;
}

- (BOOL)isCompleted
{
    if (self.paymentProductCode != nil) {
        return [[HPFSecurityCodeFormatter sharedFormatter] codeIsCompleteForPlainText:self.text andPaymentProductCode:self.paymentProductCode];
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= self.text.length) {
        if (self.paymentProductCode != nil) {
            return ![[HPFSecurityCodeFormatter sharedFormatter] codeIsCompleteForPlainText:self.text andPaymentProductCode:self.paymentProductCode];            
        }
    }
    
    return YES;
}

@end
