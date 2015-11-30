//
//  HPTTokenizableCardPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import "HPTAbstractPaymentProductViewController.h"

@interface HPTTokenizableCardPaymentProductViewController : HPTAbstractPaymentProductViewController
{
    CGFloat footerHeight;
    
    NSString *inferedPaymentProductCode;
    
    HPTPaymentProduct *inferedPaymentProduct;
    
    BOOL paymentProductDisallowed;
}

@end
