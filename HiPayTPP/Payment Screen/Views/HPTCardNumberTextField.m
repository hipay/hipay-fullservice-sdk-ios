//
//  HPTCardNumberTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import "HPTCardNumberTextField.h"

@implementation HPTCardNumberTextField

- (void)awakeFromNib
{
    [super setDelegate:self];
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    formatter = [HPTCardNumberFormatter sharedFormatter];
}

- (void)textFieldDidChange:(id)sender
{
    _paymentProductCodes = [formatter paymentProductCodesForPlainTextNumber:self.text];
    
    if (self.paymentProductCodes.count == 1) {
        self.text = [formatter formatPlainTextNumber:self.text forPaymentProductCode:self.paymentProductCodes.firstObject];
    }
}

- (BOOL)isValid
{
    if (self.paymentProductCodes.count == 1) {
        if ([formatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject]) {
            return [formatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
        }
        
        return YES;
    }
    
    return (self.paymentProductCodes.count > 0) || (self.text.length == 0);
}

- (BOOL)isCompleted
{
    if (self.paymentProductCodes.count == 1) {
        return [formatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
    }
    
    return NO;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    finalDelegate = delegate;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([finalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [finalDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([finalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [finalDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [finalDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [finalDelegate textFieldShouldEndEditing:textField];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (self.paymentProductCodes.count == 1) {
        if (![string isEqualToString:@""]) {
            return ![formatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [finalDelegate textFieldShouldClear:textField];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [finalDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

@end
