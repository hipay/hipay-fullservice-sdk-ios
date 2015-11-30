//
//  HPTForwardViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTForwardViewController.h"
#import "HPTForwardSafariViewController.h"
#import "HPTForwardWebViewViewController.h"
#import "HPTGatewayClient.h"
#import "HPTForwardViewController_Protected.h"

@interface HPTForwardViewController ()

@end

@implementation HPTForwardViewController

- (instancetype)initWithTransaction:(HPTTransaction *)transaction
{
    self = [super init];
    if (self) {
        _transaction = transaction;
        [self doInit];
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPTHostedPaymentPage *)hostedPaymentPage
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRedirectSuccessfully:) name:HPTGatewayClientDidRedirectSuccessfullyNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRedirectWithMappingError:) name:HPTGatewayClientDidRedirectWithMappingErrorNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (HPTForwardViewController *)relevantForwardViewControllerWithTransaction:(HPTTransaction *)transaction
{
    if ([HPTForwardSafariViewController isCompatible]) {
        return [[HPTForwardSafariViewController alloc] initWithTransaction:transaction];
    } else {
        return [[HPTForwardWebViewViewController alloc] initWithTransaction:transaction];
    }
}

+ (HPTForwardViewController *)relevantForwardViewControllerWithHostedPaymentPage:(HPTHostedPaymentPage *)hostedPaymentPage
{
    if ([HPTForwardSafariViewController isCompatible]) {
        return [[HPTForwardSafariViewController alloc] initWithHostedPaymentPage:hostedPaymentPage];
    } else {
        return [[HPTForwardWebViewViewController alloc] initWithHostedPaymentPage:hostedPaymentPage];
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
        [self cancelBackgroundTransactionLoading];
        [self checkTransaction:notification.userInfo[@"transaction"] error:nil];
        
        // To prevent appDidBecomeActive call
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didRedirectWithMappingError:(NSNotification *)notification
{
    [self reloadTransaction];
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
        backgroundRequest = [[HPTGatewayClient sharedClient] getTransactionWithReference:self.transaction.transactionReference withCompletionHandler:^(HPTTransaction *transaction, NSError *error) {
            
            [self checkTransaction:transaction error:error];
            
        }];
    }
    
    else {
        backgroundRequest = [[HPTGatewayClient sharedClient] getTransactionsWithOrderId:self.hostedPaymentPage.order.orderId withCompletionHandler:^(NSArray *transactions, NSError *error) {
            
            if (error != nil || ((transactions.count > 0) && ([transactions.firstObject isHandled]))) {
                [self checkTransaction:transactions.firstObject error:error];
            }
            
        }];
    }
}

- (void)checkTransaction:(HPTTransaction *)transaction error:(NSError *)error
{
    backgroundRequest = nil;
    
    if (transaction != nil) {
        if (transaction.state != HPTTransactionStateForwarding) {
            [self.delegate forwardViewController:self didEndWithTransaction:transaction];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    else if(error != nil) {
        
        NSError *HTTPError = error.userInfo[NSUnderlyingErrorKey];
        
        // Specific client error (4xx), terminate forward
        if ((HTTPError != nil) && (HTTPError.code == HPTErrorCodeHTTPClient)) {
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
