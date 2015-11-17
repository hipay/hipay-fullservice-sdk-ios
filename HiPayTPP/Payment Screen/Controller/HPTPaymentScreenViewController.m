//
//  HPTPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPTPaymentScreenViewController.h"
#import "HPTPaymentScreenMainViewController.h"
#import "HPTPaymentScreenUtils.h"

@interface HPTPaymentScreenViewController ()

@end

@implementation HPTPaymentScreenViewController

- (void)loadPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest
{
    _paymentPageRequest = paymentPageRequest;
    
    HPTPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;

    mainViewController.loading = YES;
    
    paymentProductsRequest = [[HPTGatewayClient sharedClient] getPaymentProductsForRequest:paymentPageRequest withCompletionHandler:^(NSArray *thePaymentProducts, NSError *error) {

        mainViewController.loading = NO;
        paymentProductsRequest = nil;
        
        if (error == nil) {
            paymentProducts = thePaymentProducts;
            
            [self setPaymentProductsToMainViewController];
        }
        
        else {
            [[[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPTLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_CANCEL") otherButtonTitles:HPTLocalizedString(@"ERROR_BUTTON_RETRY"), nil] show];
        }
    }];
}

- (void)setPaymentProductsToMainViewController
{
    HPTPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;
    
    if (paymentProductsRequest != nil) {
        mainViewController.loading = YES;
    }
    
    if ((mainViewController != nil) && (paymentProducts != nil)) {
        mainViewController.paymentPageRequest = _paymentPageRequest;
        mainViewController.paymentProducts = paymentProducts;
    }
}

- (void)cancelPayment
{
    [paymentProductsRequest cancel];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(paymentScreenViewControllerDidCancel:)]) {
        [self.delegate paymentScreenViewControllerDidCancel:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    HPTPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;
    
    if ([self isModal]) {
        mainViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPayment)];
    } else {
        mainViewController.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contained_controller"]) {
        
        embeddedNavigationController = segue.destinationViewController;
        
        [self setPaymentProductsToMainViewController];
    }
}

#pragma mark - Alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self cancelPayment];
    }
    
    else {
        [self loadPaymentPageRequest:self.paymentPageRequest];
    }
}

#pragma mark - Payment product view controller delegate

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction
{
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewController:didEndWithTransaction:)]) {
        [self.delegate paymentScreenViewController:self didEndWithTransaction:transaction];
    }
    
    if ([self isModal]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewController:didFailWithError:)]) {
        [self.delegate paymentScreenViewController:self didFailWithError:error];
    }
    
    if ([self isModal]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController isLoading:(BOOL)isLoading
{
    HPTPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;
    
    [mainViewController focusOnSelectedPaymentProductWithAnimation:YES];
    
    [mainViewController setPaymentProductSelectionEnabled:!isLoading];
}

@end
