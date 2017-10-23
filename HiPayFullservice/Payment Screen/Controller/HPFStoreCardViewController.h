//
//  HPFStoreCardViewController.h
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 18/10/2017.
//

#import <UIKit/UIKit.h>
#import "HPFTokenizableCardPaymentProductViewController.h"

@interface HPFStoreCardViewController : HPFTokenizableCardPaymentProductViewController

+ (UINavigationController *)storeCardViewControllerWithRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest signature:(NSString * _Nonnull)signature;

@end
