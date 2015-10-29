//
//  HPTForwardPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 27/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTAbstractPaymentProductViewController.h"
#import "HPTPaymentProduct.h"
#import "HPTPaymentButtonTableViewCell.h"
#import "HPTForwardViewController.h"

@interface HPTForwardPaymentProductViewController : HPTAbstractPaymentProductViewController <HPTPaymentButtonTableViewCellDelegate, HPTForwardViewControllerDelegate>
{
    HPTTransaction *transaction;
}

@property (nonatomic, readonly) HPTPaymentProduct *paymentProduct;

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest andSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct;

@end
