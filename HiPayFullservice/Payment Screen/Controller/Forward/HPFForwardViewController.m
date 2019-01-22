
#import "HPFForwardViewController.h"
#import "HPFForwardSafariViewController.h"
#import "HPFGatewayClient.h"
#import "HPFForwardViewController_Protected.h"
#import "HPFErrors.h"
#import "HPFLogger.h"

@interface HPFForwardViewController ()

@end

@implementation HPFForwardViewController

- (instancetype)initWithTransaction:(HPFTransaction *)transaction signature:(NSString *)signature
{
    self = [super init];
    if (self) {
        _transaction = transaction;
        _signature = signature;
        [self doInit];
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage signature:(NSString *)signature
{
    self = [super init];
    if (self) {
        _hostedPaymentPage = hostedPaymentPage;
        _signature = signature;
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

+ (HPFForwardViewController *)relevantForwardViewControllerWithTransaction:(HPFTransaction *)transaction signature:(NSString *)signature;
{
    return [[HPFForwardSafariViewController alloc] initWithTransaction:transaction signature:signature];
}

+ (HPFForwardViewController *)relevantForwardViewControllerWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage signature:(NSString *)signature;
{
    return [[HPFForwardSafariViewController alloc] initWithHostedPaymentPage:hostedPaymentPage signature:signature];
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
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        [[HPFLogger sharedLogger] notice:@"<Forward>: The option \"Feedback Parameters\" is disabled on your HiPay Fullservice back office. It means that when a transaction finishes, the SDK is unable to receive all the transaction parameters, such as fraud screening and 3DS results, etc. This option is not mandatory in order for the SDK to run properly. However, if you wish to receive transactions with a comprehensive set of proporties filled in your transaction callback methods, go in your HiPay Fullservice back office > Integration > Redirect Pages and enable the  \"Feedback Parameters\" option."];
    });
    
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
 
    if (self.presentingViewController != nil) {
        if (self.transaction != nil) {
            backgroundRequest = [[HPFGatewayClient sharedClient] getTransactionWithReference:self.transaction.transactionReference signature:self.signature withCompletionHandler:^(HPFTransaction *transaction, NSError *error) {
                
                [self checkTransaction:transaction error:error];
                
            }];
        }
        
        else {
            backgroundRequest = [[HPFGatewayClient sharedClient] getTransactionsWithOrderId:self.hostedPaymentPage.order.orderId signature:self.signature withCompletionHandler:^(NSArray *transactions, NSError *error) {
                
                if (error != nil || ((transactions.count > 0) && ([transactions.firstObject isHandled]))) {
                    [self checkTransaction:transactions.firstObject error:error];
                }
                
            }];
        }
    }
}

- (void)checkTransaction:(HPFTransaction *)transaction error:(NSError *)error
{
    backgroundRequest = nil;
    
    if (transaction != nil) {
        if (transaction.state != HPFTransactionStateForwarding) {
            [self.delegate forwardViewController:self didEndWithTransaction:transaction];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        } else {
            [self performSelector:@selector(reloadTransaction) withObject:nil afterDelay:5.0];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(reloadTransaction) withObject:nil afterDelay:5.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelBackgroundTransactionLoading];
}

- (void)dealloc
{
    [self cancelBackgroundTransactionLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
