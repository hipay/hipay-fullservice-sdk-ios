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
#import "HPTTransactionRequestResponseManager.h"

@interface HPTPaymentScreenViewController ()

@end

@implementation HPTPaymentScreenViewController

#pragma mark - Init and loading payment products

+ (instancetype)paymentScreenViewControllerWithRequest:(HPTPaymentPageRequest *)paymentPageRequest
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentScreen" bundle:HPTPaymentScreenViewsBundle()];
    HPTPaymentScreenViewController *viewController = (HPTPaymentScreenViewController *)[storyboard instantiateInitialViewController];
    
    [viewController loadPaymentPageRequest:paymentPageRequest];
    
    return viewController;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The class %@ should be instantiated using %@ and NOT %@.", self.class, NSStringFromSelector(@selector(paymentScreenViewControllerWithRequest:)), NSStringFromSelector(_cmd)] userInfo:nil];
}

- (void)loadPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest
{
    _paymentPageRequest = paymentPageRequest;
    
    [self mainViewController].loading = YES;
    
    [[HPTTransactionRequestResponseManager sharedManager] flushHistory];
    
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


- (HPTPaymentScreenMainViewController *)mainViewController
{
    return embeddedNavigationController.viewControllers.firstObject;
}


#pragma mark - View related methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        embeddedNavigationController.delegate = self;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[HPTPaymentScreenMainViewController class]]) {
        [self setPaymentProductsToMainViewController];
    }
}

#pragma mark - Cancelling

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
    [self cancelActivity];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewControllerDidCancel:)]) {
        [self.delegate paymentScreenViewControllerDidCancel:self];
    }
}

- (void)cancelActivity
{
    [[self mainViewController] cancelRequests];
    [self cancelBackgroundReload];
    [[HPTTransactionRequestResponseManager sharedManager] removeAlerts];
}

#pragma mark - Alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == warningCancelWhileLoadingAlertView) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self doCancelPayment];
        }
        
        warningCancelWhileLoadingAlertView = nil;
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

#pragma mark - Ending payment

- (void)endWithError:(NSError *)error
{
    [warningCancelWhileLoadingAlertView dismissWithClickedButtonIndex:warningCancelWhileLoadingAlertView.cancelButtonIndex animated:YES];
    
    [self cancelActivity];
    
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewController:didFailWithError:)]) {
        [self.delegate paymentScreenViewController:self didFailWithError:error];
    }
    
    if ([self isModal]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)endWithTransaction:(HPTTransaction *)transaction
{
    [warningCancelWhileLoadingAlertView dismissWithClickedButtonIndex:warningCancelWhileLoadingAlertView.cancelButtonIndex animated:YES];
    
    [self cancelActivity];
    
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewController:didEndWithTransaction:)]) {
        [self.delegate paymentScreenViewController:self didEndWithTransaction:transaction];
    }
    
    if ([self isModal]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Payment product view controller delegate

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction
{
    [self endWithTransaction:transaction];
}

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error
{
    [self endWithError:error];
}

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController isLoading:(BOOL)isLoading
{
    loadingRequest = isLoading;
    
    if (isLoading) {
        [self cancelBackgroundReload];
    }
    
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

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController needsBackgroundReloadingOfTransaction:(HPTTransaction *)transaction
{
    [self reloadTransaction:transaction];
}

- (void)paymentProductViewControllerNeedsBackgroundOrderReload:(HPTAbstractPaymentProductViewController *)viewController
{
    [self reloadOrder];
}

#pragma mark - Background loading

- (void)cancelBackgroundReload
{
    [backgroundOrderLoadingRequest cancel];
    [backgroundTransactionLoadingRequest cancel];

    backgroundOrderLoadingRequest = nil;
    backgroundTransactionLoadingRequest = nil;
    backgroundTransactionBeingReload = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)reloadOrder
{
    [self cancelBackgroundReload];
    
    backgroundOrderLoadingRequest = [[HPTGatewayClient sharedClient] getTransactionsWithOrderId:self.paymentPageRequest.orderId withCompletionHandler:^(NSArray *transactions, NSError *error) {
        
        [self checkTransaction:transactions.firstObject error:error];
    }];
}

- (void)reloadTransaction:(HPTTransaction *)transaction
{
    [self cancelBackgroundReload];

    backgroundTransactionBeingReload = transaction;

    backgroundTransactionLoadingRequest = [[HPTGatewayClient sharedClient] getTransactionWithReference:transaction.transactionReference withCompletionHandler:^(HPTTransaction *transaction, NSError *error) {
        
        [self checkTransaction:transaction error:error];
    }];
}

- (void)checkTransaction:(HPTTransaction *)transaction error:(NSError *)error
{
    backgroundOrderLoadingRequest = nil;
    
    if (transaction != nil) {
        if (transaction.handled) {
            [self endWithTransaction:transaction];
        }
    }
    
    else if(error != nil) {
        
        NSError *HTTPError = error.userInfo[NSUnderlyingErrorKey];
        
        // Specific client error (4xx)
        if ((HTTPError != nil) && (HTTPError.code == HPTErrorCodeHTTPClient)) {
            
            BOOL isNotFoundError = [HTTPError.userInfo[HPTErrorCodeHTTPStatusCodeKey] integerValue] == HPTHTTPStatusNotFound;
            
            BOOL isOrderNotFoundError = (error.code == HPTErrorCodeAPICheckout) && [error.userInfo[HPTErrorCodeAPICodeKey] integerValue] == HPTErrorAPIUnknownOrder;
            
            // Other client (4xx) error, no way to handle this, should be managed by the merchant
            if (!isNotFoundError && !isOrderNotFoundError) {
                [self endWithError:error];
            }
        }
        
        // Typically a network error, let's retry
        else {
            if (backgroundOrderLoadingRequest != nil) {
                [self performSelector:@selector(reloadTransaction:) withObject:backgroundTransactionBeingReload afterDelay:5.0];
            } else {
                [self performSelector:@selector(reloadOrder) withObject:nil afterDelay:5.0];
            }
        }
    }
}

@end
