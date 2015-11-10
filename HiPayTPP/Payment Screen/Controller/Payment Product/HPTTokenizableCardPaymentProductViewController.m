//
//  HPTTokenizableCardPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import "HPTTokenizableCardPaymentProductViewController.h"
#import "HPTOrderRequest.h"
#import "HPTForwardPaymentProductViewController_Protected.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPTValidation.h"
#import "HPTPaymentScreenUtils.h"
#import "HPTQiwiWalletPaymentMethodRequest.h"
#import "HPTSecureVaultClient.h"
#import "HPTCardTokenPaymentMethodRequest.h"
#import "HPTCardNumberTextField.h"
#import "HPTExpiryDateTextField.h"

@interface HPTTokenizableCardPaymentProductViewController ()

@end

@implementation HPTTokenizableCardPaymentProductViewController

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPTQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestWithUsername:[self textForIdentifier:@"username"]];
    
    return orderRequest;
}

- (void)viewDidLayoutSubviews
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        UITextField *cardHolderTextField = [self textFieldForIdentifier:@"holder"];
        cardHolderTextField.text = self.paymentPageRequest.customer.displayName;
    });
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [super textFieldDidChange:textField];
    
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTExpiryDateTextField *expiryDateTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    HPTExpiryDateTextField *securityCodeTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"security_code"];
    
    if (textField == cardNumberTextField) {
        BOOL valid = cardNumberTextField.valid;
        [self cellWithTextField:cardNumberTextField].incorrectInput = !valid;
        
        if (valid && (cardNumberTextField.isCompleted)) {
            [expiryDateTextField becomeFirstResponder];
        }
    }
    
    else if (textField == expiryDateTextField) {
        BOOL valid = expiryDateTextField.valid;
        [self cellWithTextField:expiryDateTextField].incorrectInput = !valid;
        
        if (valid && (expiryDateTextField.isCompleted)) {
            [securityCodeTextField becomeFirstResponder];
        }
    }
}

- (BOOL)submitButtonEnabled
{
    return [[self textForIdentifier:@"number"] isDefined];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }
    
    return 1;
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPTPaymentButtonTableViewCell *)cell
{
    [self setPaymentButtonLoadingMode:YES];
    
    [[HPTSecureVaultClient sharedClient] generateTokenWithCardNumber:[self textForIdentifier:@"number"] cardExpiryMonth:@"12" cardExpiryYear:@"2019" cardHolder:[self textForIdentifier:@"holder"] securityCode:[self textForIdentifier:@"security_code"] multiUse:self.paymentPageRequest.multiUse andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
       
        [self setPaymentButtonLoadingMode:NO];
        
        if (cardToken != nil) {
            
            HPTOrderRequest *orderRequest = [self createOrderRequest];
            
            orderRequest.paymentMethod = [HPTCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:self.paymentPageRequest.eci authenticationIndicator:self.paymentPageRequest.authenticationIndicator];
            
            [self performOrderRequest:orderRequest];
            
        } else {
            [self checkTransactionError:error];
        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super dequeuePaymentButtonCell];
    }
    
    HPTInputTableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"holder"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_HOLDER_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_HOLDER_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            break;
            
        case 1:
            cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput" fieldIdentifier:@"number"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_NUMBER_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 2:
            cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput" fieldIdentifier:@"expiry_date"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_EXPIRATION_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_EXPIRATION_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 3:
            cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"security_code"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_SECURITY_CODE_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_SECURITY_CODE_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
    }
    
    return cell;
}

@end
