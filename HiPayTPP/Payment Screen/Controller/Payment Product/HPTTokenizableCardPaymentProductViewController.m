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
#import "HPTSecurityCodeTextField.h"
#import "HPTSecurityCodeTableViewFooterView.h"

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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecurityCode"];
        
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    if ((textField == securityCodeTextField) && [HPTPaymentProduct paymentProductWithCodeHasSecurityCode:inferedPaymentProductCode]) {
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

- (HPTSecurityCodeTableViewFooterView *)securityCodeFooter
{
    return (HPTSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:0];
}

- (void)inferPaymentProductCode
{
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];

    BOOL securityCodeSectionEnabled = [self securityCodeSectionEnabled];
    NSString *securityCodePlaceholder = [self securityCodePlaceholder];
    
    if ((cardNumberTextField.paymentProductCodes.count == 1) && [[HPTCardNumberFormatter sharedFormatter] plainTextNumber:cardNumberTextField.text isInRangeForPaymentProductCode:cardNumberTextField.paymentProductCodes.firstObject]) {
        
        inferedPaymentProductCode = cardNumberTextField.paymentProductCodes.firstObject;
        securityCodeTextField.paymentProductCode = inferedPaymentProductCode;
        [self securityCodeFooter].paymentProductCode = inferedPaymentProductCode;
    }
    
    else {
        inferedPaymentProductCode = nil;
    }

    if (securityCodeSectionEnabled != [self securityCodeSectionEnabled]) {
        if ([self securityCodeSectionEnabled]) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        else {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    
    if ([self securityCodeSectionEnabled]) {
        if (![securityCodePlaceholder isEqualToString:[self securityCodePlaceholder]]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
}

- (BOOL)submitButtonEnabled
{
    HPTCardNumberTextField *cardNumberTextField = (HPTCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPTExpiryDateTextField *expiryDateTextField = (HPTExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    HPTSecurityCodeTextField *securityCodeTextField = (HPTSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    return [[self textForIdentifier:@"holder"] isDefined] && cardNumberTextField.completed && expiryDateTextField.completed && securityCodeTextField.completed && cardNumberTextField.valid && expiryDateTextField.valid && securityCodeTextField.valid;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (BOOL)securityCodeSectionEnabled
{
    if (inferedPaymentProductCode != nil) {
        return [HPTPaymentProduct paymentProductWithCodeHasSecurityCode:inferedPaymentProductCode];
    }
    
    // Default behavior for selected payment product
    return [HPTPaymentProduct paymentProductWithCodeHasSecurityCode:self.paymentProduct.code];
}

- (NSString *)securityCodePlaceholderForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_AMEX";
    } else {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_DEFAULT";
    }
}

- (NSString *)securityCodePlaceholder
{
    if (inferedPaymentProductCode != nil) {
        return [self securityCodePlaceholderForPaymentProductCode:inferedPaymentProductCode];
    }

    return [self securityCodePlaceholderForPaymentProductCode:self.paymentProduct.code];
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
            break;
            
        case 1:
            cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput" fieldIdentifier:@"number"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_NUMBER_LABEL");
            
            cell.textField.attributedPlaceholder = [[HPTCardNumberFormatter sharedFormatter] formatPlainTextNumber:HPTLocalizedString(@"CARD_NUMBER_PLACEHOLDER") forPaymentProductCode:HPTPaymentProductCodeVisa];
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 2:
            cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput" fieldIdentifier:@"expiry_date"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_EXPIRATION_LABEL");
            cell.textField.placeholder = HPTLocalizedString(@"CARD_EXPIRATION_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 3:
            cell = [self dequeueInputCellWithIdentifier:@"SecurityCodeInput" fieldIdentifier:@"security_code"];
            cell.inputLabel.text = HPTLocalizedString(@"CARD_SECURITY_CODE_LABEL");
            
            cell.textField.placeholder = HPTLocalizedString([self securityCodePlaceholder]);
            
            ((HPTSecurityCodeTextField *)cell.textField).paymentProductCode = inferedPaymentProductCode;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
    }
    
    return cell;
}

@end
