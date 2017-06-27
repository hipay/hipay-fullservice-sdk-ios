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

@interface HPFApplePayPaymentProductViewController ()
@property (nonatomic, strong) NSError *error;
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

- (HPFOrderRequest *)createOrderRequest
{

    // we gonna call this order as soon as we get the right callback.

    HPFOrderRequest *orderRequest = [super createOrderRequest];
    
    //orderRequest.paymentMethod = [HPFQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestWithUsername:[self textForIdentifier:@"username"]];

    return orderRequest;
}

- (void)applePayButtonTableViewCellDidTouchButton:(HPFApplePayTableViewCell *)cell {

    if (PKPaymentAuthorizationController.canMakePayments) {

        PKPaymentSummaryItem *item = [PKPaymentSummaryItem summaryItemWithLabel:@"Item"
                                                                         amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]
                                                                           type:PKPaymentSummaryItemTypeFinal];

        PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];

        paymentRequest.paymentSummaryItems = @[item];

        paymentRequest.merchantIdentifier = @"merchant.com.hipay.HiApplePay";
        paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
        paymentRequest.countryCode = @"FR";
        paymentRequest.currencyCode = @"EUR";

        paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];

        PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        vc.delegate = self;

        [self presentViewController:vc animated:YES completion:^{

            //NSLog(@"Presented payment controller");
            /*
            if presented {
        } else {
            NSLog("Failed to present payment controller")
            self.completionHandler!(false)
        }
            */

        }];
        /*
                let fare = PKPaymentSummaryItem(label: "Item", amount: NSDecimalNumber(string: "0.02"), type: .final)
        //let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "0.01"), type: .final)
        //let total = PKPaymentSummaryItem(label: "HiApplePay", amount: NSDecimalNumber(string: "0.51"), type: .final)

        paymentSummaryItems = [fare];
        completionHandler = completion

        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems

        //"merchant.\(MainBundle.prefix).Emporium"

        //paymentRequest.merchantIdentifier = Configuration.Merchant.identififer
        //paymentRequest.merchantIdentifier = "merchant.com.hipay.HiApplePay"
        paymentRequest.merchantIdentifier = "merchant.com.hipay.qa"

        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "FR"
        paymentRequest.currencyCode = "EUR"
        //paymentRequest.requiredShippingAddressFields = [.phone, .email]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                NSLog("Presented payment controller")
            } else {
                NSLog("Failed to present payment controller")
                self.completionHandler!(false)
            }
        })
        */

    } else {

        PKPassLibrary *passLibrary = [PKPassLibrary new];
        [passLibrary openPaymentSetup];
    }
}


- (void)submit
{

}


- (void)performOrderRequest:(HPFOrderRequest *)orderRequest signature:(NSString *)signature
{
    [self setPaymentButtonLoadingMode:YES];

    [self cancelRequests];

    transactionLoadingRequest = [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest signature:signature withCompletionHandler:^(HPFTransaction *theTransaction, NSError *error) {

        transactionLoadingRequest = nil;

        if (theTransaction != nil) {
            transaction = theTransaction;

            if (transaction.forwardUrl != nil) {

                UINavigationController *navigationController = self.navigationController;
                NSArray *controllers = navigationController.viewControllers;
                if (navigationController != nil && controllers != nil) {
                    HPFForwardViewController *viewController = [HPFForwardViewController relevantForwardViewControllerWithTransaction:transaction signature:signature];
                    viewController.delegate = self;

                    [self presentViewController:viewController animated:YES completion:nil];
                }
            }

            else {
                [self checkTransactionStatus:transaction];
            }
        }

        else {
            [self checkTransactionError:error];
        }

        [self setPaymentButtonLoadingMode:NO];

    }];
}

- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                 completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    //NSError *error;
    //ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
    //NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
    //NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];

    // ... Send payment token, shipping and billing address, and order information to your server ...

    //PKPaymentAuthorizationStatus status;  // From your server
    //completion(status);

    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithCardNumber:@"4111 1111 1111 11111" cardExpiryMonth:@"12" cardExpiryYear:@"2020" cardHolder:@"Marti Dupont" securityCode:@"101" multiUse:YES andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {

        //[self setPaymentButtonLoadingMode:NO];
        transactionLoadingRequest = nil;

        if (cardToken != nil) {

            self.error = nil;
            //HPFOrderRequest *orderRequest = [self createOrderRequest];

            //orderRequest.paymentProductCode = inferedPaymentProductCode;

            //orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:self.paymentPageRequest.eci authenticationIndicator:self.paymentPageRequest.authenticationIndicator];

            //[self performOrderRequest:orderRequest signature:self.signature];

            completion(PKPaymentAuthorizationStatusSuccess);

        } else {

            self.error = error;
            completion(PKPaymentAuthorizationStatusFailure);
        }
    }];
}

- (void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:^{

        if (self.error != nil) {
            [self checkTransactionError:self.error];
        }

        self.error = nil;
        /*
        [self dismissViewControllerAnimated:YES completion:nil];
        //NSLog(@"Presented payment controller");
            if presented {
        } else {
            NSLog("Failed to present payment controller")
            self.completionHandler!(false)
        }
    */
    }];
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
