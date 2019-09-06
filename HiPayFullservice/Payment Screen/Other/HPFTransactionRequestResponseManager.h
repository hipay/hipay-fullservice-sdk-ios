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

@protocol HPFTransactionRequestResponseManagerDelegate <NSObject>

@required

- (void)showAlertView:(UIAlertController *)alert;

@end

@interface HPFTransactionRequestResponseManager : NSObject
{
    NSMutableArray *history;
    NSMutableArray <NSDictionary <NSString *, id> *> *completionBlocks;    
    UIAlertController *alertViewController;
}

@property (nonatomic, weak) id<HPFTransactionRequestResponseManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)flushHistory;

- (void)removeAlerts;

- (void)manageError:(NSError *)error withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock;

- (void)manageTransaction:(HPFTransaction *)transaction withCompletionHandler:(HPFTransactionErrorsManagerCompletionBlock)completionBlock;

@end
