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
    alertViewController = nil;
    
    // Final transaction (completed or pending)
    if (transaction.handled) {
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionQuit]);
    }
    
    else if (transaction.state == HPFTransactionStateDeclined) {
        
        // First error
        if ((transaction.paymentMethod == nil) || ![history containsObject:transaction.paymentMethod]) {
            
            //*
            alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE")
                                         message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED")
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
            
            [alertViewController addAction:cancelButton];
            
            //[self.delegate showAlertView:alertViewController];
            
            /*
            alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
             */
        }
        
        // It was a retry with the same payment method
        else {
            
            /*
            alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_RESET") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
            */
            
            alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE")
                message:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_RESET")
                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* dismissButton = [UIAlertAction
                                           actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * action) {
                                               //Handle no, thanks button
                                           }];
            
            [alertViewController addAction:dismissButton];
            
            completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionReset]);
            
        }
        
        if ([transaction.paymentMethod isKindOfClass:[HPFPaymentCardToken class]]) {
            [history addObject:transaction.paymentMethod];
        }
    }
    
    // State error or unknown
    else if (transaction.state == HPFTransactionStateError) {
        
        /*
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPFLocalizedString(@"TRANSACTION_ERROR_OTHER") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
         */
        
        alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE")
                                                                  message:HPFLocalizedString(@"TRANSACTION_ERROR_OTHER")
                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismissButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            //Handle no, thanks button
                                            
                                        }];
        
        [alertViewController addAction:dismissButton];
        
    }
    
    if (alertViewController != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertViewController,
                                      @"block": completionBlock,
                                      }];
        
        [self.delegate showAlertView:alertViewController];
        //[alertView show];
    }
}

- (void)manageError:(NSError *)transactionError withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock
{
    alertViewController = nil;

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
        
        /*
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
         */
        
        alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT")
                                                                  message:HPFLocalizedString(@"ERROR_BODY_DEFAULT")
                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismissButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            
                                            [self alertView:self->alertViewController clickedCancelButton:true];
                                        }];
        
        [alertViewController addAction:dismissButton];
    }
    
    // Network unavailable
    else if ((HTTPError != nil) && (HTTPError.code == HPFErrorCodeHTTPNetworkUnavailable)) {
        
        /*
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil];
         */

        alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION")
                                                                  message:HPFLocalizedString(@"ERROR_BODY_DEFAULT")
                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismissButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            
                                            [self alertView:self->alertViewController clickedCancelButton:true];
                                            
                                        }];
        
        UIAlertAction* retryButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_RETRY")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            [self alertView:self->alertViewController clickedCancelButton:false];
                                            
                                        }];
        
        [alertViewController addAction:dismissButton];
        [alertViewController addAction:retryButton];

        
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionBackgroundReload]);
    }
    
    // Other connection or server error
    else {
        
        /*
        alertView = [[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil];
         */
        
        alertViewController = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION")
                                                                  message:HPFLocalizedString(@"ERROR_BODY_DEFAULT")
                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismissButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            
                                            [self alertView:self->alertViewController clickedCancelButton:true];
                                            
                                        }];
        
        UIAlertAction* retryButton = [UIAlertAction
                                      actionWithTitle:HPFLocalizedString(@"ERROR_BUTTON_RETRY")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          
                                          [self alertView:self->alertViewController clickedCancelButton:false];
                                          
                                      }];
        
        [alertViewController addAction:dismissButton];
        [alertViewController addAction:retryButton];
        
        completionBlock([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionBackgroundReload]);
    }
    
    if (alertViewController != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertViewController,
                                      @"block": completionBlock,
                                      }];
        
        //[alertView show];
        
        [self.delegate showAlertView:alertViewController];
    }
}

/*
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
*/

- (void)alertView:(UIAlertController *)theAlertView clickedCancelButton:(BOOL)cancelButton
{
    alertViewController = nil;
    
    NSUInteger index = [completionBlocks indexOfObjectPassingTest:^BOOL(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj[@"alert"] == theAlertView;
    }];
    
    HPFTransactionErrorsManagerCompletionBlock block = [completionBlocks objectAtIndex:index][@"block"];
    
    /*
    if (buttonIndex != alertView.cancelButtonIndex) {
        block([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionFormReload]);
    }
    */
    
    if (!cancelButton) {
        block([[HPFTransactionErrorResult alloc] initWithFormAction:HPFFormActionFormReload]);
    }
    
    [completionBlocks removeObjectAtIndex:index];
}



/*
- (void)alertView:(UIAlertView *)theAlertView clickedButtonAx:(NSInteger)buttonIndex
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
*/

- (void)flushHistory
{
    [history removeAllObjects];
}

- (void)removeAlerts
{
    //[alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
    [alertViewController dismissViewControllerAnimated:NO completion:nil];
}

@end
