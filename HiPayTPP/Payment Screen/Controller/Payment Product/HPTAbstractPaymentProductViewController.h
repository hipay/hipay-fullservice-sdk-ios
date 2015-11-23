//
//  AbstractPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentPageRequest.h"
#import "HPTTransaction.h"
#import "HPTInputTableViewCell.h"
#import "HPTPaymentButtonTableViewCell.h"
#import "HPTForwardViewController.h"
#import "HPTPaymentProduct.h"

@class HPTAbstractPaymentProductViewController;

@protocol HPTPaymentProductViewControllerDelegate <NSObject>

@required

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction;

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error;

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController isLoading:(BOOL)isLoading;

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController changeSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct;

- (HPTPaymentProduct *)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController paymentProductForInferredPaymentProductCode:(NSString *)paymentProductCode;

- (void)paymentProductViewControllerNeedsBackgroundOrderReload:(HPTAbstractPaymentProductViewController *)viewController;

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController needsBackgroundReloadingOfTransaction:(HPTTransaction *)transaction;



@end

@interface HPTAbstractPaymentProductViewController : UITableViewController <UITextFieldDelegate, HPTPaymentButtonTableViewCellDelegate, HPTForwardViewControllerDelegate>
{
    UITextField *activeTextField;
    BOOL loading;
    NSMutableDictionary <NSString *, UITextField *> *fieldIdentifiers;
    HPTTransaction *transaction;
    BOOL defaultFormValuesDefined;
    id<HPTRequest> transactionLoadingRequest;
    id<HPTRequest> orderLoadingRequest;
}

@property (nonatomic, readonly) HPTPaymentProduct *paymentProduct;
@property (nonatomic, readonly) HPTPaymentPageRequest *paymentPageRequest;
@property (nonatomic, weak) id<HPTPaymentProductViewControllerDelegate> delegate;

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest andSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct;

- (void)cancelRequests;

@end