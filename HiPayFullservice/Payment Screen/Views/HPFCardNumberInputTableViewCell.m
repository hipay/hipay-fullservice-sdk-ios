//
//  HPFCardNumberInputTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 14/11/2015.
//
//

#import "HPFCardNumberInputTableViewCell.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFCardNumberTextField.h"

@implementation HPFCardNumberInputTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.inputLabel.text = HPFLocalizedString(@"CARD_NUMBER_LABEL");
}

- (void)setDefaultPaymentProductCode:(NSString *)defaultPaymentProductCode
{
    _defaultPaymentProductCode = defaultPaymentProductCode;
    
    if ([defaultPaymentProductCode isEqualToString:HPFPaymentProductCodeMaestro] || [defaultPaymentProductCode isEqualToString:HPFPaymentProductCodeBCMC]) {
        
        self.textField.attributedPlaceholder = [[HPFCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPFLocalizedString(@"CARD_NUMBER_PLACEHOLDER_MAESTRO_BCMC") forPaymentProductCode:HPFPaymentProductCodeMaestro];
        
    }
    
    else if ([defaultPaymentProductCode isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
        
        self.textField.attributedPlaceholder = [[HPFCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPFLocalizedString(@"CARD_NUMBER_PLACEHOLDER_AMEX") forPaymentProductCode:HPFPaymentProductCodeAmericanExpress];
        
    }
    
    else if ([defaultPaymentProductCode isEqualToString:HPFPaymentProductCodeDiners]) {
        
        self.textField.attributedPlaceholder = [[HPFCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPFLocalizedString(@"CARD_NUMBER_PLACEHOLDER_DINERS") forPaymentProductCode:HPFPaymentProductCodeDiners];
        
    }
    
    // Default
    else {
        self.textField.attributedPlaceholder = [[HPFCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPFLocalizedString(@"CARD_NUMBER_PLACEHOLDER_VISA_MASTERCARD") forPaymentProductCode:HPFPaymentProductCodeVisa];;
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
