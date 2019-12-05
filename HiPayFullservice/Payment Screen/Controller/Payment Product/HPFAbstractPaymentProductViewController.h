//
//  AbstractPaymentProductViewController.h
//  Pods
//
//  Created by HiPay on 28/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentPageRequest.h"
#import "HPFTransaction.h"
#import "HPFInputTableViewCell.h"
#import "HPFPaymentButtonTableViewCell.h"
#import "HPFForwardViewController.h"
#import "HPFPaymentProduct.h"
#import "HPFApplePayTableViewCell.h"
#import "HPFTransactionRequestResponseManager.h"
#import "HPFIBANInputTableViewCell.h"

@class HPFAbstractPaymentProductViewController;
@class HPFApplePayTableViewCell;

@protocol HPFPaymentProductViewControllerDelegate <NSObject>

@required

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController didEndWithTransaction:(HPFTransaction * _Nonnull)transaction;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController didFailWithError:(NSError * _Nonnull)error;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController isLoading:(BOOL)isLoading;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController changeSelectedPaymentProduct:(HPFPaymentProduct * _Nonnull)paymentProduct;

- (HPFPaymentProduct * _Nullable)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController paymentProductForInferredPaymentProductCode:(NSString * _Nonnull)paymentProductCode;

- (void)paymentProductViewControllerNeedsBackgroundOrderReload:(HPFAbstractPaymentProductViewController * _Nullable)viewController;

- (void)paymentProductViewController:(HPFAbstractPaymentProductViewController * _Nullable)viewController needsBackgroundReloadingOfTransaction:(HPFTransaction * _Nonnull)transaction;

- (void)cancelActivity;


@end

@interface HPFAbstractPaymentProductViewController : UITableViewController <UITextFieldDelegate, HPFPaymentButtonTableViewCellDelegate, HPFForwardViewControllerDelegate, HPFTransactionRequestResponseManagerDelegate>
{
    UITextField *activeTextField;
    BOOL loading;
    NSMutableDictionary <NSString *, UITextField *> *fieldIdentifiers;
    HPFTransaction *transaction;
    BOOL defaultFormValuesDefined;
    id<HPFRequest> transactionLoadingRequest;
    BOOL keyboardShown;
}

@property (nonatomic, readonly, nullable) HPFPaymentProduct *paymentProduct;
@property (nonatomic, readonly, nullable) HPFPaymentPageRequest *paymentPageRequest;
@property (nonatomic, readonly, nullable) NSString *signature;
@property (nonatomic, weak, nullable) id<HPFPaymentProductViewControllerDelegate> delegate;

- (instancetype _Nonnull)initWithPaymentPageRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest signature:(NSString * _Nullable)signature andSelectedPaymentProduct:(HPFPaymentProduct * _Nullable)paymentProduct;

- (void)cancelRequests;

- (NSInteger) formSection;
- (NSInteger) paySection;
- (NSInteger) scanSection;

@end
