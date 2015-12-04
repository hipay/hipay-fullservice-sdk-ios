//
//  HPFTransactionErrorsManager.h
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFTransactionErrorResult.h"
#import "HPFTransaction.h"

typedef void (^HPFTransactionErrorsManagerCompletionBlock)(HPFTransactionErrorResult *result);

@interface HPFTransactionRequestResponseManager : NSObject <UIAlertViewDelegate>
{
    NSMutableArray *history;
    NSMutableArray <NSDictionary <NSString *, id> *> *completionBlocks;
    UIAlertView *alertView;
}

+ (instancetype)sharedManager;

- (void)flushHistory;

- (void)removeAlerts;

- (void)manageError:(NSError *)error withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock;

- (void)manageTransaction:(HPFTransaction *)transaction withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock;

@end
