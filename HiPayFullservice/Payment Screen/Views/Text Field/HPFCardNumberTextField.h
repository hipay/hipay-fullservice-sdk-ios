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

@interface HPFCardNumberTextField : HPFFormattedTextField

@property (nonatomic, readonly) NSSet *paymentProductCodes;//
- (void)textFieldDidChange:(id)sender;
@end
