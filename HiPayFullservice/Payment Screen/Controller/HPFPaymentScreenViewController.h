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

@protocol HPFPaymentScreenViewControllerDelegate <NSObject>

@optional

- (void)paymentScreenViewController:(HPFPaymentScreenViewController * _Nonnull)viewController didEndWithTransaction:(HPFTransaction * _Nonnull)transaction;

- (void)paymentScreenViewControllerDidCancel:(HPFPaymentScreenViewController * _Nonnull)viewController;

- (void)paymentScreenViewController:(HPFPaymentScreenViewController * _Nonnull)viewController didFailWithError:(NSError * _Nonnull)error;

@end

@interface HPFPaymentScreenViewController : UIViewController <HPFPaymentProductViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>
{
    UINavigationController *embeddedNavigationController;
    
    NSArray <HPFPaymentProduct *> *paymentProducts;
    
    id<HPFRequest> paymentProductsRequest;
    
    BOOL loadingRequest;
    UIAlertView *warningCancelWhileLoadingAlertView;
    
    // Background loading
    id<HPFRequest> backgroundOrderLoadingRequest;
    id<HPFRequest> backgroundTransactionLoadingRequest;
    HPFTransaction *backgroundTransactionBeingReload;
}

@property (nonatomic, readonly) HPFPaymentPageRequest * _Nonnull paymentPageRequest;
@property (nonatomic, weak) id<HPFPaymentScreenViewControllerDelegate> _Nullable delegate;

+ (_Nonnull instancetype)paymentScreenViewControllerWithRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest;

@end
