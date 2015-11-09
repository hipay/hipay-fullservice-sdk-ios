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
    self.text = [[HPTExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:self.text];
}

//- (BOOL)isValid
//{
//    if ([[HPTExpiryDateFormatter sharedFormatter] dateIsCompleteForPlainText:self.text]) {
//        NSDateComponents *dateComponents = [[HPTExpiryDateFormatter sharedFormatter] dateComponentsForPlainText:self.text];
//        
//        
//        if (currentDateComponents)
//        
//    }
//    
//    return YES;
//}

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
