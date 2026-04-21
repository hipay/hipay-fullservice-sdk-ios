//
//  HPFTokenizableCardPaymentProductViewController.m
//  Pods
//
//  Created by HiPay on 02/11/2015.
//
//

#import "HPFTokenizableCardPaymentProductViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFCardNumberInputTableViewCell.h"
#import "HPFCardNumberTextField.h"
#import "HPFExpiryDateFormatter.h"
#import "HPFExpiryDateTextField.h"
#import "HPFOrderRequest.h"
#import "HPFPaymentCardSwitchTableHeaderView.h"
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"
#import "HPFSecurityCodeFormatter.h"
#import "HPFSecurityCodeInputTableViewCell.h"
#import "HPFSecurityCodeTableViewFooterView.h"
#import "HPFSecurityCodeTextField.h"
#import "NSString+HPFValidation.h"
#import <AVFoundation/AVFoundation.h>

#if __has_include(<HiPayFullservice/HiPayFullservice-Swift.h>)
#import <HiPayFullservice/HiPayFullservice-Swift.h>
#else
#import "HiPayFullservice-Swift.h"
#endif
#import <LocalAuthentication/LAContext.h>

static const NSInteger HPFMinDigitsForCoBranding = 2;

@interface HPFTokenizableCardPaymentProductViewController () <
    HPFCardNetworkSelectionHandling>

@property(nonatomic, getter=isSwitchOn) BOOL switchOn;
@property(nonatomic, getter=isTouchIDOn) BOOL touchIDOn;
@property(nonatomic, strong) HPFPaymentCardToken *paymentCardToken;
@property(nonatomic, strong) NSString *userSelectedNetworkCode;
@property(nonatomic, strong) NSString *lastLookupBin;
@property(nonatomic, strong) CardInfoResponse *lastBinResponse;

@end

@implementation HPFTokenizableCardPaymentProductViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.tableView registerNib:
                      [UINib
                          nibWithNibName:@"HPFSecurityCodeTableViewFooterView"
                                  bundle:HPFPaymentScreenViewsBundle()]
      forHeaderFooterViewReuseIdentifier:@"SecurityCode"];
  [self.tableView registerNib:
                      [UINib
                          nibWithNibName:@"HPFPaymentCardSwitchTableHeaderView"
                                  bundle:HPFPaymentScreenViewsBundle()]
      forHeaderFooterViewReuseIdentifier:@"PaymentCardSwitch"];

  self.switchOn = NO;
  self.touchIDOn = NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.isMovingToParentViewController) {
    HPFCardNumberTextField *cardNumberTextField =
        (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];
    if (cardNumberTextField && (![cardNumberTextField.text isDefined] ||
                                cardNumberTextField.text.length == 0)) {
      self.userSelectedNetworkCode = nil;
      inferedPaymentProductCode = nil;

      [HPFCardNetworkUIInjector.shared updateWithDetectedCodes:[NSSet set]
                                                    cardNumber:@""
                                                  selectedCode:nil];

      [self updateTitleHeader];

      [self.tableView reloadData];
    }
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  if (!defaultFormValuesDefined) {
    UITextField *cardHolderTextField = [self textFieldForIdentifier:@"holder"];
    cardHolderTextField.text = self.paymentPageRequest.customer.displayName;
    defaultFormValuesDefined = YES;
  }

  HPFSecurityCodeTableViewFooterView *footer =
      (HPFSecurityCodeTableViewFooterView *)[self.tableView
          footerViewForSection:[self formSection]];
  if (footer) {
    footer.separatorInset = self.tableView.separatorInset;
  }
}

- (BOOL)submitButtonEnabled {
  HPFCardNumberTextField *cardNumberTextField =
      (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];
  HPFExpiryDateTextField *expiryDateTextField =
      (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];

  BOOL validation = [[self textForIdentifier:@"holder"] isDefined] &&
                    cardNumberTextField.completed &&
                    expiryDateTextField.completed &&
                    cardNumberTextField.valid && expiryDateTextField.valid;

  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];

  if ([self securityCodeSectionEnabled]) {
    validation = validation && securityCodeTextField.completed &&
                 securityCodeTextField.valid;
  }

  if (validation) {
    [self.view endEditing:YES];
  }

  return validation;
}

#pragma mark - Form edition

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [super textFieldDidBeginEditing:textField];

  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];

  if (textField == securityCodeTextField) {

    if (footerHeight == 56.0) {
      return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      if (![securityCodeTextField isFirstResponder]) {
        return;
      }

      self->footerHeight = 56.0;

      HPFSecurityCodeTableViewFooterView *footer = [self securityCodeFooter];
      footer.hidden = NO;
      footer.alpha = 0.0;

      [self updateSecurityCodeFooterText];

      [UIView animateWithDuration:0.2
                       animations:^{
                         [self.tableView layoutIfNeeded];
                         footer.alpha = 1.0;
                       }];
    });
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [super textFieldDidEndEditing:textField];

  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];
  HPFCardNumberTextField *cardNumberTextField =
      (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];
  HPFExpiryDateTextField *expiryDateTextField =
      (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];

  if (textField == securityCodeTextField) {
    if ([securityCodeTextField isFirstResponder]) {
      return;
    }

    if (footerHeight == 0.0) {
      return;
    }

    footerHeight = 0.0;

    [UIView animateWithDuration:0.2
        animations:^{
          [self.tableView layoutIfNeeded];
          [self securityCodeFooter].alpha = 0.0;
        }
        completion:^(BOOL finished) {
          [self securityCodeFooter].hidden = YES;
        }];

    if ([securityCodeTextField.text isDefined] &&
        !securityCodeTextField.completed) {
      [self cellWithTextField:securityCodeTextField].incorrectInput = YES;
    }
  }

  else if (textField == cardNumberTextField) {
    if ([cardNumberTextField.text isDefined] &&
        !cardNumberTextField.completed) {
      [self cellWithTextField:cardNumberTextField].incorrectInput = YES;
    }
  }

  else if (textField == expiryDateTextField) {
    if ([expiryDateTextField.text isDefined] &&
        !expiryDateTextField.completed) {
      [self cellWithTextField:expiryDateTextField].incorrectInput = YES;
    }
  }
}

- (void)textFieldDidChange:(UITextField *)textField {

  HPFCardNumberTextField *cardNumberTextField =
      (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];
  HPFExpiryDateTextField *expiryDateTextField =
      (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];
  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];

  if (textField == cardNumberTextField) {
    if (cardNumberTextField.valid) {
      [self cellWithTextField:cardNumberTextField].incorrectInput = NO;
    }
    [self inferPaymentProductCode];

    NSString *currentNumber =
        [cardNumberTextField.text stringByReplacingOccurrencesOfString:@" "
                                                            withString:@""];

    if (currentNumber.length >= HPFMinDigitsForCoBranding) {
      NSSet *codes = cardNumberTextField.paymentProductCodes;
      NSString *selected = self.userSelectedNetworkCode;
      [HPFCardNetworkUIInjector.shared updateWithDetectedCodes:codes
                                                    cardNumber:currentNumber
                                                  selectedCode:selected];
    } else {
      [HPFCardNetworkUIInjector.shared updateWithDetectedCodes:[NSSet set]
                                                    cardNumber:@""
                                                  selectedCode:nil];
    }
  }

  else if (textField == securityCodeTextField) {

    if (securityCodeTextField.paymentProductCode == nil) {
      securityCodeTextField.paymentProductCode =
          [self currentPaymentProductCode];
    }

    NSString *code = securityCodeTextField.paymentProductCode;
    if (!code)
      code = [self currentPaymentProductCode];
    HPFSecurityCodeType type =
        [HPFPaymentProduct securityCodeTypeForPaymentProductCode:code];

    NSInteger maxLength = (type == HPFSecurityCodeTypeCID) ? 4 : 3;
    NSString *digits = [[textField.text
        componentsSeparatedByCharactersInSet:[[NSCharacterSet
                                                 decimalDigitCharacterSet]
                                                 invertedSet]]
        componentsJoinedByString:@""];

    if (digits.length > maxLength) {
      textField.text = [digits substringToIndex:maxLength];
    }

    BOOL valid = securityCodeTextField.valid;
    HPFInputTableViewCell *cell =
        [self cellWithTextField:securityCodeTextField];
    if (cell.incorrectInput != !valid) {
      cell.incorrectInput = !valid;
    }
  }

  [super textFieldDidChange:textField];

  if (textField == expiryDateTextField) {
    BOOL valid = expiryDateTextField.valid;
    [self cellWithTextField:expiryDateTextField].incorrectInput = !valid;

    if (valid && (expiryDateTextField.isCompleted) && [self securityCodeSectionEnabled]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [securityCodeTextField becomeFirstResponder];
      });
    }
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];

  if (textField == securityCodeTextField) {

    NSString *newText =
        [textField.text stringByReplacingCharactersInRange:range
                                                withString:string];
    NSString *digits = [[newText
        componentsSeparatedByCharactersInSet:[[NSCharacterSet
                                                 decimalDigitCharacterSet]
                                                 invertedSet]]
        componentsJoinedByString:@""];

    NSString *code = securityCodeTextField.paymentProductCode;
    if (!code) {
      code = [self currentPaymentProductCode];
    }

    HPFSecurityCodeType type =
        [HPFPaymentProduct securityCodeTypeForPaymentProductCode:code];

    if (type == HPFSecurityCodeTypeCID) { // Amex
      return digits.length <= 4;
    } else {
      // Default to 3 for Visa/MC/CB etc.
      return digits.length <= 3;
    }
  }
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == [self textFieldForIdentifier:@"holder"]) {
    [[self textFieldForIdentifier:@"number"] becomeFirstResponder];
    return YES;
  } else if (textField == [self textFieldForIdentifier:@"number"]) {
    [[self textFieldForIdentifier:@"expiry_date"] becomeFirstResponder];
    return YES;
  } else if (textField == [self textFieldForIdentifier:@"expiry_date"]) {
    [[self textFieldForIdentifier:@"security_code"] becomeFirstResponder];
    return YES;
  }

  return [super textFieldShouldReturn:textField];
}

#pragma mark - Logic

- (void)updateTitleHeader {
  [self.tableView headerViewForSection:[self formSection]].textLabel.text =
      [[self tableView:self.tableView
          titleForHeaderInSection:[self formSection]] uppercaseString];
  [[self.tableView headerViewForSection:[self formSection]] layoutSubviews];
}

- (NSString *)currentPaymentProductCode {
  if (self.userSelectedNetworkCode != nil) {
    return self.userSelectedNetworkCode;
  }

  if (inferedPaymentProductCode != nil) {
    return inferedPaymentProductCode;
  }

  return self.paymentProduct.code;
}

- (HPFSecurityCodeTableViewFooterView *)securityCodeFooter {
  return (HPFSecurityCodeTableViewFooterView *)[self.tableView
      footerViewForSection:[self formSection]];
}

- (void)updateSecurityCodeFooterText {
  NSString *code = [self currentPaymentProductCode];
  HPFSecurityCodeTableViewFooterView *footer = [self securityCodeFooter];

  if (footer) {
    footer.paymentProductCode = code;
  }
}

- (HPFPaymentProduct *)getPaymentProductFromInferedCode:
    (NSString *)inferedCode {
  return [self.delegate paymentProductViewController:self
         paymentProductForInferredPaymentProductCode:inferedCode];
}

- (void)inferPaymentProductCode {
  HPFCardNumberTextField *cardNumberTextField =
      (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];
  HPFSecurityCodeTextField *securityCodeTextField =
      (HPFSecurityCodeTextField *)[self
          textFieldForIdentifier:@"security_code"];

  NSString *cleanNumber =
      [cardNumberTextField.text stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];

  BOOL isCardValid = NO;
  for (NSString *code in cardNumberTextField.paymentProductCodes) {
    if ([[HPFCardNumberFormatter sharedFormatter] plainTextNumber:cleanNumber
                                     isValidForPaymentProductCode:code]) {
      isCardValid = YES;
      break;
    }
  }

  if (isCardValid) {
    NSString *currentBin = cleanNumber;

    if (![currentBin isEqualToString:self.lastLookupBin]) {
      self.lastLookupBin = currentBin;

      __weak typeof(self) weakSelf = self;
      [[BinLookupService shared]
          lookupWithBin:currentBin
             completion:^(CardInfoResponse *_Nullable response,
                          NSError *_Nullable error) {
               __strong typeof(weakSelf) strongSelf = weakSelf;
               if (!strongSelf)
                 return;

               if (response) {
                 strongSelf.lastBinResponse = response;

                 if (strongSelf.userSelectedNetworkCode == nil) {
                   if (response.domesticNetwork) {
                     NSSet *allowed = nil;
                     if (strongSelf.paymentPageRequest.paymentProductList !=
                         nil) {
                       allowed =
                           [NSSet setWithArray:strongSelf.paymentPageRequest
                                                   .paymentProductList];
                     }

                     if (allowed == nil ||
                         [allowed containsObject:response.domesticNetwork]) {
                       strongSelf.userSelectedNetworkCode =
                           response.domesticNetwork;
                     }
                   }
                 }

                 dispatch_async(dispatch_get_main_queue(), ^{
                   [strongSelf inferPaymentProductCode];
                 });
               }
             }];
    }
  } else {
    self.lastLookupBin = nil;
    self.lastBinResponse = nil;
  }

  BOOL securityCodeSectionEnabledBefore = [self securityCodeSectionEnabled];

  NSString *currentNumber =
      [cardNumberTextField.text stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];

  NSSet<NSString *> *allowedPaymentProductCodes = nil;
  if (self.paymentPageRequest.paymentProductList != nil) {
    allowedPaymentProductCodes =
        [NSSet setWithArray:self.paymentPageRequest.paymentProductList];
  }

  NSArray<NSString *> *detectedNetworks = [[HPFCardSchemeCoordinator shared]
      getAvailableNetworksForDetectedCodes:cardNumberTextField
                                               .paymentProductCodes
                                cardNumber:currentNumber
                allowedPaymentProductCodes:allowedPaymentProductCodes];

  if (self.lastBinResponse != nil) {
    NSArray<NSString *> *apiNetworks = [self.lastBinResponse allAvailableNetworks];

    NSMutableArray<NSString *> *filteredApi = [NSMutableArray array];
    for (NSString *code in apiNetworks) {
      if (allowedPaymentProductCodes == nil ||
          [allowedPaymentProductCodes containsObject:code]) {
        [filteredApi addObject:code];
      }
    }

    detectedNetworks = filteredApi;

  } else {
    NSSet *allowedLocal =
        [NSSet setWithObjects:HPFPaymentProductCodeVisa,
                              HPFPaymentProductCodeMasterCard,
                              HPFPaymentProductCodeAmericanExpress,
                              HPFPaymentProductCodeMaestro,
                              HPFPaymentProductCodeBCMC,
                              HPFPaymentProductCodeCB, nil];

    NSMutableArray<NSString *> *filteredLocal = [NSMutableArray array];
    for (NSString *code in detectedNetworks) {
      if ([allowedLocal containsObject:code]) {
        [filteredLocal addObject:code];
      }
    }
    detectedNetworks = filteredLocal;
  }

  BOOL isCardAllowed = YES;
  if (detectedNetworks.count == 0 &&
      cardNumberTextField.paymentProductCodes.count > 0) {
    if (currentNumber.length > 10) {
      isCardAllowed = NO;
    }
  }

  NSString *potentialCode = nil;

  if (detectedNetworks.count == 0) {
    potentialCode = nil;
  } else if (detectedNetworks.count == 1) {
    potentialCode = detectedNetworks.firstObject;
  } else {
    if (self.userSelectedNetworkCode != nil) {
      potentialCode = self.userSelectedNetworkCode;
    } else {
      NSString *firstMatch = detectedNetworks.firstObject;
      if ([firstMatch isEqualToString:HPFPaymentProductCodeCB] ||
          [firstMatch isEqualToString:HPFPaymentProductCodeBCMC]) {

        potentialCode = firstMatch;

      } else {
        potentialCode = nil;
      }
    }
  }

  if (potentialCode != nil) {

    inferedPaymentProductCode = potentialCode;
    HPFPaymentProduct *newInferredPaymentProduct =
        [self getPaymentProductFromInferedCode:inferedPaymentProductCode];

    if (newInferredPaymentProduct != inferedPaymentProduct) {
      inferedPaymentProduct = newInferredPaymentProduct;

      if ([self paymentCardStorageConfigEnabled]) {
        self.touchIDOn = NO;
        self.switchOn = NO;
      }

      [self updateTitleHeader];
      [self.delegate paymentProductViewController:self
                     changeSelectedPaymentProduct:inferedPaymentProduct];
    }

    paymentProductDisallowed = (inferedPaymentProduct == nil);

  }
  else {
    if (inferedPaymentProductCode != nil) {
      inferedPaymentProductCode = nil;
      inferedPaymentProduct = nil;
      paymentProductDisallowed = NO;

      [self updateTitleHeader];
      [self.delegate paymentProductViewController:self
                     changeSelectedPaymentProduct:self.paymentProduct];

      if ([self paymentCardStorageConfigEnabled]) {
        self.touchIDOn = NO;
        self.switchOn = NO;
      }
    }
  }

  NSString *activeCode = [self currentPaymentProductCode];

  securityCodeTextField.paymentProductCode = activeCode;

  HPFSecurityCodeInputTableViewCell *cvvCell =
      (HPFSecurityCodeInputTableViewCell *)[self
          cellWithTextField:securityCodeTextField];
  if (cvvCell) {
    cvvCell.paymentProductCode = activeCode;
  }
  [self updateSecurityCodeFooterText];

  BOOL securityCodeSectionEnabledAfter = [self securityCodeSectionEnabled];

  if (securityCodeSectionEnabledBefore != securityCodeSectionEnabledAfter) {
    [self.tableView beginUpdates];
    if (securityCodeSectionEnabledAfter) {
      [self.tableView
          insertRowsAtIndexPaths:@[ [NSIndexPath
                                     indexPathForRow:3
                                           inSection:[self formSection]] ]
                withRowAnimation:UITableViewRowAnimationTop];
    } else {
      [self.tableView
          deleteRowsAtIndexPaths:@[ [NSIndexPath
                                     indexPathForRow:3
                                           inSection:[self formSection]] ]
                withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView
          reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]]
        withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
  }

  if (!paymentProductDisallowed) {
    if (self.lastBinResponse != nil) {
      NSArray<NSString *> *ordered =
          [self.lastBinResponse allAvailableNetworks];

      NSMutableArray<NSString *> *filteredOrdered = [NSMutableArray array];
      for (NSString *net in ordered) {
        if (allowedPaymentProductCodes == nil ||
            [allowedPaymentProductCodes containsObject:net]) {
          [filteredOrdered addObject:net];
        }
      }

      [HPFCardNetworkUIInjector.shared updateWithOrderedNetworks:filteredOrdered
                                                      cardNumber:currentNumber
                                                    selectedCode:potentialCode];

    } else {
      [HPFCardNetworkUIInjector.shared
          updateWithDetectedCodes:[NSSet setWithArray:detectedNetworks]
                       cardNumber:currentNumber
                     selectedCode:potentialCode];
    }

    if (isCardAllowed) {
    }
  }

  if (!isCardAllowed) {
    HPFInputTableViewCell *cell = [self cellWithTextField:cardNumberTextField];
    cell.incorrectInput = YES;
  }
}

- (HPFSecurityCodeType)currentSecurityCodeType {
  if ([self currentPaymentProductCode] != nil) {
    return [HPFPaymentProduct
        securityCodeTypeForPaymentProductCode:[self currentPaymentProductCode]];
  }
  return [HPFPaymentProduct
      securityCodeTypeForPaymentProductCode:self.paymentProduct.code];
}

- (BOOL)isTouchIDEnabled {
  return [HPFClientConfig.sharedClientConfig isTouchIDEnabled] &&
         [self canEvaluatePolicy];
}

- (BOOL)canEvaluatePolicy {
  LAContext *context = [[LAContext alloc] init];
  NSError *error;
  return
      [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           error:&error];
}

- (BOOL)paymentCardStorageEnabled {
  NSString *code = [self currentPaymentProductCode];
  if (code != nil) {
    return [HPFPaymentProduct
        isPaymentCardStorageEnabledForPaymentProductCode:code];
  }
  return [HPFPaymentProduct
      isPaymentCardStorageEnabledForPaymentProductCode:self.paymentProduct
                                                           .code];
}

- (BOOL)paymentCardStorageConfigEnabled {
  BOOL paymentCardEnabled =
      [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];
  BOOL paymentPageRequestECI =
      self.paymentPageRequest.eci == HPFECISecureECommerce ? YES : NO;
  return paymentCardEnabled && paymentPageRequestECI;
}

- (BOOL)securityCodeSectionEnabled {
  return [self currentSecurityCodeType] != HPFSecurityCodeTypeNone;
}

- (NSString *)securityCodePlaceholderForPaymentProductCode:
    (NSString *)paymentProductCode {
  if ([paymentProductCode
          isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
    return @"CARD_SECURITY_CODE_PLACEHOLDER_CID";
  } else {
    return @"CARD_SECURITY_CODE_PLACEHOLDER_CVV";
  }
}

- (BOOL)isCameraFeatureAllowed {
  return [[NSBundle mainBundle]
             objectForInfoDictionaryKey:@"NSCameraUsageDescription"] != nil;
}

#pragma mark - Table View delegate and data source

- (NSInteger)formSection {
  return 0;
}
- (NSInteger)paySection {
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  if (section == [self formSection]) {
    NSString *description = self.paymentProduct.paymentProductDescription;
    if ((inferedPaymentProduct != nil) &&
        ![HPFPaymentProduct isPaymentProductCode:self.paymentProduct.code
             domesticNetworkOfPaymentProductCode:inferedPaymentProduct.code]) {
      description = inferedPaymentProduct.paymentProductDescription;
    }
    return [NSString
        stringWithFormat:HPFLocalizedString(@"HPF_PAY_WITH_THIS_METHOD"),
                         description];
  }
  return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (section == [self formSection]) {
    if ([self securityCodeSectionEnabled]) {
      return 4;
    } else {
      return 3;
    }
  }
  return 1;
}

- (void)submit {
  if (self.userSelectedNetworkCode != nil) {
    inferedPaymentProductCode = self.userSelectedNetworkCode;
  }

  [self setPaymentButtonLoadingMode:YES];

  NSString *securityCode = nil;
  if ([self securityCodeSectionEnabled]) {
    securityCode = [self textForIdentifier:@"security_code"];
  }

  HPFExpiryDateTextField *expiryDateTextField =
      (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];
  NSString *year = [NSString
      stringWithFormat:@"%ld", (long)expiryDateTextField.dateComponents.year];
  NSString *month = [NSString
      stringWithFormat:@"%02ld",
                       (long)expiryDateTextField.dateComponents.month];

  BOOL paymentCardEnabled = [self paymentCardStorageConfigEnabled];

  if (paymentCardEnabled && [self isSwitchOn]) {
    self.paymentPageRequest.multiUse = YES;
  }

  transactionLoadingRequest = [[HPFSecureVaultClient sharedClient]
      generateTokenWithCardNumber:[self textForIdentifier:@"number"]
                  cardExpiryMonth:month
                   cardExpiryYear:year
                       cardHolder:[self textForIdentifier:@"holder"]
                     securityCode:securityCode
                         multiUse:self.paymentPageRequest.multiUse
             andCompletionHandler:^(HPFPaymentCardToken *cardToken,
                                    NSError *error) {
               [self setPaymentButtonLoadingMode:NO];
               self->transactionLoadingRequest = nil;

               if (cardToken != nil) {
                 if (paymentCardEnabled && [self isSwitchOn]) {
                   self.paymentCardToken = cardToken;
                 }

                 HPFOrderRequest *orderRequest = [self createOrderRequest];

                 if (paymentCardEnabled && [self isSwitchOn]) {
                   orderRequest.oneClick = YES;
                 }

                 NSString *paymentProductCode = self.userSelectedNetworkCode;

                 if (paymentProductCode == nil) {
                   paymentProductCode = (cardToken.domesticNetwork)
                                            ? cardToken.domesticNetwork
                                            : cardToken.brand;
                 }

                 paymentProductCode = [paymentProductCode
                     stringByReplacingOccurrencesOfString:@" "
                                               withString:@"-"];
                 orderRequest.paymentProductCode =
                     [paymentProductCode lowercaseString];
                 orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest
                     cardTokenPaymentMethodRequestWithToken:cardToken.token
                                                        eci:self.paymentPageRequest
                                                                .eci
                                    authenticationIndicator:
                                        self.paymentPageRequest
                                            .authenticationIndicator];

                 [self performOrderRequest:orderRequest
                                 signature:self.signature];

               } else {
                 [self checkTransactionError:error];
               }
             }];
}

- (void)savePaymentMethod:(HPFPaymentMethod *)paymentMethod {
  if ([paymentMethod isMemberOfClass:[HPFPaymentCardToken class]]) {
    HPFPaymentCardToken *cardToken = (HPFPaymentCardToken *)paymentMethod;

    if (self.paymentCardToken != nil) {
      if ([cardToken isEqualToPaymentCardToken:[self paymentCardToken]]) {

        if ([self paymentCardStorageConfigEnabled] && [self isSwitchOn]) {

          NSString *currentCurrency = self.paymentPageRequest.currency;
          NSArray *existingTokens = [HPFPaymentCardTokenDatabase
              paymentCardTokensForCurrency:currentCurrency];

          NSString * (^getDigitsOnly)(NSString *) =
              ^NSString *(NSString *rawString) {
                if (!rawString)
                  return @"";
                return [[rawString
                    componentsSeparatedByCharactersInSet:
                        [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                    componentsJoinedByString:@""];
              };

          NSString *newCardDigits = getDigitsOnly(cardToken.pan);

          for (HPFPaymentCardToken *existingToken in existingTokens) {
            NSString *existingCardDigits = getDigitsOnly(existingToken.pan);
            if ([existingCardDigits isEqualToString:newCardDigits]) {
              [HPFPaymentCardTokenDatabase delete:existingToken
                                      forCurrency:currentCurrency];
              break;
            }
          }

          [HPFPaymentCardTokenDatabase save:[self paymentCardToken]
                                forCurrency:self.paymentPageRequest.currency
                                withTouchID:[self isTouchIDOn]];
        }
      }
    }
  }
}

#pragma mark - HPFCardNetworkSelectionDelegate (Swift Bridge)

- (void)didPickNetwork:(NSString *)productCode {
  [self didPickNetworkWithProductCode:productCode];
}

- (void)didPickNetworkWithProductCode:(NSString *)productCode {

  BOOL securityCodeSectionEnabledBefore = [self securityCodeSectionEnabled];

  self.userSelectedNetworkCode = productCode;
  inferedPaymentProductCode = productCode;

  BOOL securityCodeSectionEnabledAfter = [self securityCodeSectionEnabled];

  [self updateTitleHeader];

  if (securityCodeSectionEnabledBefore != securityCodeSectionEnabledAfter) {
    [self.tableView beginUpdates];
    if (securityCodeSectionEnabledAfter) {
      [self.tableView
          insertRowsAtIndexPaths:@[ [NSIndexPath
                                     indexPathForRow:3
                                           inSection:[self formSection]] ]
                withRowAnimation:UITableViewRowAnimationTop];
    } else {
      [self.tableView
          deleteRowsAtIndexPaths:@[ [NSIndexPath
                                     indexPathForRow:3
                                           inSection:[self formSection]] ]
                withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView
          reloadSections:[NSIndexSet indexSetWithIndex:[self paySection]]
        withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
  }

  [self inferPaymentProductCode];

  dispatch_async(dispatch_get_main_queue(), ^{
    HPFCardNumberTextField *cardNumberTextField =
        (HPFCardNumberTextField *)[self textFieldForIdentifier:@"number"];

    if (cardNumberTextField) {
      [cardNumberTextField reapplyFormatting];

      [HPFCardNetworkUIInjector.shared
          updateWithDetectedCodes:cardNumberTextField.paymentProductCodes
                       cardNumber:[cardNumberTextField.text
                                      stringByReplacingOccurrencesOfString:@" "
                                                                withString:@""]
                     selectedCode:self.userSelectedNetworkCode];
    }
  });
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == [self paySection]) {
    return [super dequeuePaymentButtonCell];
  }

  HPFInputTableViewCell *cell;

  switch (indexPath.row) {
  case 0:
    cell = [self dequeueInputCellWithIdentifier:@"Input"
                                fieldIdentifier:@"holder"];
    cell.inputLabel.text = HPFLocalizedString(@"HPF_CARD_HOLDER_LABEL");
    cell.textField.placeholder =
        HPFLocalizedString(@"HPF_CARD_HOLDER_PLACEHOLDER");
    cell.textField.keyboardType = UIKeyboardTypeAlphabet;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cell.textField.returnKeyType = UIReturnKeyNext;
    cell.textField.textContentType = UITextContentTypeName;
    break;

  case 1: {
    cell = [self dequeueInputCellWithIdentifier:@"CardNumberInput"
                                fieldIdentifier:@"number"];
    ((HPFCardNumberInputTableViewCell *)cell).defaultPaymentProductCode =
        [self currentPaymentProductCode];
    cell.textField.returnKeyType = UIReturnKeyNext;
    cell.textField.textContentType = UITextContentTypeCreditCardNumber;

    [HPFCardNetworkUIInjector.shared attachTo:cell.textField
                                    presenter:self
                             selectionHandler:self];

    break;
  }

  case 2:
    cell = [self dequeueInputCellWithIdentifier:@"ExpiryDateInput"
                                fieldIdentifier:@"expiry_date"];
    cell.inputLabel.text = HPFLocalizedString(@"HPF_CARD_EXPIRATION_LABEL");
    cell.textField.placeholder =
        HPFLocalizedString(@"HPF_CARD_EXPIRATION_PLACEHOLDER");
    cell.textField.returnKeyType = UIReturnKeyNext;
    break;

  case 3:
    cell = [self dequeueInputCellWithIdentifier:@"SecurityCodeInput"
                                fieldIdentifier:@"security_code"];
    ((HPFSecurityCodeInputTableViewCell *)cell).paymentProductCode =
        [self currentPaymentProductCode];
    cell.textField.returnKeyType = UIReturnKeyDone;
    break;
  }

  if (cell) {
    return cell;
  } else {
    NSLog(@"Unexpected tableView error");
    abort();
  }
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  if (section == [self formSection]) {
    HPFSecurityCodeTableViewFooterView *footer = [self.tableView
        dequeueReusableHeaderFooterViewWithIdentifier:@"SecurityCode"];
    footer.paymentProductCode = [self currentPaymentProductCode];
    footer.hidden = YES;
    return footer;
  }
  return nil;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  BOOL paymentCardEnabled = [self paymentCardStorageConfigEnabled];
  if (section == [self paySection] && paymentCardEnabled) {
    if ([self paymentCardStorageEnabled]) {
      HPFPaymentCardSwitchTableHeaderView *header = [self.tableView
          dequeueReusableHeaderFooterViewWithIdentifier:@"PaymentCardSwitch"];
      [[header saveSwitch] addTarget:self
                              action:@selector(switchChanged:)
                    forControlEvents:UIControlEventValueChanged];
      return header;
    }
  }
  return nil;
}

- (void)switchChanged:(UISwitch *)sender {
  self.switchOn = sender.isOn;
  if (self.isSwitchOn && self.isTouchIDEnabled) {
    UIAlertController *alertViewController = [UIAlertController
        alertControllerWithTitle:HPFLocalizedString(
                                     @"HPF_CARD_SWITCH_TOUCHID_TITLE")
                         message:HPFLocalizedString(
                                     @"HPF_CARD_SWITCH_TOUCHID_DESCRIPTION")
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton =
        [UIAlertAction actionWithTitle:HPFLocalizedString(@"HPF_NO")
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action) {
                                 self.touchIDOn = NO;
                               }];
    UIAlertAction *settingsButton =
        [UIAlertAction actionWithTitle:HPFLocalizedString(@"HPF_YES")
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                 self.touchIDOn = YES;
                               }];
    [alertViewController addAction:cancelButton];
    [alertViewController addAction:settingsButton];
    [self presentViewController:alertViewController
                       animated:YES
                     completion:nil];
  } else {
    self.touchIDOn = NO;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  if (section == [self formSection]) {
    return footerHeight;
  }
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
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
