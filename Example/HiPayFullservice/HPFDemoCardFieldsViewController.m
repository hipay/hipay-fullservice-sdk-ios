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

@end

@implementation HPFDemoCardFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Custom Card Fields";
    
    self.cardFieldsView = [[HiPayCardFieldsView alloc] initWithFrame:CGRectZero];
    self.cardFieldsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardFieldsView.delegate = self;

    [self.cardFieldsView fetchAvailablePaymentProductsWithCurrency:@"EUR" completion:^(NSError * _Nullable error) {
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
    NSString *amountString = @"15.00";
    NSString *currencyString = @"EUR";

    HPFOrderRequest *orderRequest = [[HPFOrderRequest alloc] init];
    orderRequest.orderId = randomOrderId;
    orderRequest.amount = @(15.00);
    orderRequest.currency = currencyString;
    orderRequest.shortDescription = @"Custom Card Fields Checkout";

    NSDictionary *parameters = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parameters" ofType:@"plist"]];
  
    NSString *passwordSignature = parameters[@"hipayStage"][@"secretPassphrase"];
 
    NSString *signaturePayload = [NSString stringWithFormat:@"%@%@%@%@", randomOrderId, amountString, currencyString, passwordSignature];
    NSString *clientSignature = [self sha1:signaturePayload];

    [self.cardFieldsView payWithOrderRequest:orderRequest
                                   signature:clientSignature
                                  completion:nil];
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
    [self finishLoadingWithSuccess:YES
                           message:[NSString stringWithFormat:@"Transaction %@ completed. State: %ld",
                                    transaction.transactionReference, (long)transaction.state]];
}

- (void)cardFieldsView:(HiPayCardFieldsView *)view didFailPaymentWithError:(NSError *)error {
    [self finishLoadingWithSuccess:NO message:error.localizedDescription];
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
