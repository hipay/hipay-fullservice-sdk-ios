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
#import "NSString+HPFValidation.h"
#import "HPFPaymentScreenUtils.h"

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

            NSLog(@"Presented payment controller");
            NSLog(@"Presented payment controller");
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

- (void)paymentAuthorizationController:(PKPaymentAuthorizationController *)controller
                   didAuthorizePayment:(PKPayment *)payment
                            completion:(void (^)(PKPaymentAuthorizationStatus status))completion {


}

- (void)paymentAuthorizationControllerDidFinish:(PKPaymentAuthorizationController *)controller {

}

- (BOOL)submitButtonEnabled
{
    return [[self textForIdentifier:@"username"] isDefined];
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

    return self.dequeueApplePayCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    return HPFLocalizedString(@"PAYMENT_APPLE_PAY_DETAILS");
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

@end
