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
#import "HPTSecureVaultClient.h"
#import "HPTCardTokenPaymentMethodRequest.h"
#import "HPTCardNumberTextField.h"
#import "HPTExpiryDateTextField.h"
#import "HPTSecurityCodeInputTableViewCell.h"
#import "HPTSecurityCodeTableViewFooterView.h"
#import "HPTSecurityCodeTextField.h"
#import "HPTCardNumberInputTableViewCell.h"

@interface HPTTokenizableCardPaymentProductViewController ()

@end

@implementation HPTTokenizableCardPaymentProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTSecurityCodeTableViewFooterView" bundle:HPTPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"SecurityCode"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    dispatch_once(&cardHolderPredefinedBlock, ^{
        UITextField *cardHolderTextField = [self textFieldForIdentifier:@"holder"];
        cardHolderTextField.text = self.paymentPageRequest.customer.displayName;
    });
    
    ((HPTSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:0]).separatorInset = self.tableView.separatorInset;
}

- (BOOL)submitButtonEnabled
{
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTExpiryDateTextField *expiryDateTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    
    BOOL validation = [[self textForIdentifier:@"holder"] isDefined] && cardNumberTextField.completed && expiryDateTextField.completed && cardNumberTextField.valid && expiryDateTextField.valid;
    
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    if ([self securityCodeSectionEnabled]) {
        validation = validation && securityCodeTextField.completed && securityCodeTextField.valid;
    }
    
    return validation;
}

#pragma mark - Form edition

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    if (textField == securityCodeTextField) {
        [self.tableView beginUpdates];
        footerHeight = 56.0;
        [self.tableView endUpdates];
        
        [self securityCodeFooter].hidden = NO;
        [self securityCodeFooter].alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            [self securityCodeFooter].alpha = 1.0;
        }];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTExpiryDateTextField *expiryDateTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];

    if (textField == securityCodeTextField) {
        [self.tableView beginUpdates];
        footerHeight = 0.0;
        [self.tableView endUpdates];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self securityCodeFooter].alpha = 0.0;
        } completion:^(BOOL finished) {
            [self securityCodeFooter].hidden = YES;
        }];
        
        if ([securityCodeTextField.text isDefined] && !securityCodeTextField.completed) {
            [self cellWithTextField:securityCodeTextField].incorrectInput = YES;
        }
    }
    
    else if (textField == cardNumberTextField) {
        if ([cardNumberTextField.text isDefined] && !cardNumberTextField.completed) {
            [self cellWithTextField:cardNumberTextField].incorrectInput = YES;
        }
    }
    
    else if (textField == expiryDateTextField) {
        if ([expiryDateTextField.text isDefined] && !expiryDateTextField.completed) {
            [self cellWithTextField:expiryDateTextField].incorrectInput = YES;
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [super textFieldDidChange:textField];
    
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTExpiryDateTextField *expiryDateTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    [self inferPaymentProductCode];
    
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
    
    else if (textField == expiryDateTextField) {
        BOOL valid = expiryDateTextField.valid;
        [self cellWithTextField:expiryDateTextField].incorrectInput = !valid;
        
        if (valid && (expiryDateTextField.isCompleted)) {
            [securityCodeTextField becomeFirstResponder];
        }
    }
    
    else if (textField == securityCodeTextField) {
        BOOL valid = securityCodeTextField.valid;
        [self cellWithTextField:securityCodeTextField].incorrectInput = !valid;
    }
}

#pragma mark - Security code fields behavior

- (NSString *)currentPaymentProductCode
{
    if (inferedPaymentProductCode != nil) {
        return inferedPaymentProductCode;
    }
    
    return self.paymentProduct.code;
}

- (HPTSecurityCodeTableViewFooterView *)securityCodeFooter
{
    return (HPTSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:0];
}

- (void)inferPaymentProductCode
{
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    BOOL securityCodeSectionEnabled = [self securityCodeSectionEnabled];
    HPTSecurityCodeType currentSecurityCodeType = [self currentSecurityCodeType];

    if ((cardNumberTextField.paymentProductCodes.count == 1) && [[HPTCardNumberFormatter sharedFormatter] plainTextNumber:cardNumberTextField.text isInRangeForPaymentProductCode:cardNumberTextField.paymentProductCodes.firstObject]) {
        
        inferedPaymentProductCode = cardNumberTextField.paymentProductCodes.firstObject;
        
    }
    else {
        inferedPaymentProductCode = nil;
    }
    
    NSString *paymentProductCode = [self currentPaymentProductCode];
    
    ((HPTSecurityCodeInputTableViewCell *)[self cellWithTextField:securityCodeTextField]).paymentProductCode = paymentProductCode;
    
    securityCodeTextField.paymentProductCode = paymentProductCode;
    [self securityCodeFooter].paymentProductCode = paymentProductCode;

    
    if (securityCodeSectionEnabled != [self securityCodeSectionEnabled]) {
        if ([self securityCodeSectionEnabled]) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        else {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    
    if ([self securityCodeSectionEnabled]) {
        if (currentSecurityCodeType != [self currentSecurityCodeType]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}

- (HPTSecurityCodeType)currentSecurityCodeType
{
    if (inferedPaymentProductCode != nil) {
        return [HPTPaymentProduct securityCodeTypeForPaymentProductCode:inferedPaymentProductCode];
    }
    
    // Default behavior for selected payment product
    return [HPTPaymentProduct securityCodeTypeForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)securityCodeSectionEnabled
{
    return [self currentSecurityCodeType] != HPTSecurityCodeTypeNone;
}

- (NSString *)securityCodePlaceholderForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_CID";
    } else {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_CVV";
    }
}

#pragma mark - Table View delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([self securityCodeSectionEnabled]) {
            return 4;
        } else {
            return 3;
        }
    }
    
    return 1;
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPTPaymentButtonTableViewCell *)cell
{
    [self setPaymentButtonLoadingMode:YES];
    
    NSString *securityCode = nil;
    
    if ([self securityCodeSectionEnabled]) {
        securityCode = [self textForIdentifier:@"security_code"];
    }
    
    [[HPTSecureVaultClient sharedClient] generateTokenWithCardNumber:[self textForIdentifier:@"number"] cardExpiryMonth:@"12" cardExpiryYear:@"2019" cardHolder:[self textForIdentifier:@"holder"] securityCode:securityCode multiUse:self.paymentPageRequest.multiUse andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
       
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
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput" fieldIdentifier:@"number"];
            ((HPTCardNumberInputTableViewCell *)cell).defaultPaymentProductCode = [self currentPaymentProductCode];
            break;
            
        case 2:
            cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput" fieldIdentifier:@"expiry_date"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_EXPIRATION_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_EXPIRATION_PLACEHOLDER");
            break;
            
        case 3:
            cell = [self dequeueInputCellWithIdentifier:@"SecurityCodeInput" fieldIdentifier:@"security_code"];
            ((HPTSecurityCodeInputTableViewCell *)cell).paymentProductCode = [self currentPaymentProductCode];
            
            break;
            
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        HPTSecurityCodeTableViewFooterView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecurityCode"];
        footer.paymentProductCode = [self currentPaymentProductCode];
        footer.hidden = YES;
        
        return footer;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return footerHeight;
    }
    
    return 0.0;
}

@end
