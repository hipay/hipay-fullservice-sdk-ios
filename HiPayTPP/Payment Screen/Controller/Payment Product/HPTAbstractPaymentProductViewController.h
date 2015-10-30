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

@class HPTAbstractPaymentProductViewController;

@protocol HPTPaymentProductViewControllerDelegate <NSObject>

@required

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction;

- (void)paymentProductViewController:(HPTAbstractPaymentProductViewController *)viewController didFailWithError:(NSError *)error;

@end

@interface HPTAbstractPaymentProductViewController : UITableViewController <UITextFieldDelegate>
{
    UITextField *activeTextField;
}

@property (nonatomic, readonly) HPTPaymentPageRequest *paymentPageRequest;
@property (nonatomic, weak) id<HPTPaymentProductViewControllerDelegate> delegate;

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest;

@end