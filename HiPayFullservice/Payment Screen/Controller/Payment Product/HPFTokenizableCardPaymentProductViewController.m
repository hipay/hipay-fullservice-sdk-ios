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
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentCardTokenDatabase_Private.h"
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

    [self.tableView registerNib:[UINib nibWithNibName:@"HPFScanCardTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"ScanCard"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSecurityCodeTableViewFooterView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"SecurityCode"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFPaymentCardSwitchTableHeaderView" bundle:HPFPaymentScreenViewsBundle()] forHeaderFooterViewReuseIdentifier:@"PaymentCardSwitch"];

    self.switchOn = NO;
    self.touchIDOn = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.isCameraScanDisplayed)
    {
        [CardIOUtilities preloadCardIO];
    }
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

- (void)inferPaymentProductCode
{
    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
    
    BOOL wasPaymentProductDisallowed = paymentProductDisallowed;
    BOOL securityCodeSectionEnabled = [self securityCodeSectionEnabled];
    HPFSecurityCodeType currentSecurityCodeType = [self currentSecurityCodeType];
    BOOL isCardStorageEnabled = [self paymentCardStorageConfigEnabled];

    [self.tableView beginUpdates];

    if ((cardNumberTextField.paymentProductCodes.count == 1) && [[HPFCardNumberFormatter sharedFormatter] plainTextNumber:cardNumberTextField.text isInRangeForPaymentProductCode:cardNumberTextField.paymentProductCodes.anyObject]) {
        
        inferedPaymentProductCode = cardNumberTextField.paymentProductCodes.anyObject;
        
        HPFPaymentProduct *newInferredPaymentProduct = [self.delegate paymentProductViewController:self paymentProductForInferredPaymentProductCode:inferedPaymentProductCode];
        
        BOOL isDomestic = [HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code domesticNetworkOfPaymentProductCode:inferedPaymentProductCode];
        
        if (newInferredPaymentProduct != inferedPaymentProduct) {
            inferedPaymentProduct = newInferredPaymentProduct;

            if (isCardStorageEnabled) {
                UITableViewHeaderFooterView *headerView = [self.tableView headerViewForSection:[self paySection]];
                if (headerView != nil) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]] withRowAnimation:UITableViewRowAnimationFade];
                    self.touchIDOn = NO;
                    self.switchOn = NO;
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]] withRowAnimation:UITableViewRowAnimationFade];
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
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
                else {
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
            
            else {
                if (currentSecurityCodeType != [self currentSecurityCodeType]) {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:[self formSection]]] withRowAnimation:UITableViewRowAnimationNone];
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

- (BOOL)isScanConfigEnabled
{
    return [HPFClientConfig.sharedClientConfig isPaymentCardScanEnabled];
}

- (BOOL) canReadCardWithCamera
{
    return [CardIOUtilities canReadCardWithCamera];
}

- (BOOL) isCameraScanDisplayed {

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    BOOL canReadCard = YES;
    if (self.canReadCardWithCamera == NO) {

        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]
                && authStatus == AVAuthorizationStatusDenied) {

            canReadCard = YES;

        } else {

            canReadCard = NO;
        }
    }
    return self.isScanConfigEnabled && self.isCameraFeatureAllowed && canReadCard;
}

#pragma mark - Table View delegate and data source


- (NSInteger) formSection
{
    return self.isCameraScanDisplayed ? 1 : 0;
}

- (NSInteger) paySection
{
    return self.isCameraScanDisplayed ? 2 : 1;
}

- (NSInteger) scanSection
{
    return self.isCameraScanDisplayed ? 0 : -1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == [self formSection]) {
        
        NSString *description = self.paymentProduct.paymentProductDescription;
        
        if ((inferedPaymentProduct != nil) && ![HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code domesticNetworkOfPaymentProductCode:inferedPaymentProduct.code]) {
            description = inferedPaymentProduct.paymentProductDescription;
        }
        
        return [NSString stringWithFormat:HPFLocalizedString(@"PAY_WITH_THIS_METHOD"), description];
    }

    return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.isCameraScanDisplayed) {
        return 3;

    } else {

        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == [self formSection]) {
        if ([self securityCodeSectionEnabled]) {
            return 4;
        } else {
            return 3;
        }
    }

    // pay section and scan section are 1 line
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
        transactionLoadingRequest = nil;
        
        if (cardToken != nil) {

            if (paymentCardEnabled && [self isSwitchOn]) {
                self.paymentCardToken = cardToken;
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

    if (indexPath.section == [self scanSection])
    {
        return [self dequeueScanCardCell];
    }

    if (indexPath.section == [self paySection])
    {
        return [super dequeuePaymentButtonCell];
    }

    // next is for FORM SECTION

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

- (HPFScanCardTableViewCell *)dequeueScanCardCell
{
    HPFScanCardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScanCard"];
    cell.delegate = self;

    return cell;
}

- (void)scanCardTableViewCellDidTouchButton:(HPFScanCardTableViewCell *)cell {

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    // this method checks if the user has the appropriate permission
    if (!self.canReadCardWithCamera) {

        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]
                && authStatus == AVAuthorizationStatusDenied) {

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"CARD_SCAN")
                                                                message:HPFLocalizedString(@"CARD_SCAN_PERMISSION")
                                                               delegate:self
                                                      cancelButtonTitle:HPFLocalizedString(@"CANCEL")
                                                      otherButtonTitles:HPFLocalizedString(@"SETTINGS"), nil];
            alertView.tag = 1;
            [alertView show];

        } else {
            // should not happen
        }

    } else {

        CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];

        scanViewController.hideCardIOLogo = YES;
        scanViewController.suppressScanConfirmation = YES;
        scanViewController.disableManualEntryButtons = YES;

        [self presentViewController:scanViewController animated:YES completion:nil];
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

//TODO here we put a button (header?) that we can remove
//self.isCameraFeatureAllowed

- (void) switchChanged:(UISwitch *)sender {

    self.switchOn = sender.isOn;

    // if touchID is not enabled, don't ask for it
    if (self.isSwitchOn && self.isTouchIDEnabled) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"CARD_SWITCH_TOUCHID_TITLE")
                                    message:HPFLocalizedString(@"CARD_SWITCH_TOUCHID_DESCRIPTION")
                                   delegate:self
                          cancelButtonTitle:HPFLocalizedString(@"NO")
                          otherButtonTitles:HPFLocalizedString(@"YES"), nil];
        alertView.tag = 0;
        [alertView show];

    } else {

        self.touchIDOn = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (alertView.tag) {

        //TouchID
        case 0: {

            if (buttonIndex == alertView.cancelButtonIndex) {
                self.touchIDOn = NO;

            } else {
                self.touchIDOn = YES;
            }

        } break;

            //card scan
        case 1: {

            if (buttonIndex != alertView.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
            }

        } break;
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

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {

    HPFCardNumberTextField *cardNumberTextField = (HPFCardNumberTextField *) [self textFieldForIdentifier:@"number"];
    cardNumberTextField.text = info.cardNumber;
    [cardNumberTextField textFieldDidChange:nil];
    [self textFieldDidChange:cardNumberTextField];

    if (info.expiryMonth != 0 && info.expiryYear != 0) {
        HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *) [self textFieldForIdentifier:@"expiry_date"];

        NSString *expiryYear = [NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear];

        expiryYear = [NSString stringWithFormat:@"%02lu%@", (unsigned long)info.expiryMonth, [expiryYear substringFromIndex: [expiryYear length] - 2]];
        NSAttributedString *expiryYearAttributed = [[HPFExpiryDateFormatter sharedFormatter] formattedDateWithPlainText:expiryYear];

        expiryDateTextField.attributedText = expiryYearAttributed;

        [self textFieldDidChange:expiryDateTextField];

    }

    if (info.cvv != nil && info.cvv.length > 0) {
        HPFSecurityCodeTextField *securityCodeTextField = (HPFSecurityCodeTextField *) [self textFieldForIdentifier:@"security_code"];
        securityCodeTextField.text = info.cvv;

        [self textFieldDidChange:securityCodeTextField];
    }

    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
