//
//  HPFTokenizableCardPaymentProductViewController.h
//  Pods
//
//  Created by HiPay on 02/11/2015.
//
//

#import "HPFAbstractPaymentProductViewController.h"

@interface HPFTokenizableCardPaymentProductViewController : HPFAbstractPaymentProductViewController
{
    CGFloat footerHeight;
    
    NSString *inferedPaymentProductCode;
    
    HPFPaymentProduct *inferedPaymentProduct;
    
    BOOL paymentProductDisallowed;
}

@end
