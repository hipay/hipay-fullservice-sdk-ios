//
//  HPFDemoCardFieldsViewController.m
//  HiPayFullservice
//
//  Created by HiPay on 09/04/2026.
//  Copyright (c) 2026 HiPay. All rights reserved.
//

#import "HPFDemoCardFieldsViewController.h"
#import <HiPayFullservice/HiPayFullservice.h>
#import <CommonCrypto/CommonDigest.h>

#if __has_include(<HiPayFullservice/HiPayFullservice-Swift.h>)
#import <HiPayFullservice/HiPayFullservice-Swift.h>
#else
#import "HiPayFullservice-Swift.h"
#endif

@interface HPFDemoCardFieldsViewController () <HiPayCardFieldsViewDelegate>

@property (nonatomic, strong) HiPayCardFieldsView *cardFieldsView;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UISegmentedControl *themeControl;
@property (nonatomic, strong) UILabel *networkInfoLabel;
@property (nonatomic, strong) HPFPaymentCardToken *pendingTokenToSave;

@end

@implementation HPFDemoCardFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Custom Card Fields";
    
    self.cardFieldsView = [[HiPayCardFieldsView alloc] initWithFrame:CGRectZero];
    self.cardFieldsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardFieldsView.delegate = self;
    self.cardFieldsView.isOneClickEnabled = self.isOneClickEnabled;
    self.cardFieldsView.authenticationIndicator = [self resolvedAuthenticationIndicator];
    [self reloadSavedCards];

    [self.cardFieldsView fetchAvailablePaymentProductsWithCurrency:self.currency completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"[CardFields] Failed to fetch payment products: %@", error.localizedDescription);
        } else {
            NSLog(@"[CardFields] Allowed products: %@", self.cardFieldsView.allowedPaymentProducts);
        }
    }];

    [self.view addSubview:self.cardFieldsView];

    self.networkInfoLabel = [[UILabel alloc] init];
    self.networkInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.networkInfoLabel.font = [UIFont systemFontOfSize:13];
    self.networkInfoLabel.textColor = [UIColor secondaryLabelColor];
    self.networkInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.networkInfoLabel.text = @"No network detected";
    [self.view addSubview:self.networkInfoLabel];
    
    self.themeControl = [[UISegmentedControl alloc] initWithItems:@[@"Standard", @"Underline", @"Filled", @"Outlined", @"Icons"]];
    self.themeControl.selectedSegmentIndex = 0;
    self.themeControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.themeControl addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.themeControl];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.payButton setTitle:@"Pay Now" forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor systemBlueColor];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payButton.layer.cornerRadius = 8.0;
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.payButton addTarget:self action:@selector(payButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.payButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.themeControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.themeControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.cardFieldsView.topAnchor constraintEqualToAnchor:self.themeControl.bottomAnchor constant:30],
        [self.cardFieldsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.cardFieldsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        
        [self.networkInfoLabel.topAnchor constraintEqualToAnchor:self.cardFieldsView.bottomAnchor constant:12],
        [self.networkInfoLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.networkInfoLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],

        [self.payButton.topAnchor constraintEqualToAnchor:self.networkInfoLabel.bottomAnchor constant:20],
        [self.payButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.payButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.payButton.heightAnchor constraintEqualToConstant:50]
    ]];
    
    [self updateTheme];
}

- (void)themeChanged:(UISegmentedControl *)sender {
    [self updateTheme];
}

- (void)updateTheme {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.cardFieldsView.backgroundColor = [UIColor clearColor];
    self.cardFieldsView.inputColor = [UIColor labelColor];
    self.cardFieldsView.placeholderColor = [UIColor placeholderTextColor];
    self.cardFieldsView.containerBorderWidth = 0;
    self.cardFieldsView.containerBorderColor = [UIColor clearColor];

    self.cardFieldsView.cardholderIcon = nil;
    self.cardFieldsView.cardNumberIcon = nil;
    self.cardFieldsView.expiryDateIcon = nil;
    self.cardFieldsView.securityCodeIcon = nil;

    switch (self.themeControl.selectedSegmentIndex) {
        case 0:
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleStandard;
            self.cardFieldsView.fieldBackgroundColor = [UIColor secondarySystemBackgroundColor];
            break;

        case 1:
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleUnderlined;
            self.cardFieldsView.fieldBackgroundColor = [UIColor clearColor];
            self.cardFieldsView.fieldBorderColor = [UIColor colorWithRed:26.0/255.0 green:14.0/255.0 blue:130.0/255.0 alpha:1.0];
            self.cardFieldsView.fieldBorderWidth = 2.0;
            break;

        case 2:
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleFilled;
            self.cardFieldsView.fieldBackgroundColor = [UIColor secondarySystemBackgroundColor];
            self.cardFieldsView.fieldBorderWidth = 2.0;
            self.cardFieldsView.fieldBorderColor = [UIColor systemBlueColor];
            self.cardFieldsView.fieldCornerRadius = 8.0;
            break;

        case 3:
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleOutlined;
            self.cardFieldsView.fieldBackgroundColor = [UIColor clearColor];
            self.cardFieldsView.fieldBorderWidth = 1.5;
            self.cardFieldsView.fieldBorderColor = [UIColor separatorColor];
            self.cardFieldsView.fieldCornerRadius = 8.0;
            break;

        case 4:
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleOutlined;
            self.cardFieldsView.fieldBackgroundColor = [UIColor clearColor];
            self.cardFieldsView.fieldBorderWidth = 1.5;
            self.cardFieldsView.fieldBorderColor = [UIColor separatorColor];
            self.cardFieldsView.fieldCornerRadius = 8.0;

            self.cardFieldsView.cardholderIcon = [UIImage systemImageNamed:@"person"];
            self.cardFieldsView.cardNumberIcon = [UIImage systemImageNamed:@"creditcard"];
            self.cardFieldsView.expiryDateIcon = [UIImage systemImageNamed:@"calendar"];
            self.cardFieldsView.securityCodeIcon = [UIImage systemImageNamed:@"lock"];
            self.cardFieldsView.iconTintColor = [UIColor secondaryLabelColor];
            break;
    }
}

- (void)payButtonTapped {
    [self.payButton setTitle:@"Processing..." forState:UIControlStateNormal];
    self.payButton.enabled = NO;

    NSString *randomOrderId = [NSString stringWithFormat:@"TEST_%u", arc4random()];
    NSString *amountString = [NSString stringWithFormat:@"%.2f", self.amount];

    HPFOrderRequest *orderRequest = [[HPFOrderRequest alloc] init];
    orderRequest.orderId = randomOrderId;
    orderRequest.amount = @(self.amount);
    orderRequest.currency = self.currency;
    orderRequest.shortDescription = @"Custom Card Fields Checkout";
    orderRequest.shippingAddress.firstname = @"John";
    orderRequest.shippingAddress.lastname  = @"Doe";
    
    // Recommanded field for Console / tpp
    orderRequest.customer.firstname = @"John";
    orderRequest.customer.lastname = @"Doe";
    orderRequest.customer.email = @"john.doe@unknown.com";
    orderRequest.customer.streetAddress = @"Rue de la joie";
    orderRequest.customer.streetAddress2 = @"appt 007";
    orderRequest.customer.city = @"Paris";
    orderRequest.customer.zipCode = @"75000";
    orderRequest.customer.state = @"France";
    orderRequest.customer.country = @"FR";



    orderRequest.customData = @{ @"hello": @"world" };

    [self setDSP2InformationOnOrder:orderRequest];

    NSDictionary *parameters = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parameters" ofType:@"plist"]];

    NSString *passwordSignature = parameters[@"hipayStage"][@"secretPassphrase"];

    NSString *signaturePayload = [NSString stringWithFormat:@"%@%@%@%@", randomOrderId, amountString, self.currency, passwordSignature];
    NSString *clientSignature = [self sha1:signaturePayload];

    [self.cardFieldsView payWithOrderRequest:orderRequest
                                   signature:clientSignature
                                  completion:nil];
}

- (void)setDSP2InformationOnOrder:(HPFOrderRequest *)orderRequest {
    NSString *accountInfo = @"{"
        "\"customer\": {"
            "\"account_change\": 20180507,"
            "\"opening_account_date\": 20180507,"
            "\"password_change\": 20180507"
        "},"
        "\"purchase\": {"
            "\"count\": 2,"
            "\"payment_attempts_24h\": 0,"
            "\"payment_attempts_1y\": 0"
        "},"
        "\"shipping\": {"
            "\"shipping_used_date\": 20180507,"
            "\"address_usage_duration\": 1"
        "}"
    "}";

    NSString *previousAuthInfo = @"{ \"previous_auth_info\": \"800000987283\" }";

    NSError *errorJSON = nil;

    NSDictionary *accountInfoDict = [NSJSONSerialization
        JSONObjectWithData:[accountInfo dataUsingEncoding:NSUTF8StringEncoding]
                   options:NSJSONReadingMutableContainers
                     error:&errorJSON];

    NSDictionary *previousAuthInfoDict = [NSJSONSerialization
        JSONObjectWithData:[previousAuthInfo dataUsingEncoding:NSUTF8StringEncoding]
                   options:NSJSONReadingMutableContainers
                     error:&errorJSON];

    if (accountInfoDict)     { orderRequest.accountInfo = accountInfoDict; }
    if (previousAuthInfoDict){ orderRequest.previousAuthInfo = previousAuthInfoDict; }
}

- (NSString *)sha1:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

#pragma mark - HiPayCardFieldsViewDelegate

- (void)cardFieldsView:(HiPayCardFieldsView *)view didDetectNetworks:(NSArray<NSString *> *)networks {
    NSLog(@"[CardFields] Detected networks: %@", networks);
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didSelectNetwork:(NSString *)network {
    NSLog(@"[CardFields] Selected network: %@", network);
    self.networkInfoLabel.text = [NSString stringWithFormat:@"Selected: %@", network];
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didCompleteTransaction:(HPFTransaction *)transaction {
    BOOL paymentAccepted = [self isTransactionStateAcceptedForCardSaving:transaction.state];
    if (paymentAccepted && view.multiUse && self.pendingTokenToSave) {
        [self persistPendingToken];
    } else {
        self.pendingTokenToSave = nil;
    }
    [self finishLoadingWithSuccess:YES
                           message:[NSString stringWithFormat:@"Transaction %@ completed. State: %ld",
                                    transaction.transactionReference, (long)transaction.state]];
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didFailPaymentWithError:(NSError *)error {
    self.pendingTokenToSave = nil;
    [self finishLoadingWithSuccess:NO message:error.localizedDescription];
}

- (BOOL)isTransactionStateAcceptedForCardSaving:(HPFTransactionState)state {
    return state == HPFTransactionStateCompleted
        || state == HPFTransactionStatePending
        || state == HPFTransactionStateForwarding;
}

- (void)persistPendingToken {
    HPFPaymentCardToken *token = self.pendingTokenToSave;
    self.pendingTokenToSave = nil;
    if (!token) { return; }

    NSString *currency = [self savedCardsCurrency];
    [self deleteExistingTokenWithSamePAN:token forCurrency:currency];
    [HPFPaymentCardTokenDatabase save:token forCurrency:currency withTouchID:NO];
    [self reloadSavedCards];
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didSelectAlias:(HPFPaymentCardToken *)alias {
    NSLog(@"[CardFields] Selected alias: %@ (%@)", alias.brand, alias.token);
}

- (void)cardFieldsViewDidDeselectAlias:(HiPayCardFieldsView *)view {
    NSLog(@"[CardFields] Deselected alias");
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didRequestDeleteAlias:(HPFPaymentCardToken *)alias {
    [HPFPaymentCardTokenDatabase delete:alias forCurrency:[self savedCardsCurrency]];
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didTokenize:(HPFPaymentCardToken *)token {
    self.pendingTokenToSave = token;
}

#pragma mark - 3DS

- (HPFAuthenticationIndicator)resolvedAuthenticationIndicator {
    switch (self.authenticationIndicatorSegmentIndex) {
        case 1:  return HPFAuthenticationIndicatorIfAvailable;
        case 2:  return HPFAuthenticationIndicatorMandatory;
        case 3:  return HPFAuthenticationIndicatorBypass;
        default: return HPFAuthenticationIndicatorDefault;
    }
}

#pragma mark - Saved Cards

- (NSString *)savedCardsCurrency {
    return self.currency ?: @"EUR";
}

- (void)reloadSavedCards {
    NSArray<HPFPaymentCardToken *> *tokens = [HPFPaymentCardTokenDatabase paymentCardTokensForCurrency:[self savedCardsCurrency]];
    self.cardFieldsView.availableAliases = tokens ?: @[];
}

- (void)deleteExistingTokenWithSamePAN:(HPFPaymentCardToken *)newToken forCurrency:(NSString *)currency {
    NSString *newDigits = [self digitsOnly:newToken.pan];
    NSArray<HPFPaymentCardToken *> *existing = [HPFPaymentCardTokenDatabase paymentCardTokensForCurrency:currency];
    for (HPFPaymentCardToken *token in existing) {
        if ([[self digitsOnly:token.pan] isEqualToString:newDigits]) {
            [HPFPaymentCardTokenDatabase delete:token forCurrency:currency];
            return;
        }
    }
}

- (NSString *)digitsOnly:(NSString *)raw {
    if (!raw) { return @""; }
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[raw componentsSeparatedByCharactersInSet:nonDigits] componentsJoinedByString:@""];
}

#pragma mark - UI Helpers

- (void)finishLoadingWithSuccess:(BOOL)success message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.payButton setTitle:@"Pay Now" forState:UIControlStateNormal];
        self.payButton.enabled = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:success ? @"Success" : @"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
