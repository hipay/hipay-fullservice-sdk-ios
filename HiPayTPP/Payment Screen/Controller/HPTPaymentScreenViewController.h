//
//  HPTPaymentScreenViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTGatewayClient.h"

@class HPTPaymentScreenViewController;

@protocol HPTPaymentScreenViewControllerDelegate <NSObject>

@optional

- (void)paymentScreenViewController:(HPTPaymentScreenViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction;

- (void)paymentScreenViewControllerDidCancel:(HPTPaymentScreenViewController *)viewController;

@end

@interface HPTPaymentScreenViewController : UIViewController
{
    UINavigationController *embeddedNavigationController;
    
    NSArray *paymentProducts;
}

@property (nonatomic, readonly) HPTPaymentPageRequest *paymentPageRequest;
@property (nonatomic, weak) id<HPTPaymentScreenViewControllerDelegate> paymentScreenDelegate;

- (void)loadPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest;

@end
