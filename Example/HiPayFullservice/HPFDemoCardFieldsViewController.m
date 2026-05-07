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

@interface HPFDemoCardFieldsViewController ()

@property (nonatomic, strong) HiPayCardFieldsView *cardFieldsView;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UISegmentedControl *themeControl;

@end

@implementation HPFDemoCardFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"Custom Card Fields";
    
    self.cardFieldsView = [[HiPayCardFieldsView alloc] initWithFrame:CGRectZero];
    self.cardFieldsView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.cardFieldsView];
    
    self.themeControl = [[UISegmentedControl alloc] initWithItems:@[@"Standard", @"Underline", @"Filled", @"Outlined"]];
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
        
        [self.payButton.topAnchor constraintEqualToAnchor:self.cardFieldsView.bottomAnchor constant:30],
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
    self.cardFieldsView.backgroundColor = [UIColor clearColor];
    self.cardFieldsView.containerBorderWidth = 0;

    switch (self.themeControl.selectedSegmentIndex) {
        case 0:
            self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            self.cardFieldsView.inputColor = [UIColor darkTextColor];
            self.cardFieldsView.containerBorderColor = [UIColor clearColor];
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleStandard;
            break;

        case 1:
            self.view.backgroundColor = [UIColor whiteColor];
            self.cardFieldsView.inputColor = [UIColor blackColor];
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleUnderlined;
            self.cardFieldsView.fieldBorderColor = [UIColor systemPurpleColor];
            self.cardFieldsView.fieldBorderWidth = 2.0;
            break;

        case 2:
            self.view.backgroundColor = [UIColor whiteColor];
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleFilled;
            self.cardFieldsView.fieldBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            self.cardFieldsView.fieldBorderWidth = 2.0;
            self.cardFieldsView.fieldBorderColor = [UIColor systemBlueColor];
            self.cardFieldsView.fieldCornerRadius = 8.0;
            break;

        case 3:
            self.view.backgroundColor = [UIColor whiteColor];
            self.cardFieldsView.borderStyleType = HiPayTextFieldStyleOutlined;
            self.cardFieldsView.fieldBackgroundColor = [UIColor clearColor];
            self.cardFieldsView.fieldBorderWidth = 1.5;
            self.cardFieldsView.fieldBorderColor = [UIColor lightGrayColor];
            self.cardFieldsView.fieldCornerRadius = 8.0;
            break;
    }
}

- (void)payButtonTapped {
    [self.payButton setTitle:@"Processing..." forState:UIControlStateNormal];
    self.payButton.enabled = NO;
    
    [self.cardFieldsView generateTokenWithCompletion:^(HPFPaymentCardToken * _Nullable token, NSError * _Nullable error) {
        
        if (error) {
            [self finishLoadingWithSuccess:NO message:error.localizedDescription];
            return;
        }
        
        if (token) {
            
            NSString *randomOrderId = [NSString stringWithFormat:@"TEST_%u", arc4random()];
            NSString *amountString = @"15.00";
            NSString *currencyString = @"EUR";
            
            HPFOrderRequest *orderRequest = [[HPFOrderRequest alloc] init];
            orderRequest.orderId = randomOrderId;
            orderRequest.amount = @(15.00);
            orderRequest.currency = currencyString;
            orderRequest.shortDescription = @"Custom Card Fields Checkout";
            orderRequest.paymentProductCode = token.brand;
            
            HPFCardTokenPaymentMethodRequest *paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:token.token
                                                                                                    eci:HPFECIRecurringECommerce
                                                                                                    authenticationIndicator:HPFAuthenticationIndicatorIfAvailable];
            orderRequest.paymentMethod = paymentMethod;
            
            NSDictionary *parameters = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parameters" ofType:@"plist"]];
            NSString *passwordSignature = parameters[@"hipayStage"][@"secretPassphrase"]; 
            
            NSString *signaturePayload = [NSString stringWithFormat:@"%@%@%@%@", randomOrderId, amountString, currencyString, passwordSignature];
            NSString *clientSignature = [self sha1:signaturePayload];
            
            [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest
                                                   signature:clientSignature
                                        withCompletionHandler:^(HPFTransaction * _Nullable transaction, NSError * _Nullable transactionError) {
                if (transactionError) {
                    [self finishLoadingWithSuccess:NO message:[NSString stringWithFormat:@"Transaction Failed: %@", transactionError.localizedDescription]];
                } else {
                    [self finishLoadingWithSuccess:YES message:[NSString stringWithFormat:@"Transaction %@ completed gracefully! State: %ld", transaction.transactionReference, (long)transaction.state]];
                }
            }];
        }
    }];
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
