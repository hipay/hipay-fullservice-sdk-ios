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

- (void)paymentScreenViewController:(HPFPaymentScreenViewController *)viewController didEndWithTransaction:(HPFTransaction *)transaction;

- (void)paymentScreenViewControllerDidCancel:(HPFPaymentScreenViewController *)viewController;

- (void)paymentScreenViewController:(HPFPaymentScreenViewController *)viewController didFailWithError:(NSError *)error;

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

@property (nonatomic, readonly) HPFPaymentPageRequest *paymentPageRequest;
@property (nonatomic, weak) id<HPFPaymentScreenViewControllerDelegate> delegate;

+ (instancetype)paymentScreenViewControllerWithRequest:(HPFPaymentPageRequest *)paymentPageRequest;

@end
