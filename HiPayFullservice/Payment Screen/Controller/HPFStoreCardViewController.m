//
//  HPFStoreCardViewController.m
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 18/10/2017.
//

#import "HPFStoreCardViewController.h"
#import "HPFStoreTokenizableCardViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"

@interface HPFStoreCardViewController ()

@end

@implementation HPFStoreCardViewController

+ (UINavigationController *)storeCardViewControllerWithRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StoreCard" bundle:HPFPaymentScreenViewsBundle()];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentScreen" bundle:HPFPaymentScreenViewsBundle()];

    //HPFStoreCardViewController *viewController = [storyboard instantiateInitialViewController];
    
    //HPFStoreCardViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"StoreCard"];

    //[viewController setParameters:paymentPageRequest signature:signature];
    
    HPFStoreTokenizableCardViewController *storevc = [[HPFStoreCardViewController alloc] initWithPaymentPageRequest:nil signature:nil andSelectedPaymentProduct:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storevc];
    return navigationController;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"Store Card";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
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

- (void)submit
{
// submit pay button overriden
    NSLog(@"submit");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we will just override the paySection and keep the scan and form sections.

    if (indexPath.section == [self paySection])
    {
        HPFPaymentButtonTableViewCell *cell = [super dequeuePaymentButtonCell];

        // just change the title.
        cell.title = HPFLocalizedString(@"CARD_SWITCH_STORE_DESCRIPTION")
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

- (BOOL)paymentCardStorageConfigEnabled
{
    return NO;
}

- (void)doCancel
{
    //[paymentProductsRequest cancel];
    //[self cancelActivity];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    /*
     if ([self.delegate respondsToSelector:@selector(paymentScreenViewControllerDidCancel:)]) {
     [self.delegate paymentScreenViewControllerDidCancel:self];
     }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
