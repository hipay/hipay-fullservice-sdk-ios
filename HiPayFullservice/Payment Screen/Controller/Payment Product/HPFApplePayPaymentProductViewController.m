//
//  HPFApplePayPaymentProductViewController.m
//  Pods
//
//  Created by HiPay on 14/06/2017.
//
//

#import "HPFApplePayPaymentProductViewController.h"

#import "HPFOrderRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"
#import "HPFGatewayClient.h"
#import "HPFErrors.h"

@interface HPFApplePayPaymentProductViewController ()
@property (nonatomic, strong) NSError *transactionError;
@property (nonatomic, strong) NSError *tokenError;
@property (nonatomic, assign) BOOL authorized;
@end

@implementation HPFApplePayPaymentProductViewController

- (instancetype)initWithPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature andSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    self = [super initWithPaymentPageRequest:paymentPageRequest signature:signature andSelectedPaymentProduct:paymentProduct];
    
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return self;
}

- (void)applePayButtonTableViewCellDidTouchButton:(HPFApplePayTableViewCell *)cell {

    if (PKPaymentAuthorizationViewController.canMakePayments) {

        NSArray *array = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:array]) {

            NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[self.paymentPageRequest.amount decimalValue]];

            NSString *label = self.paymentPageRequest.shortDescription ? self.paymentPageRequest.shortDescription : @"";
            PKPaymentSummaryItem *item = [PKPaymentSummaryItem summaryItemWithLabel:label
                                                                             amount:decimalNumber];

            PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];

            paymentRequest.paymentSummaryItems = @[item];

            paymentRequest.merchantIdentifier = [[HPFClientConfig sharedClientConfig] merchantIdentifier];

            paymentRequest.merchantCapabilities = PKMerchantCapability3DS;

            NSString *country = self.paymentPageRequest.customer.country;
            if (country == nil) {
                country = self.paymentPageRequest.shippingAddress.country;
            }
            paymentRequest.countryCode = country ? country : @"FR";
            paymentRequest.currencyCode = self.paymentPageRequest.currency;

            paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];

            PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
            vc.delegate = self;

            if (vc != nil) {
                [self presentViewController:vc animated:YES completion:nil];

            } else {
                
                UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_TITLE")
                                                                          message:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_MESSAGE")
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* dismissButton = [UIAlertAction
                                                actionWithTitle:HPFLocalizedString(@"HPF_ERROR_BUTTON_DISMISS")
                                                style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * action) {
                                                }];
                
                [alertViewController addAction:dismissButton];
                [self presentViewController:alertViewController animated:YES completion:nil];
                
                
                [self.delegate paymentProductViewController:self didFailWithError:[NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeApplePay userInfo:@{NSLocalizedDescriptionKey: HPFErrorCodeApplePayDescription}]];
            }

        } else {

            PKPassLibrary *passLibrary = [PKPassLibrary new];
            [passLibrary openPaymentSetup];
        }
        
    } else {
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_TITLE")
                                                                                     message:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_MESSAGE")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismissButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"HPF_ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                        }];
        
        [alertViewController addAction:dismissButton];
        [self presentViewController:alertViewController animated:YES completion:nil];

        [self.delegate paymentProductViewController:self didFailWithError:[NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeApplePay userInfo:@{NSLocalizedDescriptionKey: HPFErrorCodeApplePayDescription}]];

    }
}

- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                    handler:(nonnull void (^)(PKPaymentAuthorizationResult * _Nonnull))completion
{
    
    NSString *decodedString = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];

    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithApplePayToken:decodedString privateKeyPassword:[HPFClientConfig.sharedClientConfig applePayPrivateKeyPassword] andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {

        self->transactionLoadingRequest = nil;

        if (cardToken != nil) {

            self.tokenError = nil;

            HPFOrderRequest *orderRequest = [self createOrderRequest];

            orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token
                                                                                                              eci:HPFECISecureECommerce
                                                                                          authenticationIndicator:HPFAuthenticationIndicatorBypass];

            [self cancelRequests];
            self->transactionLoadingRequest = [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest signature:self.signature isApplePay:YES withCompletionHandler:^(HPFTransaction *theTransaction, NSError *error) {

                self->transactionLoadingRequest = nil;

                if (theTransaction != nil) {

                    self->transaction = theTransaction;
                    self.transactionError = nil;

                    if (self->transaction.isHandled) {
                        completion([[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil]);
                    } else {

                        completion([[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:nil]);
                    }
                }

                else {

                    self->transaction = nil;
                    self.transactionError = error;

                    completion([[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:nil]);
                }
            }];

        } else {

            self->transaction = nil;
            self.tokenError = error;
            completion([[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:nil]);

        }
    }];
}


- (void)performOrderRequest:(HPFOrderRequest *)orderRequest signature:(NSString *)signature
{
    //no-op
}

- (void) savePaymentMethod:(HPFPaymentMethod *)paymentMethod {
    //no-op
}

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [super createOrderRequest];
    orderRequest.paymentProductCode = HPFPaymentProductCodeCB;

    return orderRequest;
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller
{
    self.authorized = YES;
    NSLog(@"logged");
}

- (void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self cancelRequests];

    [controller dismissViewControllerAnimated:YES completion:^{

        if (self->transaction != nil) {
            [self checkTransactionStatus:self->transaction];

        } else if (self.tokenError != nil) {
            
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_TITLE")
                message:HPFLocalizedString(@"HPF_ERROR_APPLE_PAY_MESSAGE")
                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* dismissButton = [UIAlertAction
                                            actionWithTitle:HPFLocalizedString(@"HPF_ERROR_BUTTON_DISMISS")
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {
                                            }];
            
            [alertViewController addAction:dismissButton];
            [self presentViewController:alertViewController animated:YES completion:nil];
            
            [self.delegate paymentProductViewController:self didFailWithError:self.tokenError];
        
        } else if( self.transactionError != nil) {

            [self checkTransactionError:self.transactionError];

        } else {

            if (self.authorized) {
                [self needsBackgroundTransactionOrOrderReload];
            }
        }

        self.tokenError = nil;
        self.transactionError = nil;
        self->transaction = nil;
        self.authorized = NO;

    }];
}

- (void)submit
{
    //no-op
}

- (void)resetForm
{
    //no-op
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return -1;
}

- (NSInteger) scanSection
{
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HPFApplePayTableViewCell *applePayTableViewCell = self.dequeueApplePayCell;
    applePayTableViewCell.delegate = self;

    return applePayTableViewCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    return HPFLocalizedString(@"HPF_PAYMENT_APPLE_PAY_DETAILS");
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

@end
