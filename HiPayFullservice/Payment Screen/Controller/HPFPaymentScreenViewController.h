//
//  HPFPaymentScreenViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFGatewayClient.h"
#import "HPFAbstractPaymentProductViewController.h"

@class HPFPaymentScreenViewController;

/**
 *  Conform to this protocol to get informed when the payment workflow managed by the payment screen finishes.
 */
@protocol HPFPaymentScreenViewControllerDelegate <NSObject>

@optional

/**
 *  Tells the delegate that the payment workflow has ended with a transaction. This transaction can either be in "completed" or "pending" state. A transaction is completed if the user paid successfully. A transaction is in the "pending" state if it needs additional validation, for example when it has been challenged by the Fraud Protection Service.
 *  You may not receive transactions in "declined" state, as they are catched by the payment screen, displaying an error dialog and letting the user retry the payment. However, it's recommended to handle this case as well.
 *  
 *  If the payment screen was presented modally, you don't need to dismiss it yourself as this operation will be performed by the payment screen itself.
 *
 *  @param viewController The payment screen view controller for which the payment workflow has ended.
 *  @param transaction    The transaction generated during the payment workflow and for which you need to check the status.
 */
- (void)paymentScreenViewController:(HPFPaymentScreenViewController * _Nonnull)viewController didEndWithTransaction:(HPFTransaction * _Nonnull)transaction;

/**
 *  Tells the delegate that the user cancelled the payment work-flow by touching the cancel button.
 *
 *  If the payment screen was presented modally, you don't need to dismiss it yourself as this operation will be performed by the payment screen itself.
 *
 *  @param viewController The payment screen view controller for which the payment workflow has ended.
 */
- (void)paymentScreenViewControllerDidCancel:(HPFPaymentScreenViewController * _Nonnull)viewController;

/**
 *  Tells the delegate that the payment workflow has ended with an error. Typically, the error may be that user has reached the maximum number of payment attempts.
 *
 *  If the payment screen was presented modally, you don't need to dismiss it yourself as this operation will be performed by the payment screen itself.
 *
 *  @param viewController The payment screen view controller for which the payment workflow has ended.
 *  @param error          Detailed error describing the issue.
 */
- (void)paymentScreenViewController:(HPFPaymentScreenViewController * _Nonnull)viewController didFailWithError:(NSError * _Nonnull)error;

@end

/**
 *  The payment screen is a built-in comprehensive view controller that you can instantiate and present to your user for check-out. You need to initialize it with a payment page request. Once instantiated, you may present this view controller by using the standard Cocoa methods.
 */
@interface HPFPaymentScreenViewController : UIViewController <HPFPaymentProductViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

/**
 *  The payment page request used to generate the payment screen.
 *  The generated payment screen presents a total amount, a list of payment products and other order-related information. The payment screen view controller is provided with these information through the payment page request during the instantiation.
 */
@property (nonatomic, readonly) HPFPaymentPageRequest * _Nonnull paymentPageRequest;

/**
 *  The delegate which gets called once the payment workflow has ended.
 */
@property (nonatomic, weak) id<HPFPaymentScreenViewControllerDelegate> _Nullable delegate;

/**
 *  Instantiates a payment screen with a payment page request.
 *
 *  @param paymentPageRequest The payment page request which contains information about the payment products to display on the payment screen and other order-related information.
 *
 *  @return The newly instantiated payment screen that you may present to your user.
 */
+ (_Nonnull instancetype)paymentScreenViewControllerWithRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest;

@end
