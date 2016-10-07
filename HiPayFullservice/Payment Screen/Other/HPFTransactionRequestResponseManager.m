//
//  HPFTransactionErrorsManager.m
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import "HPFTransactionRequestResponseManager.h"
#import "HPFErrors.h"
#import "HPFGatewayClient.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFPaymentCardToken.h"

@implementation HPFTransactionRequestResponseManager

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

- (void)manageTransaction:(HPFTransaction *)transaction withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock
{
    alertView = nil;
    
    // Final transaction (completed or pending)
    if (transaction.handled) {
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionQuit]);
    }
    
    else if (transaction.state == HPFTransactionStateDeclined) {
        
        // First error
        if ((transaction.paymentMethod == nil) || ![history containsObject:transaction.paymentMethod]) {
            alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
        }
        
        // It was a retry with the same payment method
        else {
            alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_RESET") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
            
            completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionReset]);
        }
        
        if ([transaction.paymentMethod isKindOfClass:[HPFPaymentCardToken class]]) {
            [history addObject:transaction.paymentMethod];
        }
    }
    
    // State error or unknown
    else if (transaction.state == HPFTransactionStateError) {
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_OTHER") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
    }
    
    if (alertView != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertView,
                                      @"block": completionBlock,
                                      }];
        
        [alertView show];
    }
}

- (void)manageError:(NSError *)transactionError withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock
{
    alertView = nil;

    NSError *HTTPError = transactionError.userInfo[NSUnderlyingErrorKey];
    
    // Duplicate order
    if ((transactionError.code == HPFErrorCodeAPICheckout) && [transactionError.userInfo[HPFErrorCodeAPICodeKey] isEqual:@(HPFErrorAPIDuplicateOrder)]) {
        
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionBackgroundReload]);
    }
    
    // Final error (ex. : max attempts exceeded)
    else if ([HPFGatewayClient isTransactionErrorFinal:transactionError]) {
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionQuit]);
    }

    // Client error
    else if ((HTTPError != nil) && (HTTPError.code == HPFErrorCodeHTTPClient)) {
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
    }
    
    // Network unavailable
    else if ((HTTPError != nil) && (HTTPError.code == HPFErrorCodeHTTPNetworkUnavailable)) {
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil];

        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionBackgroundReload]);
    }
    
    // Other connection or server error
    else {
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil];
        
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionBackgroundReload]);
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
    
    HPFTransactionErrorsManagerCompletionBlock block = [completionBlocks objectAtIndex:index][@"block"];
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        block([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionFormReload]);
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
