//
//  HPFPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPFPaymentScreenViewController.h"
#import "HPFPaymentScreenMainViewController.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFTransactionRequestResponseManager.h"
#import "HPFErrors.h"

@interface HPFPaymentScreenViewController ()
{
    UINavigationController *embeddedNavigationController;
    NSArray <HPFPaymentProduct *> *paymentProducts;
    id<HPFRequest> paymentProductsRequest;
    BOOL loadingRequest;
    UIAlertView *warningCancelWhileLoadingAlertView;

    // Background loading
    id<HPFRequest> backgroundOrderLoadingRequest;
    id<HPFRequest> backgroundTransactionLoadingRequest;
    HPFTransaction *backgroundTransactionBeingReload;
}

@end

@implementation HPFPaymentScreenViewController

#pragma mark - Init and loading payment products

+ (instancetype)paymentScreenViewControllerWithRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentScreen" bundle:HPFPaymentScreenViewsBundle()];
    HPFPaymentScreenViewController *viewController = [storyboard instantiateInitialViewController];
    
    [viewController loadPaymentProducts:paymentPageRequest signature:signature];
    
    return viewController;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The class %@ should be instantiated using %@ and NOT %@.", self.class, NSStringFromSelector(@selector(paymentScreenViewControllerWithRequest:signature:)), NSStringFromSelector(_cmd)] userInfo:nil];
}

- (void)loadPaymentProducts:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature
{
    _paymentPageRequest = paymentPageRequest;
    _signature = signature;

    [self mainViewController].loading = YES;
    [self mainViewController].signature = _signature;

    [[HPFTransactionRequestResponseManager sharedManager] flushHistory];
    
    paymentProductsRequest = [[HPFGatewayClient sharedClient] getPaymentProductsForRequest:paymentPageRequest withCompletionHandler:^(NSArray *thePaymentProducts, NSError *error) {

        [self mainViewController].loading = NO;
        paymentProductsRequest = nil;
        
        if ((error == nil) && (thePaymentProducts.count > 0)) {
            paymentProducts = [self fullPaymentProductsListWithPaymentProducts:thePaymentProducts andRequest:paymentPageRequest];
            
            [self setPaymentProductsToMainViewController];
        }
        
        else {
            
            if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_CANCEL") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil] show];
            }
            
            else {
                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil] show];
            }
        }
    }];
}

- (NSArray *)fullPaymentProductsListWithPaymentProducts:(NSArray <HPFPaymentProduct *> *)thePaymentProducts andRequest:(HPFPaymentPageRequest *)paymentPageRequest
{
    if (paymentPageRequest.paymentCardGroupingEnabled) {
        
        NSSet *groupedPaymentCardProductCodes = [paymentPageRequest.groupedPaymentCardProductCodes objectsPassingTest:^BOOL(NSString * _Nonnull code, BOOL * _Nonnull stop) {
            
            return [thePaymentProducts indexOfObjectPassingTest:^BOOL(HPFPaymentProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [obj.code isEqual:code];
            }] != NSNotFound;
        }];
        
        if (groupedPaymentCardProductCodes.count > 0) {
            NSMutableArray *newPaymentProducts = [NSMutableArray arrayWithArray:thePaymentProducts];
            
            NSIndexSet *groupedProductsToRemoveIndexes = [newPaymentProducts indexesOfObjectsPassingTest:^BOOL(HPFPaymentProduct *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [groupedPaymentCardProductCodes containsObject:obj.code];
            }];
            
            [newPaymentProducts removeObjectsAtIndexes:groupedProductsToRemoveIndexes];
            
            [newPaymentProducts insertObject:[[HPFPaymentProduct alloc] initWithGroupedProducts:groupedPaymentCardProductCodes] atIndex:groupedProductsToRemoveIndexes.firstIndex];
            
            return newPaymentProducts;
        }
    }
    
    return thePaymentProducts;
}

- (void)setPaymentProductsToMainViewController
{
    HPFPaymentScreenMainViewController *mainViewController = [self mainViewController];
    
    if (paymentProductsRequest != nil) {
        mainViewController.loading = YES;
    }

    if ((mainViewController != nil) && (paymentProducts != nil)) {
        mainViewController.paymentPageRequest = _paymentPageRequest;
        mainViewController.signature = _signature;
        mainViewController.paymentProducts = paymentProducts;
    }
}


- (HPFPaymentScreenMainViewController *)mainViewController
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
    
    HPFPaymentScreenMainViewController *mainViewController = [self mainViewController];
    
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
    if ([viewController isKindOfClass:[HPFPaymentScreenMainViewController class]]) {
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
        warningCancelWhileLoadingAlertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ALERT_TRANSACTION_LOADING_TITLE") message:HPFLocalizedString(@"ALERT_TRANSACTION_LOADING_BODY") delegate:self cancelButtonTitle:HPFLocalizedString(@"ALERT_TRANSACTION_LOADING_NO") otherButtonTitles:HPFLocalizedString(@"ALERT_TRANSACTION_LOADING_YES"), nil];
        
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
    [[HPFTransactionRequestResponseManager sharedManager] removeAlerts];
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
            [self loadPaymentProducts:self.paymentPageRequest signature:self.signature];
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

- (void)endWithTransaction:(HPFTransaction *)transaction
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

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPFTransaction *)transaction
{
    [self endWithTransaction:transaction];
}

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error
{
    [self endWithError:error];
}

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController isLoading:(BOOL)isLoading
{
    loadingRequest = isLoading;
    
    if (isLoading) {
        [self cancelBackgroundReload];
    }
    
    HPFPaymentScreenMainViewController *mainViewController = embeddedNavigationController.viewControllers.firstObject;
    
    [mainViewController focusOnSelectedPaymentProductWithAnimation:YES];
    
    [mainViewController setPaymentProductSelectionEnabled:!isLoading];
}

- (HPFPaymentProduct *)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController paymentProductForInferredPaymentProductCode:(NSString *)paymentProductCode
{
    NSUInteger index = [paymentProducts indexOfObjectPassingTest:^BOOL(HPFPaymentProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.code isEqualToString:paymentProductCode] || [obj.groupedPaymentProductCodes containsObject:paymentProductCode];
    }];
    
    if (index != NSNotFound) {
        return paymentProducts[index];
    }

    return nil;
}

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController changeSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    [[self mainViewController] changeSelectedPaymentProductTo:paymentProduct];
}

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController needsBackgroundReloadingOfTransaction:(HPFTransaction *)transaction
{
    [self reloadTransaction:transaction];
}

- (void)paymentProductViewControllerNeedsBackgroundOrderReload:(HPFAbstractPaymentProductViewController *)viewController
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
    
    backgroundOrderLoadingRequest = [[HPFGatewayClient sharedClient] getTransactionsWithOrderId:self.paymentPageRequest.orderId signature:self.signature withCompletionHandler:^(NSArray *transactions, NSError *error) {
        
        [self checkTransaction:transactions.firstObject error:error];
    }];
}

- (void)reloadTransaction:(HPFTransaction *)transaction
{
    [self cancelBackgroundReload];

    backgroundTransactionBeingReload = transaction;

    backgroundTransactionLoadingRequest = [[HPFGatewayClient sharedClient] getTransactionWithReference:transaction.transactionReference signature:self.signature withCompletionHandler:^(HPFTransaction *transaction, NSError *error) {
        
        [self checkTransaction:transaction error:error];
    }];
}

- (void)checkTransaction:(HPFTransaction *)transaction error:(NSError *)error
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
        if ((HTTPError != nil) && (HTTPError.code == HPFErrorCodeHTTPClient)) {
            
            BOOL isNotFoundError = [HTTPError.userInfo[HPFErrorCodeHTTPStatusCodeKey] integerValue] == HPFHTTPStatusNotFound;
            
            BOOL isOrderNotFoundError = (error.code == HPFErrorCodeAPICheckout) && [error.userInfo[HPFErrorCodeAPICodeKey] integerValue] == HPFErrorAPIUnknownOrder;
            
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
