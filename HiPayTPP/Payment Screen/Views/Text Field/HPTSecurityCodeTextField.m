//
//  HPTSecurityCodeTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 10/11/2015.
//
//

#import "HPTSecurityCodeTextField.h"
#import "HPTSecurityCodeFormatter.h"
#import "HPTPaymentScreenUtils.h"

@implementation HPTSecurityCodeTextField

- (void)textFieldDidChange:(id)sender
{
    self.text = [[HPTSecurityCodeFormatter sharedFormatter] formattedCodeWithPlainText:self.text];
}

- (BOOL)isValid
{
    return YES;
}

- (BOOL)isCompleted
{
    if (self.paymentProductCode != nil) {
        return [[HPTSecurityCodeFormatter sharedFormatter] codeIsCompleteForPlainText:self.text andPaymentProductCode:self.paymentProductCode];
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= self.text.length) {
        if (self.paymentProductCode != nil) {
            return ![[HPTSecurityCodeFormatter sharedFormatter] codeIsCompleteForPlainText:self.text andPaymentProductCode:self.paymentProductCode];            
        }
    }
    
    return YES;
}

@end
