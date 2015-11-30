//
//  HPTSecurityCodeInputTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 14/11/2015.
//
//

#import "HPTSecurityCodeInputTableViewCell.h"
#import "HPTPaymentScreenUtils.h"
#import "HPTSecurityCodeTextField.h"

@implementation HPTSecurityCodeInputTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setPaymentProductCode:(NSString *)paymentProductCode
{
    _paymentProductCode = paymentProductCode;
    
    HPTSecurityCodeType securityCodeType = [HPTPaymentProduct securityCodeTypeForPaymentProductCode:paymentProductCode];
    
    if (securityCodeType == HPTSecurityCodeTypeCID) {
        self.textField.placeholder = HPTLocalizedString(@"CARD_SECURITY_CODE_PLACEHOLDER_CID");
        self.inputLabel.text = HPTLocalizedString(@"CARD_SECURITY_CODE_LABEL_CID");
    }
    
    // Default: CVV
    else {
        self.textField.placeholder = HPTLocalizedString(@"CARD_SECURITY_CODE_PLACEHOLDER_CVV");
        self.inputLabel.text = HPTLocalizedString(@"CARD_SECURITY_CODE_LABEL_CVV");
    }
    
    ((HPTSecurityCodeTextField *)self.textField).paymentProductCode = paymentProductCode;
}

@end
