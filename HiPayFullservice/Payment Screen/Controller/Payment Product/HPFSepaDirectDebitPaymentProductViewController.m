//
//  HPFSepaDirectDebitPaymentProductViewController.m
//  Pods
//
//  Created by Morgan BAUMARD on 21/12/2018.
//

#import "HPFSepaDirectDebitPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFSepaDirectDebitPaymentMethodRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPFValidation.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFIbanUtils.h"

@implementation HPFSepaDirectDebitPaymentProductViewController

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPFSepaDirectDebitPaymentMethodRequest sepaDirectDebitPaymentMethodRequestWithfirstname:[self textForIdentifier:@"firstname"]
                                                                                                                 lastname:[self textForIdentifier:@"lastname"]
                                                                                                                     iban:[self textForIdentifier:@"iban"]
                                                                                                         recurringPayment:0];
    
    return orderRequest;
}

- (BOOL)submitButtonEnabled
{
    return [[self textForIdentifier:@"firstname"] isDefined] && [[self textForIdentifier:@"lastname"] isDefined] && [HPFIbanUtils isValidIBAN:[self textForIdentifier:@"iban"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else {
        return 1;
    }
}

- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return 1;
}

- (NSInteger) scanSection {
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super dequeuePaymentButtonCell];
    }
    
    if (indexPath.row == 0) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"firstname"];
        
        cell.inputLabel.text = HPFLocalizedString(@"SEPA_DIRECT_DEBIT_FIRSTNAME");
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        return cell;
    }
    else if (indexPath.row == 1) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"lastname"];
        
        cell.inputLabel.text = HPFLocalizedString(@"SEPA_DIRECT_DEBIT_LASTNAME");
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        return cell;
    }
    else if (indexPath.row == 2) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"iban"];
        
        cell.inputLabel.text = HPFLocalizedString(@"SEPA_DIRECT_DEBIT_IBAN");
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.textField.returnKeyType = UIReturnKeyDone;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Form edition

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self textFieldForIdentifier:@"firstname"]) {
        [[self textFieldForIdentifier:@"lastname"] becomeFirstResponder];
        return YES;
    }
    
    if (textField == [self textFieldForIdentifier:@"lastname"]) {
        [[self textFieldForIdentifier:@"iban"] becomeFirstResponder];
        return YES;
    }
    
    return [super textFieldShouldReturn:textField];
}


@end
