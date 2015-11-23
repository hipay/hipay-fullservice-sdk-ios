//
//  HPTTransactionErrorsManager.m
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import "HPTTransactionErrorsManager.h"
#import "HPTErrors.h"
#import "HPTGatewayClient.h"
#import "HPTPaymentScreenUtils.h"

@interface NSError (HPTTransactionErrorsManager)

@property (nonatomic, readonly) NSError *underlyingError;

@end

@implementation NSError (HPTTransactionErrorsManager)

- (NSError *)underlyingError
{
    return self.userInfo[NSUnderlyingErrorKey];
}

@end

@implementation HPTTransactionErrorsManager

+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        history = [NSMutableArray array];
        completionBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)manageTransaction:(HPTTransaction *)transaction withCompletionHandler:(HPTTransactionErrorsManagerCompletionBlock)completionBlock
{
    alertView = nil;
    
    // Final transaction (completed or pending)
    if (transaction.handled) {
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionQuit]);
    }
    
    else if (transaction.state == HPTTransactionStateDeclined) {
        
        // First error
        if ((transaction.paymentMethod == nil) || ![history containsObject:transaction.paymentMethod]) {
            alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
        }
        
        // It was a retry with the same payment method
        else {
            alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_RESET") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
            
            completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionReset]);
        }
        
        if ([transaction.paymentMethod isKindOfClass:[HPTPaymentCardToken class]]) {
            [history addObject:transaction.paymentMethod];
        }
    }
    
    // State error or unknown
    else if (transaction.state == HPTTransactionStateError) {
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_OTHER") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
    }
    
    if (alertView != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertView,
                                      @"block": completionBlock,
                                      }];
        
        [alertView show];
    }
}

- (void)manageError:(NSError *)transactionError withCompletionHandler:(HPTTransactionErrorsManagerCompletionBlock)completionBlock
{
    alertView = nil;

    NSError *HTTPError = transactionError.userInfo[NSUnderlyingErrorKey];
    
    // Duplicate order
    if ((transactionError.code == HPTErrorCodeAPICheckout) && [transactionError.userInfo[HPTErrorCodeAPICodeKey] isEqual:@(HPTErrorAPIDuplicateOrder)]) {
        
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionBackgroundReload]);
    }
    
    // Final error (ex. : max attempts exceeded)
    else if ([HPTGatewayClient isTransactionErrorFinal:transactionError]) {
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionQuit]);
    }

    // Client error
    else if ((HTTPError != nil) && (HTTPError.code == HPTErrorCodeHTTPClient)) {
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPTLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
    }
    
    // Network unavailable
    else if ((HTTPError != nil) && (HTTPError.code == HPTErrorCodeHTTPNetworkUnavailable)) {
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPTLocalizedString(@"ERROR_BODY_NETWORK_UNAVAILABLE") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];

        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionBackgroundReload]);
    }
    
    // Other connection or server error
    else {
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPTLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPTLocalizedString(@"ERROR_BUTTON_RETRY"), nil];
        
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionBackgroundReload]);
    }
    
    if (alertView != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertView,
                                      @"block": completionBlock,
                                      }];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertView = nil;
    
    NSUInteger index = [completionBlocks indexOfObjectPassingTest:^BOOL(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj[@"alert"] == theAlertView;
    }];
    
    HPTTransactionErrorsManagerCompletionBlock block = [completionBlocks objectAtIndex:index][@"block"];
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        block([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionFormReload]);
    }
    
    [completionBlocks removeObjectAtIndex:index];
}

- (void)flushHistory
{
    [history removeAllObjects];
}

- (void)removeAlerts
{
    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
}

@end
