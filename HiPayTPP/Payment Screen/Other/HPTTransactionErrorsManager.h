//
//  HPTTransactionErrorsManager.h
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTTransactionErrorResult.h"
#import "HPTTransaction.h"

typedef void (^HPTTransactionErrorsManagerCompletionBlock)(HPTTransactionErrorResult *result);

@interface HPTTransactionErrorsManager : NSObject <UIAlertViewDelegate>
{
    NSMutableArray *history;
    NSMutableArray <NSDictionary <NSString *, id> *> *completionBlocks;
}

+ (instancetype)sharedManager;

- (void)flushHistory;

- (void)manageError:(NSError *)error withCompletionHandler:(HPTTransactionErrorsManagerCompletionBlock)completionBlock;

- (void)manageTransaction:(HPTTransaction *)transaction withCompletionHandler:(HPTTransactionErrorsManagerCompletionBlock)completionBlock;

@end
