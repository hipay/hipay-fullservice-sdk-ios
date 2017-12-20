//
//  HPFStoreCardViewController.h
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 18/10/2017.
//

#import <UIKit/UIKit.h>
#import "HPFTokenizableCardPaymentProductViewController.h"
@class HPFPaymentCardToken;
@class HPFStoreCardViewController;

@protocol HPFStoreCardDelegate <NSObject>

@optional

- (void)storeCardViewController:(HPFStoreCardViewController *_Nonnull)viewController didEndWithCardToken:(HPFPaymentCardToken * _Nonnull)theToken;

- (void)storeCardViewController:(HPFStoreCardViewController * _Nonnull)viewController didFailWithError:(NSError *_Nonnull)theError;

- (void)storeCardViewControllerDidCancel:(HPFStoreCardViewController *_Nonnull)viewController;

@end

typedef void (^HPFStoreCardViewControllerValidateCompletionHandler)(NSError * _Nullable error);

@interface HPFStoreCardViewController : HPFTokenizableCardPaymentProductViewController

@property (nonatomic, weak, nullable) id<HPFStoreCardDelegate> storeCardDelegate;

- (void)storeCardViewController:(HPFStoreCardViewController * _Nonnull)viewController shouldValidateCardToken:(HPFPaymentCardToken * _Nonnull)theCardToken withCompletionHandler:(HPFStoreCardViewControllerValidateCompletionHandler _Nullable * _Nonnull)completionBlock;

+ (UINavigationController * _Nonnull)storeCardViewControllerWithRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest;

@end
