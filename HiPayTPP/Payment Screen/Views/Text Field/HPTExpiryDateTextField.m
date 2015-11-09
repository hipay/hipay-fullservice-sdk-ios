//
//  HPTExpiryDateTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTExpiryDateTextField.h"

@implementation HPTExpiryDateTextField

//- (NSString *)digitsOnlyNumberForPlainTextNumber:(NSString *)plainTextNumber
//{
//    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    return [[plainTextNumber componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
//}
//
//- (void)textFieldDidChange:(id)sender
//{
//    _paymentProductCodes = [HPTCardNumberFormatter.sharedFormatter paymentProductCodesForPlainTextNumber:self.text];
//    
//    if (self.paymentProductCodes.count == 1) {
//        self.text = [HPTCardNumberFormatter.sharedFormatter formatPlainTextNumber:self.text forPaymentProductCode:self.paymentProductCodes.firstObject];
//    }
//}
//
//- (BOOL)isValid
//{
//    if (self.paymentProductCodes.count == 1) {
//        if ([HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject]) {
//            return [HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
//        }
//        
//        return YES;
//    }
//    
//    return (self.paymentProductCodes.count > 0) || (self.text.length == 0);
//}
//
//- (BOOL)isCompleted
//{
//    if (self.paymentProductCodes.count == 1) {
//        return [HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text isValidForPaymentProductCode:self.paymentProductCodes.firstObject];
//    }
//    
//    return NO;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ([finalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
//        [finalDelegate textFieldDidBeginEditing:textField];
//    }
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([finalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
//        [finalDelegate textFieldDidEndEditing:textField];
//    }
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    if (self.paymentProductCodes.count == 1) {
//        if (![string isEqualToString:@""]) {
//            return ![HPTCardNumberFormatter.sharedFormatter plainTextNumber:self.text reachesMaxLengthForPaymentProductCode:self.paymentProductCodes.firstObject];
//        }
//    }
//    
//    return YES;
//}

@end
