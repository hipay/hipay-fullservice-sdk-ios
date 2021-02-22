//
//  HPFTokenizableCardPaymentProductViewController.m
//  Pods
//
//  Created by HiPay on 02/11/2015.
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
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFExpiryDateFormatter.h"
#import <LocalAuthentication/LAContext.h>
#import <AVFoundation/AVFoundation.h>

@interface HPFTokenizableCardPaymentProductViewController ()

@property (nonatomic, getter=isSwitchOn) BOOL switchOn;
@property (nonatomic, getter=isTouchIDOn) BOOL touchIDOn;
@property (nonatomic, strong) HPFPaymentCardToken *paymentCardToken;

@end

@implementation HPFTokenizableCardPaymentProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSecurityCodeTableViewFooterView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"SecurityCode"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFPaymentCardSwitchTableHeaderView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"PaymentCardSwitch"];

    self.switchOn = NO;
    self.touchIDOn = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!defaultFormValuesDefined) {
        UITextField *cardHolderTextField = [self textFieldForIdentifier:@"holder"];
        cardHolderTextField.text = self.paymentPageRequest.customer.displayName;
        defaultFormValuesDefined = YES;
    }
    
    ((HPFSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:[self formSection]]).separatorInset = self.tableView.separatorInset;
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
    
    if (validation) {
        [self.view endEditing:YES];
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
    else if (textField == [self textFieldForIdentifier:@"number"]) {
        [[self textFieldForIdentifier:@"expiry_date"] becomeFirstResponder];
        return YES;
    }
    else if (textField == [self textFieldForIdentifier:@"expiry_date"]) {
        [[self textFieldForIdentifier:@"security_code"] becomeFirstResponder];
        return YES;
    }
    
    return [super textFieldShouldReturn:textField];
}

#pragma mark - Security code fields behavior

- (void)updateTitleHeader
{
    [self.tableView headerViewForSection:[self formSection]].textLabel.text = [[self tableView:self.tableView titleForHeaderInSection:[self formSection]] uppercaseString];
    [[self.tableView headerViewForSection:[self formSection]] layoutSubviews];
}

- (NSString *)currentPaymentProductCode
{
    if (inferedPaymentProductCode != nil) {
        return inferedPaymentProductCode;
    }

    return self.paymentProduct.code;
}

- (HPFSecurityCodeTableViewFooterView *)securityCodeFooter
{
    return (HPFSecurityCodeTableViewFooterView *) [self.tableView footerViewForSection:[self formSection]];
}

- (HPFPaymentProduct *) getPaymentProductFromInferedCode:(NSString *)inferedCode
{
    return [self.delegate paymentProductViewController:self paymentProductForInferredPaymentProductCode:inferedCode];
}

- (void)inferPaymentProductCode
{
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    BOOL wasPaymentProductDisallowed = paymentProductDisallowed;
    BOOL securityCodeSectionEnabled = [self securityCodeSectionEnabled];
    HPFSecurityCodeType currentSecurityCodeType = [self currentSecurityCodeType];
    BOOL isCardStorageEnabled = [self paymentCardStorageConfigEnabled];


    if ((cardNumberTextField.paymentProductCodes.count == 1) && [[HPFCardNumberFormatter sharedFormatter] plainTextNumber:cardNumberTextField.text isInRangeForPaymentProductCode:cardNumberTextField.paymentProductCodes.anyObject]) {

        inferedPaymentProductCode = cardNumberTextField.paymentProductCodes.anyObject;

        HPFPaymentProduct *newInferredPaymentProduct = [self getPaymentProductFromInferedCode:inferedPaymentProductCode];

        if (newInferredPaymentProduct != inferedPaymentProduct) {
            inferedPaymentProduct = newInferredPaymentProduct;

            if (isCardStorageEnabled) {
                UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:[self paySection]];
                if (headerView != nil) {
                    self.touchIDOn = NO;
                    self.switchOn = NO;
                }
            }

            [self updateTitleHeader];
            [self.delegate paymentProductViewController:self changeSelectedPaymentProduct:inferedPaymentProduct];
        }
        
        if (inferedPaymentProduct == nil) {
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
            self.touchIDOn = NO;
            self.switchOn = NO;
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
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
                
                else {
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            }
            
            else {
                if (currentSecurityCodeType != [self currentSecurityCodeType]) {
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            }
        }
    }

}

- (HPFSecurityCodeType)currentSecurityCodeType
{
    if (inferedPaymentProductCode != nil) {
        return [HPFPaymentProduct securityCodeTypeForPaymentProductCode:inferedPaymentProductCode];
    }
    
    // Default behavior for selected payment product
    return [HPFPaymentProduct securityCodeTypeForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)isTouchIDEnabled
{
    return [HPFClientConfig.sharedClientConfig isTouchIDEnabled] && [self canEvaluatePolicy];
}

- (BOOL)canEvaluatePolicy {

    LAContext *context = [[LAContext alloc] init];
    NSError *error;

    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    return [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

- (BOOL)paymentCardStorageEnabled
{
    if (inferedPaymentProductCode != nil) {
        return [HPFPaymentProduct isPaymentCardStorageEnabledForPaymentProductCode:inferedPaymentProductCode];
    }

    return [HPFPaymentProduct isPaymentCardStorageEnabledForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)paymentCardStorageConfigEnabled
{
    BOOL paymentCardEnabled = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];
    BOOL paymentPageRequestECI = self.paymentPageRequest.eci == HPFECISecureECommerce ? YES : NO;

    return paymentCardEnabled && paymentPageRequestECI;
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

- (BOOL)isCameraFeatureAllowed
{
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSCameraUsageDescription"] != nil)
    {
        return YES;
    }

    return NO;
}

#pragma mark - Table View delegate and data source


- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == [self formSection]) {
        
        NSString *description = self.paymentProduct.paymentProductDescription;
        
        if ((inferedPaymentProduct != nil) && ![HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code domesticNetworkOfPaymentProductCode:inferedPaymentProduct.code]) {
            description = inferedPaymentProduct.paymentProductDescription;
        }
        
        return [NSString stringWithFormat:HPFLocalizedString(@"HPF_PAY_WITH_THIS_METHOD"), description];
    }

    return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == [self formSection]) {
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

    BOOL paymentCardEnabled = [self paymentCardStorageConfigEnabled];
    if (paymentCardEnabled && [self isSwitchOn]) {
        self.paymentPageRequest.multiUse = YES;
    }

    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithCardNumber:[self textForIdentifier:@"number"] cardExpiryMonth:month cardExpiryYear:year cardHolder:[self textForIdentifier:@"holder"] securityCode:securityCode multiUse:self.paymentPageRequest.multiUse andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {

        [self setPaymentButtonLoadingMode:NO];
        self->transactionLoadingRequest = nil;
        
        if (cardToken != nil) {

            if (paymentCardEnabled && [self isSwitchOn]) {
                self.paymentCardToken = cardToken;
            }

            HPFOrderRequest *orderRequest = [self createOrderRequest];
            
            NSString *paymentProductCode = (cardToken.domesticNetwork) ? cardToken.domesticNetwork : cardToken.brand;
            paymentProductCode = [paymentProductCode stringByReplacingOccurrencesOfString:@" " withString:@"-"];
            orderRequest.paymentProductCode = paymentProductCode;
            orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:self.paymentPageRequest.eci authenticationIndicator:self.paymentPageRequest.authenticationIndicator];
            
            [self performOrderRequest:orderRequest signature:self.signature];
            
        } else {
            [self checkTransactionError:error];
        }
        
    }];
}

- (void) savePaymentMethod:(HPFPaymentMethod *)paymentMethod {

    if ([paymentMethod isMemberOfClass:[HPFPaymentCardToken class]]) {
        HPFPaymentCardToken *cardToken = (HPFPaymentCardToken *)paymentMethod;

        if (self.paymentCardToken != nil) {

            if ([cardToken isEqualToPaymentCardToken:[self paymentCardToken]]) {

                if ([self paymentCardStorageConfigEnabled] && [self isSwitchOn]) {

                    [HPFPaymentCardTokenDatabase save:[self paymentCardToken] forCurrency:self.paymentPageRequest.currency withTouchID:[self isTouchIDOn]];
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == [self paySection])
    {
        return [super dequeuePaymentButtonCell];
    }

    // next is for FORM SECTION

    HPFInputTableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"holder"];
            cell.inputLabel.text = HPFLocalizedString(@"HPF_CARD_HOLDER_LABEL");
            cell.textField.placeholder = HPFLocalizedString(@"HPF_CARD_HOLDER_PLACEHOLDER");
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.textContentType = UITextContentTypeName;
            break;
            
        case 1:
            cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput" fieldIdentifier:@"number"];
            ((HPFCardNumberInputTableViewCell *)cell).defaultPaymentProductCode = [self currentPaymentProductCode];
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.textContentType = UITextContentTypeCreditCardNumber;
            break;
            
        case 2:
            cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput" fieldIdentifier:@"expiry_date"];
            cell.inputLabel.text = HPFLocalizedString(@"HPF_CARD_EXPIRATION_LABEL");
            cell.textField.placeholder = HPFLocalizedString(@"HPF_CARD_EXPIRATION_PLACEHOLDER");
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 3:
            cell = [self dequeueInputCellWithIdentifier:@"SecurityCodeInput" fieldIdentifier:@"security_code"];
            ((HPFSecurityCodeInputTableViewCell *)cell).paymentProductCode = [self currentPaymentProductCode];
            cell.textField.returnKeyType = UIReturnKeyDone;
            
            break;
            
    }
    
    if (cell) {
        return cell;
    }
    else {
        NSLog(@"Unexpected tableView error");
        abort();
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == [self formSection]) {
        
        HPFSecurityCodeTableViewFooterView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecurityCode"];
        footer.paymentProductCode = [self currentPaymentProductCode];
        footer.hidden = YES;
        
        return footer;
    }

    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    BOOL paymentCardEnabled = [self paymentCardStorageConfigEnabled];
    if (section == [self paySection] && paymentCardEnabled) {

        if ([self paymentCardStorageEnabled]) {

            HPFPaymentCardSwitchTableHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PaymentCardSwitch"];
            [[header saveSwitch] addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            return header;
        }
    }

    return nil;
}

- (void) switchChanged:(UISwitch *)sender {

    self.switchOn = sender.isOn;

    // if touchID is not enabled, don't ask for it
    if (self.isSwitchOn && self.isTouchIDEnabled) {

        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"HPF_CARD_SWITCH_TOUCHID_TITLE")
                                                                                     message:HPFLocalizedString(@"HPF_CARD_SWITCH_TOUCHID_DESCRIPTION")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:HPFLocalizedString(@"HPF_NO")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action) {
                                           
                                           self.touchIDOn = NO;
                                           
                                       }];
        
        UIAlertAction* settingsButton = [UIAlertAction
                                         actionWithTitle:HPFLocalizedString(@"HPF_YES")
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             
                                             self.touchIDOn = YES;
                                         }];
        
        [alertViewController addAction:cancelButton];
        [alertViewController addAction:settingsButton];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
        

    } else {

        self.touchIDOn = NO;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self formSection]) {
        return footerHeight;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == self.formSection) {

        return 32.f;

    } else if (section == self.paySection) {

        BOOL paymentCardEnabled = [self paymentCardStorageConfigEnabled];

        if ([self paymentCardStorageEnabled] && paymentCardEnabled) {
            return 48.f;
        }

    } else {

        return 7.0f;
    }

    return 0.f;
}

@end
