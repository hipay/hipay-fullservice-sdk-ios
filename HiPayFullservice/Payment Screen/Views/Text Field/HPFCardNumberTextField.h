//
//  HPFCardNumberTextField.h
//  Pods
//
//  Created by HiPay on 04/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFCardNumberFormatter.h"
#import "HPFFormTableViewCell.h"
#import "HPFFormattedTextField.h"
#import "HPFCardNumberFormattable.h"

@interface HPFCardNumberTextField : HPFFormattedTextField <HPFCardNumberFormattable>

@property (nonatomic, readonly) NSSet *paymentProductCodes;//
@property (nonatomic, copy) NSString *rawCardNumber; // digits only

- (void)textFieldDidChange:(id)sender;
- (void)reapplyFormatting;

@end
