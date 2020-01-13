//
//  HPFSecurityCodeInputTableViewCell.m
//  Pods
//
//  Created by HiPay on 14/11/2015.
//
//

#import "HPFSecurityCodeInputTableViewCell.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecurityCodeTextField.h"
#import "HPFPaymentProduct.h"

@implementation HPFSecurityCodeInputTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setPaymentProductCode:(NSString *)paymentProductCode
{
    _paymentProductCode = paymentProductCode;
    
    HPFSecurityCodeType securityCodeType = [HPFPaymentProduct securityCodeTypeForPaymentProductCode:paymentProductCode];
    
    if (securityCodeType == HPFSecurityCodeTypeCID) {
        self.textField.placeholder = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_PLACEHOLDER_CID");
        self.inputLabel.text = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_LABEL_CID");
    }
    
    // Default: CVV
    else {
        self.textField.placeholder = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_PLACEHOLDER_CVV");
        self.inputLabel.text = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_LABEL_CVV");
    }
    
    ((HPFSecurityCodeTextField *)self.textField).paymentProductCode = paymentProductCode;
}

@end
