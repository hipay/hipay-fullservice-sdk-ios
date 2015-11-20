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
@property (nonatomic, readonly) BOOL isHiPayDomain;

@end

@implementation NSError (HPTTransactionErrorsManager)

- (NSError *)underlyingError
{
    return self.userInfo[NSUnderlyingErrorKey];
}

- (BOOL)isHiPayDomain
{
    return [self.domain isEqualToString:HPTHiPayTPPErrorDomain];
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
    UIAlertView *alertView = nil;
    BOOL reset = NO;
    
    if (transaction.state == HPTTransactionStateDeclined) {
        
        // First error
        if ((transaction.paymentMethod == nil) || ![history containsObject:transaction.paymentMethod]) {
            alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
        }
        
        // It was a retry with the same payment method
        else {
            alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_RESET") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
            
            reset = YES;
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
                                      @"reset": @(reset)
                                      }];
        
        [alertView show];
    }
    
    else {
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionNone reloadOrder:NO]);
    }

}

- (void)manageError:(NSError *)transactionError withCompletionHandler:(HPTTransactionErrorsManagerCompletionBlock)completionBlock
{
    UIAlertView *alertView = nil;
    
    // Duplicate order
    if ((transactionError.isHiPayDomain) && (transactionError.code == HPTErrorCodeAPICheckout) && [transactionError.userInfo[HPTErrorCodeAPICodeKey] isEqual:@(HPTErrorAPIDuplicateOrder)]) {
        
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionNone reloadOrder:YES]);
    }
    
    // Final error (ex. : max attempts exceeded)
    else if ([HPTGatewayClient isTransactionErrorFinal:transactionError]) {
        completionBlock([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionQuit reloadOrder:NO]);
    }

    // Unknown platform error
    else if (transactionError.isHiPayDomain && (transactionError.underlyingError.code == HPTErrorCodeHTTPClient)) {
        
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPTLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil];
        
    }

    // Connection error
    else {
        alertView = [[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPTLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPTLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:HPTLocalizedString(@"ERROR_BUTTON_RETRY"), nil];
        
        
    }
    
    if (alertView != nil) {
        [completionBlocks addObject:@{
                                      @"alert": alertView,
                                      @"block": completionBlock,
                                      @"reset": @(NO)
                                      }];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger index = [completionBlocks indexOfObjectPassingTest:^BOOL(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj[@"alert"] == alertView;
    }];
    
    
    HPTTransactionErrorsManagerCompletionBlock block = [completionBlocks objectAtIndex:index][@"block"];
    
    if (buttonIndex == alertView.cancelButtonIndex) {

        BOOL reset = [[completionBlocks objectAtIndex:index][@"reset"] boolValue];

        if (!reset) {
            block([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionNone reloadOrder:NO]);
        } else {
            block([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionReset reloadOrder:NO]);
        }
        
    } else {
        block([[HPTTransactionErrorResult alloc] initWithFormAction:HPTFormActionReload reloadOrder:NO]);
    }
    
    [completionBlocks removeObjectAtIndex:index];
}

- (void)flushHistory
{
    [history removeAllObjects];
}

@end
