//
//  HPFTokenizableCardPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import "HPFTokenizableCardPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPFValidation.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"
#import "HPFCardNumberTextField.h"
#import "HPFExpiryDateTextField.h"
#import "HPFSecurityCodeInputTableViewCell.h"
#import "HPFSecurityCodeTableViewFooterView.h"
#import "HPFSecurityCodeTextField.h"
#import "HPFCardNumberInputTableViewCell.h"
#import "HPFPaymentCardSwitchTableHeaderView.h"
#import "FXKeychain.h"
#import "HPFPaymentCardTokenDatabase.h"

@interface HPFTokenizableCardPaymentProductViewController ()

@property (nonatomic) BOOL isSwitchOn;

@end

@implementation HPFTokenizableCardPaymentProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSecurityCodeTableViewFooterView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"SecurityCode"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFPaymentCardSwitchTableHeaderView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"PaymentCardSwitch"];

    self.isSwitchOn = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!defaultFormValuesDefined) {
        UITextField *cardHolderTextField = [self textFieldForIdentifier:@"holder"];
        cardHolderTextField.text = self.paymentPageRequest.customer.displayName;
        defaultFormValuesDefined = YES;
    }
    
    ((HPFSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:0]).separatorInset = self.tableView.separatorInset;
}

- (BOOL)submitButtonEnabled
{
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    
    BOOL validation = [[self textForIdentifier:@"holder"] isDefined] && cardNumberTextField.completed && expiryDateTextField.completed && cardNumberTextField.valid && expiryDateTextField.valid;
    
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    if ([self securityCodeSectionEnabled]) {
        validation = validation && securityCodeTextField.completed && securityCodeTextField.valid;
    }
    
    return validation;
}

#pragma mark - Form edition

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
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
    
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];

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
    
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    [self inferPaymentProductCode];
    
    if (textField == cardNumberTextField) {
        BOOL valid = cardNumberTextField.valid && !paymentProductDisallowed;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self textFieldForIdentifier:@"holder"]) {
        [[self textFieldForIdentifier:@"number"] becomeFirstResponder];
        return YES;
    }
    
    if (textField == [self textFieldForIdentifier:@"number"]) {
        [[self textFieldForIdentifier:@"expiry_date"] becomeFirstResponder];
        return YES;
    }
    
    if (textField == [self textFieldForIdentifier:@"expiry_date"]) {
        [[self textFieldForIdentifier:@"security_code"] becomeFirstResponder];
        return YES;
    }
    
    return [super textFieldShouldReturn:textField];
}

#pragma mark - Security code fields behavior

- (NSString *)currentPaymentProductCode
{
    if (inferedPaymentProductCode != nil) {
        return inferedPaymentProductCode;
    }
    
    return self.paymentProduct.code;
}

- (HPFSecurityCodeTableViewFooterView *)securityCodeFooter
{
    return (HPFSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:0];
}

- (void)updateTitleHeader
{
    [self.tableView headerViewForSection:0].textLabel.text = [[self tableView:self.tableView titleForHeaderInSection:0] uppercaseString];
    [[self.tableView headerViewForSection:0] layoutSubviews];
}

- (void)inferPaymentProductCode
{
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    BOOL wasPaymentProductDisallowed = paymentProductDisallowed;
    BOOL securityCodeSectionEnabled = [self securityCodeSectionEnabled];
    HPFSecurityCodeType currentSecurityCodeType = [self currentSecurityCodeType];
    BOOL isCardStorageEnabled = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];

    [self.tableView beginUpdates];

    if ((cardNumberTextField.paymentProductCodes.count == 1) && [[HPFCardNumberFormatter sharedFormatter] plainTextNumber:cardNumberTextField.text isInRangeForPaymentProductCode:cardNumberTextField.paymentProductCodes.anyObject]) {
        
        inferedPaymentProductCode = cardNumberTextField.paymentProductCodes.anyObject;
        
        HPFPaymentProduct *newInferredPaymentProduct = [self.delegate paymentProductViewController:self paymentProductForInferredPaymentProductCode:inferedPaymentProductCode];
        
        BOOL isDomestic = [HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code domesticNetworkOfPaymentProductCode:inferedPaymentProductCode];
        
        if (newInferredPaymentProduct != inferedPaymentProduct) {
            inferedPaymentProduct = newInferredPaymentProduct;

            if (isCardStorageEnabled) {
                UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:1];
                if (headerView != nil) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                }
            }

            if (!isDomestic) {
                [self updateTitleHeader];
                [self.delegate paymentProductViewController:self changeSelectedPaymentProduct:inferedPaymentProduct];
            }
        }
        
        if ((inferedPaymentProduct == nil) && !isDomestic) {
            paymentProductDisallowed = YES;
        } else {
            paymentProductDisallowed = NO;
        }
    }
    
    else if (inferedPaymentProductCode != nil) {
        inferedPaymentProductCode = nil;
        inferedPaymentProduct = nil;
        paymentProductDisallowed = NO;
        [self updateTitleHeader];
        [self.delegate paymentProductViewController:self changeSelectedPaymentProduct:self.paymentProduct];

        if (isCardStorageEnabled) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    if (!paymentProductDisallowed) {
        if ([self securityCodeSectionEnabled]) {
            NSString *paymentProductCode = [self currentPaymentProductCode];
            ((HPFSecurityCodeInputTableViewCell *)[self cellWithTextField:securityCodeTextField]).paymentProductCode = paymentProductCode;
            [self securityCodeFooter].paymentProductCode = paymentProductCode;
        }
        
        if (!wasPaymentProductDisallowed) {
            if (securityCodeSectionEnabled != [self securityCodeSectionEnabled]) {
                if ([self securityCodeSectionEnabled]) {
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
                else {
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
            
            else {
                if (currentSecurityCodeType != [self currentSecurityCodeType]) {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }

    [self.tableView endUpdates];
}

- (HPFSecurityCodeType)currentSecurityCodeType
{
    if (inferedPaymentProductCode != nil) {
        return [HPFPaymentProduct securityCodeTypeForPaymentProductCode:inferedPaymentProductCode];
    }
    
    // Default behavior for selected payment product
    return [HPFPaymentProduct securityCodeTypeForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)paymentCardStorageEnabled
{
    if (inferedPaymentProductCode != nil) {
        return [HPFPaymentProduct isPaymentCardStorageEnabledForPaymentProductCode:inferedPaymentProductCode];
    }

    return [HPFPaymentProduct isPaymentCardStorageEnabledForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)securityCodeSectionEnabled
{
    return [self currentSecurityCodeType] != HPFSecurityCodeTypeNone;
}

- (NSString *)securityCodePlaceholderForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_CID";
    } else {
        return @"CARD_SECURITY_CODE_PLACEHOLDER_CVV";
    }
}

#pragma mark - Table View delegate and data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        NSString *description = self.paymentProduct.paymentProductDescription;
        
        if ((inferedPaymentProduct != nil) && ![HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code domesticNetworkOfPaymentProductCode:inferedPaymentProduct.code]) {
            description = inferedPaymentProduct.paymentProductDescription;
        }
        
        return [NSString stringWithFormat:HPFLocalizedString(@"PAY_WITH_THIS_METHOD"), description];
    }
    
    return [super tableView:tableView titleForHeaderInSection:section];
}

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

- (void)submit
{
    [self setPaymentButtonLoadingMode:YES];
    
    NSString *securityCode = nil;
    
    if ([self securityCodeSectionEnabled]) {
        securityCode = [self textForIdentifier:@"security_code"];
    }
    
    HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];
    
    NSString *year = [NSString stringWithFormat: @"%ld", (long)expiryDateTextField.dateComponents.year];
    NSString *month = [NSString stringWithFormat: @"%02ld", (long)expiryDateTextField.dateComponents.month];

    BOOL paymentCardEnabled = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];
    if (paymentCardEnabled && [self isSwitchOn]) {
        self.paymentPageRequest.multiUse = YES;
    }

    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithCardNumber:[self textForIdentifier:@"number"] cardExpiryMonth:month cardExpiryYear:year cardHolder:[self textForIdentifier:@"holder"] securityCode:securityCode multiUse:self.paymentPageRequest.multiUse andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {
       
        [self setPaymentButtonLoadingMode:NO];
        transactionLoadingRequest = nil;
        
        if (cardToken != nil) {

            if (paymentCardEnabled && [self isSwitchOn]) {
                [HPFPaymentCardTokenDatabase save:cardToken forCurrency:self.paymentPageRequest.currency];
            }

            HPFOrderRequest *orderRequest = [self createOrderRequest];
            
            orderRequest.paymentProductCode = inferedPaymentProductCode;
            
            orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:self.paymentPageRequest.eci authenticationIndicator:self.paymentPageRequest.authenticationIndicator];
            
            [self performOrderRequest:orderRequest signature:self.signature];
            
        } else {
            [self checkTransactionError:error];
        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {

        return [super dequeuePaymentButtonCell];
    }
    
    HPFInputTableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"holder"];
            cell.inputLabel.text = HPFLocalizedString(@"CARD_HOLDER_LABEL");
            cell.textField.placeholder = HPFLocalizedString(@"CARD_HOLDER_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput" fieldIdentifier:@"number"];
            ((HPFCardNumberInputTableViewCell *)cell).defaultPaymentProductCode = [self currentPaymentProductCode];
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 2:
            cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput" fieldIdentifier:@"expiry_date"];
            cell.inputLabel.text = HPFLocalizedString(@"CARD_EXPIRATION_LABEL");
            cell.textField.placeholder = HPFLocalizedString(@"CARD_EXPIRATION_PLACEHOLDER");
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 3:
            cell = [self dequeueInputCellWithIdentifier:@"SecurityCodeInput" fieldIdentifier:@"security_code"];
            ((HPFSecurityCodeInputTableViewCell *)cell).paymentProductCode = [self currentPaymentProductCode];
            cell.textField.returnKeyType = UIReturnKeyDone;
            
            break;
            
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        HPFSecurityCodeTableViewFooterView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecurityCode"];
        footer.paymentProductCode = [self currentPaymentProductCode];
        footer.hidden = YES;
        
        return footer;
    }

    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    BOOL paymentCardEnabled = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];
    if (section == 1 && paymentCardEnabled) {

        if ([self paymentCardStorageEnabled]) {

            HPFPaymentCardSwitchTableHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PaymentCardSwitch"];
            [[header saveSwitch] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            return header;
        }

        self.isSwitchOn = NO;
    }

    return nil;
}

- (void) switchChanged:(UISwitch *)sender {

    self.isSwitchOn = sender.isOn;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return footerHeight;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    switch (section) {

        case 0: {
            return 56.f;
        }

        case 1: {

            BOOL paymentCardEnabled = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];

            if ([self paymentCardStorageEnabled] && paymentCardEnabled) {
                return 56.f;
            }
        }

        default: {
            return 0.f;
        }
    }
}
@end
