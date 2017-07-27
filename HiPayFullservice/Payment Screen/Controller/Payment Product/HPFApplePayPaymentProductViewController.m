//
//  HPFApplePayPaymentProductViewController.m
//  Pods
//
//  Created by Nicolas FILLION on 14/06/2017.
//
//

#import "HPFApplePayPaymentProductViewController.h"

#import "HPFOrderRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"
#import "HPFGatewayClient.h"
#import "HPFTransactionRequestResponseManager.h"
#import "HPFErrors.h"

@interface HPFApplePayPaymentProductViewController ()
@property (nonatomic, strong) NSError *error;
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

    if (PKPaymentAuthorizationController.canMakePayments) {

        NSArray *array = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        if ([PKPaymentAuthorizationController canMakePaymentsUsingNetworks:array]) {

            NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[self.paymentPageRequest.amount decimalValue]];

            NSString *label = self.paymentPageRequest.shortDescription ? self.paymentPageRequest.shortDescription : @"";
            PKPaymentSummaryItem *item = [PKPaymentSummaryItem summaryItemWithLabel:label
                                                                             amount:decimalNumber];

            PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];

            paymentRequest.paymentSummaryItems = @[item];

            paymentRequest.merchantIdentifier = @"merchant.com.hipay.qa";
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

                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT")
                                            message:HPFLocalizedString(@"PAYMENT_APPLE_PAY_ERROR")
                                           delegate:nil
                                  cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                  otherButtonTitles:nil]
                        show];
            }

        } else {

            PKPassLibrary *passLibrary = [PKPassLibrary new];
            [passLibrary openPaymentSetup];
        }
    } else {

        [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT")
                                    message:nil//HPFLocalizedString(@"PAYMENT_APPLE_PAY_ERROR")
                                   delegate:nil
                          cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                          otherButtonTitles:nil]
                show];

    }
}

- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                 completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    
    NSString *decodedString = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];

    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithApplePayToken:decodedString privateKeyPass:@"test" andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {

        transactionLoadingRequest = nil;

        if (cardToken != nil) {

            self.error = nil;

            HPFOrderRequest *orderRequest = [self createOrderRequest];

            orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:self.paymentPageRequest.eci authenticationIndicator:HPFECISecureECommerce];

            [self cancelRequests];
            transactionLoadingRequest = [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest signature:self.signature withCompletionHandler:^(HPFTransaction *theTransaction, NSError *error) {

                transactionLoadingRequest = nil;

                if (theTransaction != nil) {

                    transaction = theTransaction;
                    self.error = nil;

                    if (transaction.isHandled) {

                        completion(PKPaymentAuthorizationStatusSuccess);

                    } else {

                        completion(PKPaymentAuthorizationStatusFailure);
                    }
                }

                else {

                    transaction = nil;
                    self.error = error;

                    completion(PKPaymentAuthorizationStatusFailure);
                }
            }];

        } else {

            transaction = nil;
            self.error = error;
            completion(PKPaymentAuthorizationStatusFailure);

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

        if (self.error != nil) {
            [self checkTransactionError:self.error];

        } else if (transaction != nil) {
            [self checkTransactionStatus:transaction];

        } else {

            if (self.authorized) {
                [self needsBackgroundTransactionOrOrderReload];
            }
        }

        self.error = nil;
        transaction = nil;
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

    return HPFLocalizedString(@"PAYMENT_APPLE_PAY_DETAILS");
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

@end
