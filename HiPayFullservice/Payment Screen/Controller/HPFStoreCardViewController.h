//
//  HPFStoreCardViewController.h
//  HiPayFullservice
//
//  Created by HiPay on 18/10/2017.
//

#import <UIKit/UIKit.h>
#import "HPFTokenizableCardPaymentProductViewController.h"
@class HPFPaymentCardToken;
@class HPFStoreCardViewController;

typedef void (^HPFStoreCardViewControllerValidateCompletionHandler)(BOOL result);

@protocol HPFStoreCardDelegate <NSObject>

@required

- (void)storeCardViewController:(HPFStoreCardViewController *_Nonnull)viewController didEndWithCardToken:(HPFPaymentCardToken * _Nonnull)theToken;

- (void)storeCardViewController:(HPFStoreCardViewController * _Nonnull)viewController didFailWithError:(NSError *_Nullable)theError;

- (void)storeCardViewControllerDidCancel:(HPFStoreCardViewController *_Nonnull)viewController;

@optional

- (void)storeCardViewController:(HPFStoreCardViewController * _Nonnull)viewController shouldValidateCardToken:(HPFPaymentCardToken * _Nonnull)theCardToken withCompletionHandler:(HPFStoreCardViewControllerValidateCompletionHandler _Nonnull)completionBlock;

@end


@interface HPFStoreCardViewController : HPFTokenizableCardPaymentProductViewController

@property (nonatomic, weak, nullable) id<HPFStoreCardDelegate> storeCardDelegate;

+ (_Nonnull instancetype)storeCardViewControllerWithRequest:(HPFPaymentPageRequest *_Nonnull)paymentPageRequest;

@end
