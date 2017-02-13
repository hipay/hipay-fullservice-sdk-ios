//
//  HPFTokenizableCardPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import "HPFAbstractPaymentProductViewController.h"
#import "CardIO.h"

@interface HPFTokenizableCardPaymentProductViewController : HPFAbstractPaymentProductViewController <CardIOPaymentViewControllerDelegate>
{
    CGFloat footerHeight;
    
    NSString *inferedPaymentProductCode;
    
    HPFPaymentProduct *inferedPaymentProduct;
    
    BOOL paymentProductDisallowed;
}

@end
