//
//  HPFApplePayPaymentProductViewController.h
//  Pods
//
//  Created by HiPay on 14/06/2017.
//
//

#import <UIKit/UIKit.h>
#import "HPFAbstractPaymentProductViewController.h"
#import <PassKit/PassKit.h>

@interface HPFApplePayPaymentProductViewController : HPFAbstractPaymentProductViewController <PKPaymentAuthorizationViewControllerDelegate, HPFApplePayTableViewCellDelegate>

@end
