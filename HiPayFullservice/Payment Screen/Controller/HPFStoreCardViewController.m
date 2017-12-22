//
//  HPFStoreCardViewController.m
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 18/10/2017.
//

#import "HPFStoreCardViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFSecureVaultClient.h"
#import "HPFExpiryDateTextField.h"
#import "HPFPaymentCardTokenDatabase.h"

@interface HPFStoreCardViewController ()

@end

@implementation HPFStoreCardViewController

+ (_Nonnull instancetype)storeCardViewControllerWithRequest:(HPFPaymentPageRequest *)paymentPageRequest
{
    HPFStoreCardViewController *storevc = [[HPFStoreCardViewController alloc] initWithPaymentPageRequest:paymentPageRequest signature:nil andSelectedPaymentProduct:nil];
    
    return storevc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = HPFLocalizedString(@"CARD_STORE_TITLE");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self cancelRequests];
    
    [self.storeCardDelegate storeCardViewControllerDidCancel:self];
    self.storeCardDelegate = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == [self formSection])
    {
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
- (id<HPFRequest>)requestNewOrder:(HPFOrderRequest *)orderRequest signature:(NSString *)signature withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPFOrderRequestSerializationMapper mapperWithRequest:orderRequest].serializedRequest;
    
    NSMutableDictionary *signatureParam = [NSMutableDictionary dictionaryWithObject:signature forKey:HPFGatewayClientSignature];
    [signatureParam mergeDictionary:parameters withPrefix:nil];
    return [self handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"order" parameters:signatureParam responseMapperClass:[HPFTransactionMapper class] isArray:NO completionHandler:completionBlock];
}
*/

- (void)submit
{
    
    [self setPaymentButtonLoadingMode:YES];
    
    NSString *securityCode = [self textForIdentifier:@"security_code"];
    
    HPFExpiryDateTextField *expiryDateTextField = (HPFExpiryDateTextField *)[self textFieldForIdentifier:@"expiry_date"];
    
    NSString *year = [NSString stringWithFormat: @"%ld", (long)expiryDateTextField.dateComponents.year];
    NSString *month = [NSString stringWithFormat: @"%02ld", (long)expiryDateTextField.dateComponents.month];
    
    self.paymentPageRequest.multiUse = YES;
    
    [self cancelRequests];
    
    transactionLoadingRequest = [[HPFSecureVaultClient sharedClient] generateTokenWithCardNumber:[self textForIdentifier:@"number"] cardExpiryMonth:month cardExpiryYear:year cardHolder:[self textForIdentifier:@"holder"] securityCode:securityCode multiUse:self.paymentPageRequest.multiUse andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {
        
        transactionLoadingRequest = nil;
        
        if (cardToken != nil) {
            
            [HPFPaymentCardTokenDatabase save:cardToken forCurrency:self.paymentPageRequest.currency withTouchID:NO];
            
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardViewController:shouldValidateCardToken:withCompletionHandler:)])
            {
                [self.storeCardDelegate storeCardViewController:self shouldValidateCardToken:cardToken withCompletionHandler:^(BOOL result) {
                   
                    if (result)
                    {
                        [self.storeCardDelegate storeCardViewController:self didEndWithCardToken:cardToken];
                        
                    } else
                    {
                        [self.storeCardDelegate storeCardViewController:self didFailWithError:nil];
                    }
                }];
                
            } else {
                
                [self setPaymentButtonLoadingMode:NO];
                
                [self.storeCardDelegate storeCardViewController:self didEndWithCardToken:cardToken];
            }
            
        } else {
            
            // callback error
            [self.storeCardDelegate storeCardViewController:self didFailWithError:error];
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we will just override the paySection and keep the scan and form sections.

    if (indexPath.section == [self paySection])
    {
        HPFPaymentButtonTableViewCell *cell = [super dequeuePaymentButtonCell];

        // just change the title.
        cell.title = HPFLocalizedString(@"CARD_STORE_DESCRIPTION");
        return cell;
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (HPFPaymentProduct *) getPaymentProductFromInferedCode:(NSString *)inferedCode
{

    // add visa mastercard diners american express, no maestro.

    if ([inferedCode isEqualToString:HPFPaymentProductCodeVisa])
    {
        HPFPaymentProduct *paymentProduct = [[HPFPaymentProduct alloc] init];
        [paymentProduct setValue:HPFPaymentProductCodeVisa forKey:@"code"];
        [paymentProduct setValue:HPFPaymentProductCodeVisa forKey:@"paymentProductDescription"];

        return paymentProduct;
    }

    if ([inferedCode isEqualToString:HPFPaymentProductCodeMasterCard])
    {
        HPFPaymentProduct *paymentProduct = [[HPFPaymentProduct alloc] init];
        [paymentProduct setValue:HPFPaymentProductCodeMasterCard forKey:@"code"];
        [paymentProduct setValue:[HPFPaymentProductCodeMasterCard capitalizedString] forKey:@"paymentProductDescription"];

        return paymentProduct;
    }

    if ([inferedCode isEqualToString:HPFPaymentProductCodeDiners])
    {
        HPFPaymentProduct *paymentProduct = [[HPFPaymentProduct alloc] init];
        [paymentProduct setValue:HPFPaymentProductCodeDiners forKey:@"code"];
        [paymentProduct setValue:[HPFPaymentProductCodeDiners capitalizedString] forKey:@"paymentProductDescription"];

        return paymentProduct;
    }

    if ([inferedCode isEqualToString:HPFPaymentProductCodeAmericanExpress])
    {
        HPFPaymentProduct *paymentProduct = [[HPFPaymentProduct alloc] init];
        [paymentProduct setValue:HPFPaymentProductCodeAmericanExpress forKey:@"code"];

        NSMutableString *paymentProductAmex = [HPFPaymentProductCodeAmericanExpress mutableCopy];
        [paymentProductAmex replaceOccurrencesOfString:@"-" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, paymentProductAmex.length)];

        [paymentProduct setValue:paymentProductAmex forKey:@"paymentProductDescription"];

        return paymentProduct;
    }

    return nil;
}

- (void)cancelRequests
{
    [transactionLoadingRequest cancel];
}

- (BOOL)paymentCardStorageConfigEnabled
{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.formSection)
    {
        // set higher when there is no scan card.
        if (self.scanSection == -1)
        {
            return 32.f;
        } else {
            return 0.f;
        }
    }

    if (section == self.scanSection)
    {
        return 0.f;
    }

    return [super tableView:tableView heightForFooterInSection:section];
}

- (void)doCancel
{
    [self cancelRequests];
    
    [self.storeCardDelegate storeCardViewControllerDidCancel:self];
    self.storeCardDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
