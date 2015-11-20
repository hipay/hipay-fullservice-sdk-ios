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
    
    [self mainViewController].loading = YES;
    
    paymentProductsRequest = [[HPTGatewayClient sharedClient] getPaymentProductsForRequest:paymentPageRequest withCompletionHandler:^(NSArray *thePaymentProducts, NSError *error) {

        [self mainViewController].loading = NO;
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

- (HPTPaymentScreenMainViewController *)mainViewController
{
    return embeddedNavigationController.viewControllers.firstObject;
}

- (void)setPaymentProductsToMainViewController
{
    HPTPaymentScreenMainViewController *mainViewController = [self mainViewController];
    
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
    if (!loadingRequest) {
        [self doCancelPayment];
    }
    
    else {
        warningCancelWhileLoadingAlertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ALERT_TRANSACTION_LOADING_TITLE") message:HPTLocalizedString(@"ALERT_TRANSACTION_LOADING_BODY") delegate:self cancelButtonTitle:HPTLocalizedString(@"ALERT_TRANSACTION_LOADING_NO") otherButtonTitles:HPTLocalizedString(@"ALERT_TRANSACTION_LOADING_YES"), nil];
        
        [warningCancelWhileLoadingAlertView show];
    }
}

- (void)doCancelPayment
{
    [paymentProductsRequest cancel];
    [[self mainViewController] cancelRequests];
    
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
    
    HPTPaymentScreenMainViewController *mainViewController = [self mainViewController];
    
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
    if (alertView == warningCancelWhileLoadingAlertView) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self doCancelPayment];
        }
    }
    
    else {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self cancelPayment];
        }
        
        else {
            [self loadPaymentPageRequest:self.paymentPageRequest];
        }
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
    loadingRequest = isLoading;
    
    HPTPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;
    
    [mainViewController focusOnSelectedPaymentProductWithAnimation:YES];
    
    [mainViewController setPaymentProductSelectionEnabled:!isLoading];
}

- (HPTPaymentProduct *)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController paymentProductForInferredPaymentProductCode:(NSString *)paymentProductCode
{
    NSUInteger index = [paymentProducts indexOfObjectPassingTest:^BOOL(HPTPaymentProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.code isEqualToString:paymentProductCode];
    }];
    
    if (index != NSNotFound) {
        return paymentProducts[index];
    }

    return nil;
}

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController changeSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    [[self mainViewController] changeSelectedPaymentProductTo:paymentProduct];
}

@end
