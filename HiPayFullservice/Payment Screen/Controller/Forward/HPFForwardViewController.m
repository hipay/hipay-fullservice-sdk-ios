//
//  HPFForwardViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPFForwardViewController.h"
#import "HPFForwardSafariViewController.h"
#import "HPFForwardWebViewViewController.h"
#import "HPFGatewayClient.h"
#import "HPFForwardViewController_Protected.h"
#import "HPFErrors.h"

@interface HPFForwardViewController ()

@end

@implementation HPFForwardViewController

- (instancetype)initWithTransaction:(HPFTransaction *)transaction
{
    self = [super init];
    if (self) {
        _transaction = transaction;
        [self doInit];
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage
{
    self = [super init];
    if (self) {
        _hostedPaymentPage = hostedPaymentPage;
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRedirectSuccessfully:) name:HPFGatewayClientDidRedirectSuccessfullyNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRedirectWithMappingError:) name:HPFGatewayClientDidRedirectWithMappingErrorNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (HPFForwardViewController *)relevantForwardViewControllerWithTransaction:(HPFTransaction *)transaction
{
    if ([HPFForwardSafariViewController isCompatible]) {
        return [[HPFForwardSafariViewController alloc] initWithTransaction:transaction];
    } else {
        return [[HPFForwardWebViewViewController alloc] initWithTransaction:transaction];
    }
}

+ (HPFForwardViewController *)relevantForwardViewControllerWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage
{
    if ([HPFForwardSafariViewController isCompatible]) {
        return [[HPFForwardSafariViewController alloc] initWithHostedPaymentPage:hostedPaymentPage];
    } else {
        return [[HPFForwardWebViewViewController alloc] initWithHostedPaymentPage:hostedPaymentPage];
    }
}

#pragma mark - Redirect

- (NSString *)currentOrderId
{
    if (self.hostedPaymentPage != nil) {
        return self.hostedPaymentPage.order.orderId;
    }
    
    return self.transaction.order.orderId;
}

- (void)didRedirectSuccessfully:(NSNotification *)notification
{
    [self cancelBackgroundTransactionLoading];
    
    NSString *orderId = notification.userInfo[@"orderId"];
    
    // To avoid late redirection of previous order
    if ([[self currentOrderId] isEqualToString:orderId]) {

        [self checkTransaction:notification.userInfo[@"transaction"] error:nil];
        
        // To prevent appDidBecomeActive call
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didRedirectWithMappingError:(NSNotification *)notification
{
    HPFOrder *order = self.transaction != nil ? self.transaction.order : self.hostedPaymentPage.order;
    
    NSDictionary *statesForRedirectPaths = @{
                                           HPFOrderRelatedRequestRedirectPathAccept : @(HPFTransactionStateCompleted),
                                           HPFOrderRelatedRequestRedirectPathDecline : @(HPFTransactionStateDeclined),
                                           HPFOrderRelatedRequestRedirectPathCancel : @(HPFTransactionStateDeclined),
                                           HPFOrderRelatedRequestRedirectPathException : @(HPFTransactionStateError),
                                           HPFOrderRelatedRequestRedirectPathPending : @(HPFTransactionStatePending)
                                           };
    
    NSNumber *stateNumber = statesForRedirectPaths[notification.userInfo[@"path"]];
    
    if (stateNumber != nil) {

        HPFTransaction *newTransaction = [[HPFTransaction alloc] initWithOrder:order state:stateNumber.integerValue];
        [self checkTransaction:newTransaction error:nil];

        // To prevent appDidBecomeActive call
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    else {
        [self reloadTransaction];
    }
}

#pragma mark - Background check

- (void)appDidBecomeActive:(NSNotification *)notification
{
    [self reloadTransaction];
}

- (void)cancelBackgroundTransactionLoading
{
    [backgroundRequest cancel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTransaction) object:nil];
    backgroundRequest = nil;
}

- (void)reloadTransaction
{
    [self cancelBackgroundTransactionLoading];
    
    if (self.transaction != nil) {
        backgroundRequest = [[HPFGatewayClient sharedClient] getTransactionWithReference:self.transaction.transactionReference withCompletionHandler:^(HPFTransaction *transaction, NSError *error) {
            
            [self checkTransaction:transaction error:error];
            
        }];
    }
    
    else {
        backgroundRequest = [[HPFGatewayClient sharedClient] getTransactionsWithOrderId:self.hostedPaymentPage.order.orderId withCompletionHandler:^(NSArray *transactions, NSError *error) {
            
            if (error != nil || ((transactions.count > 0) && ([transactions.firstObject isHandled]))) {
                [self checkTransaction:transactions.firstObject error:error];
            }
            
        }];
    }
}

- (void)checkTransaction:(HPFTransaction *)transaction error:(NSError *)error
{
    backgroundRequest = nil;
    
    if (transaction != nil) {
        if (transaction.state != HPFTransactionStateForwarding) {
            [self.delegate forwardViewController:self didEndWithTransaction:transaction];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    else if(error != nil) {
        
        NSError *HTTPError = error.userInfo[NSUnderlyingErrorKey];
        
        // Specific client error (4xx), terminate forward
        if ((HTTPError != nil) && (HTTPError.code == HPFErrorCodeHTTPClient)) {
            [self.delegate forwardViewController:self didFailWithError:error];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        // Typically a network error, let's retry
        else {
            [self performSelector:@selector(reloadTransaction) withObject:nil afterDelay:5.0];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
