//
//  HPFStoreCardViewController.m
//  HiPayFullservice
//
//  Created by HiPay on 18/10/2017.
//

#import "HPFStoreCardViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFExpiryDateTextField.h"
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"

@interface HPFStoreCardViewController ()
 
@end

@interface HPFPaymentProduct ()
@property (nonatomic, readwrite, nonnull) NSString *code;
@property (nonatomic, readwrite, nonnull) NSString *paymentProductDescription;
@end

@implementation HPFStoreCardViewController

+ (_Nonnull instancetype)storeCardViewControllerWithRequest:
    (HPFPaymentPageRequest *)paymentPageRequest {
  HPFStoreCardViewController *storevc = [[HPFStoreCardViewController alloc]
      initWithPaymentPageRequest:paymentPageRequest
                       signature:nil
       andSelectedPaymentProduct:nil];

  return storevc;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
  self.title = HPFLocalizedString(@"HPF_CARD_STORE_TITLE");
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(doCancel)];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self cancelRequests];

  [self.storeCardDelegate storeCardViewControllerDidCancel:self];
  self.storeCardDelegate = nil;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  if (section == [self formSection]) {
    if ((inferedPaymentProduct != nil)) {
      return inferedPaymentProduct.paymentProductDescription;
    }
  }

  return @"";
}

/*
- (void)submit
{
// submit pay button overriden
    NSLog(@"submit");
}
*/

/*
- (id<HPFRequest>)requestNewOrder:(HPFOrderRequest *)orderRequest
signature:(NSString *)signature
withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPFOrderRequestSerializationMapper
mapperWithRequest:orderRequest].serializedRequest;

    NSMutableDictionary *signatureParam = [NSMutableDictionary
dictionaryWithObject:signature forKey:HPFGatewayClientSignature];
    [signatureParam mergeDictionary:parameters withPrefix:nil];
    return [self handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"order"
parameters:signatureParam responseMapperClass:[HPFTransactionMapper class]
isArray:NO completionHandler:completionBlock];
}
*/

- (void)submit {

  [self setPaymentButtonLoadingMode:YES];

  NSString *securityCode = [self textForIdentifier:@"security_code"];

  HPFExpiryDateTextField *expiryDateTextField =
      (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];

  NSString *year = [NSString
      stringWithFormat:@"%ld", (long)expiryDateTextField.dateComponents.year];
  NSString *month = [NSString
      stringWithFormat:@"%02ld",
                       (long)expiryDateTextField.dateComponents.month];

  self.paymentPageRequest.multiUse = YES;

  [self cancelRequests];

  transactionLoadingRequest = [[HPFSecureVaultClient sharedClient]
      generateTokenWithCardNumber:[self textForIdentifier:@"number"]
                  cardExpiryMonth:month
                   cardExpiryYear:year
                       cardHolder:[self textForIdentifier:@"holder"]
                     securityCode:securityCode
                         multiUse:self.paymentPageRequest.multiUse
             andCompletionHandler:^(HPFPaymentCardToken *cardToken,
                                    NSError *error) {
               self->transactionLoadingRequest = nil;

               if (cardToken != nil) {

                 [HPFPaymentCardTokenDatabase
                            save:cardToken
                     forCurrency:self.paymentPageRequest.currency
                     withTouchID:NO];

                 if ([self.storeCardDelegate
                         respondsToSelector:@selector
                         (storeCardViewController:
                             shouldValidateCardToken:withCompletionHandler:)]) {
                   [self.storeCardDelegate
                       storeCardViewController:self
                       shouldValidateCardToken:cardToken
                         withCompletionHandler:^(BOOL result) {
                           [self setPaymentButtonLoadingMode:NO];

                           if (result) {
                             [self.storeCardDelegate
                                 storeCardViewController:self
                                     didEndWithCardToken:cardToken];

                           } else {
                             [self.storeCardDelegate
                                 storeCardViewController:self
                                        didFailWithError:nil];
                           }
                         }];

                 } else {

                   [self setPaymentButtonLoadingMode:NO];

                   [self.storeCardDelegate storeCardViewController:self
                                               didEndWithCardToken:cardToken];
                 }

               } else {

                 [self.storeCardDelegate storeCardViewController:self
                                                didFailWithError:error];
               }
             }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == [self paySection]) {
    HPFPaymentButtonTableViewCell *cell = [super dequeuePaymentButtonCell];

    cell.title = HPFLocalizedString(@"HPF_CARD_STORE_DESCRIPTION");
    return cell;
  }

  return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (HPFPaymentProduct *)getPaymentProductFromInferedCode:(NSString *)inferedCode {
    static NSDictionary *paymentProductDescriptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paymentProductDescriptions = @{
            HPFPaymentProductCodeVisa: @"Visa",
            HPFPaymentProductCodeMasterCard: @"MasterCard",
            HPFPaymentProductCodeDiners: @"Diners",
            HPFPaymentProductCodeAmericanExpress: @"American Express",
            HPFPaymentProductCodeCB: @"CB",
            HPFPaymentProductCodeBCMC: @"Bancontact / Mister Cash"
        };
    });

    NSString *description = paymentProductDescriptions[inferedCode];
    
    if (description) {
        HPFPaymentProduct *paymentProduct = [[HPFPaymentProduct alloc] init];
        paymentProduct.code = inferedCode;
        paymentProduct.paymentProductDescription = description;
        return paymentProduct;
    }

    return nil;
}

- (void)cancelRequests {
  [transactionLoadingRequest cancel];
}

- (BOOL)paymentCardStorageConfigEnabled {
  return NO;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 32.f;
}

- (void)doCancel {
  [self cancelRequests];

  [self.storeCardDelegate storeCardViewControllerDidCancel:self];
  self.storeCardDelegate = nil;
}

@end
