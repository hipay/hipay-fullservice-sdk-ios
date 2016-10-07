//
//  HPFForwardViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFTransaction.h"
#import "HPFHostedPaymentPage.h"
#import "HPFRequest.h"

@class HPFForwardViewController;

@protocol HPFForwardViewControllerDelegate <NSObject>

@required

- (void)forwardViewController:(HPFForwardViewController *)viewController didEndWithTransaction:(HPFTransaction *)transaction;

- (void)forwardViewController:(HPFForwardViewController *)viewController didFailWithError:(NSError *)error;

- (void)forwardViewControllerDidCancel:(HPFForwardViewController *)viewController;

@end

@interface HPFForwardViewController : UIViewController
{
    id<HPFRequest> backgroundRequest;
}

@property (nonatomic, readonly) HPFTransaction *transaction;
@property (nonatomic, readonly) HPFHostedPaymentPage *hostedPaymentPage;
@property (nonatomic, readonly) NSString *signature;
@property (nonatomic, weak) id<HPFForwardViewControllerDelegate> delegate;

+ (HPFForwardViewController *)relevantForwardViewControllerWithTransaction:(HPFTransaction *)transaction signature:(NSString *)signature;

+ (HPFForwardViewController *)relevantForwardViewControllerWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage signature:(NSString *)signature;
- (instancetype)initWithTransaction:(HPFTransaction *)transaction signature:(NSString *)signature;

- (instancetype)initWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage signature:(NSString *)signature;

@end
