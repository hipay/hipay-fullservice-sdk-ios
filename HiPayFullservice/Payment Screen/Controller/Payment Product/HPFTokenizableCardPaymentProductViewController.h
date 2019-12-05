//
//  HPFTokenizableCardPaymentProductViewController.h
//  Pods
//
//  Created by HiPay on 02/11/2015.
//
//

#import "HPFAbstractPaymentProductViewController.h"
#import "HPFScanCardTableViewCell.h"
#import "CardIO.h"

@interface HPFTokenizableCardPaymentProductViewController : HPFAbstractPaymentProductViewController <CardIOPaymentViewControllerDelegate, HPFScanCardTableViewCellDelegate>
{
    CGFloat footerHeight;
    
    NSString *inferedPaymentProductCode;
    
    HPFPaymentProduct *inferedPaymentProduct;
    
    BOOL paymentProductDisallowed;
}

@end
