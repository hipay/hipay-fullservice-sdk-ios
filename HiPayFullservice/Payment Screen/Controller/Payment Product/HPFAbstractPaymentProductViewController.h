//
//  AbstractPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentPageRequest.h"
#import "HPFTransaction.h"
#import "HPFInputTableViewCell.h"
#import "HPFPaymentButtonTableViewCell.h"
#import "HPFForwardViewController.h"
#import "HPFPaymentProduct.h"

@class HPFAbstractPaymentProductViewController;

@protocol HPFPaymentProductViewControllerDelegate <NSObject>

@required

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPFTransaction *)transaction;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController isLoading:(BOOL)isLoading;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController changeSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct;

- (HPFPaymentProduct *)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController paymentProductForInferredPaymentProductCode:(NSString *)paymentProductCode;

- (void)paymentProductViewControllerNeedsBackgroundOrderReload:(HPFAbstractPaymentProductViewController *)viewController;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController *)viewController needsBackgroundReloadingOfTransaction:(HPFTransaction *)transaction;

- (void)cancelActivity;



@end

@interface HPFAbstractPaymentProductViewController : UITableViewController <UITextFieldDelegate, HPFPaymentButtonTableViewCellDelegate, HPFForwardViewControllerDelegate>
{
    UITextField *activeTextField;
    BOOL loading;
    NSMutableDictionary <NSString *, UITextField *> *fieldIdentifiers;
    HPFTransaction *transaction;
    BOOL defaultFormValuesDefined;
    id<HPFRequest> transactionLoadingRequest;
    BOOL keyboardShown;
}

@property (nonatomic, readonly) HPFPaymentProduct *paymentProduct;
@property (nonatomic, readonly) HPFPaymentPageRequest *paymentPageRequest;
@property (nonatomic, readonly) NSString *signature;
@property (nonatomic, weak) id<HPFPaymentProductViewControllerDelegate> delegate;

- (instancetype)initWithPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature andSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct;

- (void)cancelRequests;

@end