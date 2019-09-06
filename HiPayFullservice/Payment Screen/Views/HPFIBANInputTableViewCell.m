//
//  HPFIBANInputTableViewCell.m
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 14/01/2019.
//

#import "HPFIBANInputTableViewCell.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFIBANTextField.h"

@implementation HPFIBANInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inputLabel.text = HPFLocalizedString(@"HPF_SEPA_DIRECT_DEBIT_IBAN");
    
    self.textField.keyboardType = UIKeyboardTypeAlphabet;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textField.returnKeyType = UIReturnKeyDone;
}



@end
