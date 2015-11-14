//
//  HPTCardNumberInputTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 14/11/2015.
//
//

#import "HPTCardNumberInputTableViewCell.h"
#import "HPTPaymentScreenUtils.h"
#import "HPTCardNumberTextField.h"

@implementation HPTCardNumberInputTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.inputLabel.text = HPTLocalizedString(@"CARD_NUMBER_LABEL");
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setDefaultPaymentProductCode:(NSString *)defaultPaymentProductCode
{
    _defaultPaymentProductCode = defaultPaymentProductCode;
    
    if ([defaultPaymentProductCode isEqualToString:HPTPaymentProductCodeMaestro] || [defaultPaymentProductCode isEqualToString:HPTPaymentProductCodeBCMC]) {
        
        self.textField.attributedPlaceholder = [[HPTCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER_MAESTRO_BCMC") forPaymentProductCode:HPTPaymentProductCodeMaestro];
        
    }
    
    else if ([defaultPaymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        
        self.textField.attributedPlaceholder = [[HPTCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER_AMEX") forPaymentProductCode:HPTPaymentProductCodeAmericanExpress];
        
    }
    
    else if ([defaultPaymentProductCode isEqualToString:HPTPaymentProductCodeDiners]) {
        
        self.textField.attributedPlaceholder = [[HPTCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER_DINERS") forPaymentProductCode:HPTPaymentProductCodeDiners];
        
    }
    
    // Default
    else {
        self.textField.attributedPlaceholder = [[HPTCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER_VISA_MASTERCARD") forPaymentProductCode:HPTPaymentProductCodeVisa];;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
