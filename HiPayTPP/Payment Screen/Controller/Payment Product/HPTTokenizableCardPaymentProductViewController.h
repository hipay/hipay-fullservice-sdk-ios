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
    dispatch_once_t cardHolderPredefinedBlock;
    
    CGFloat footerHeight;
    
    NSString *inferedPaymentProductCode;
}

@end
