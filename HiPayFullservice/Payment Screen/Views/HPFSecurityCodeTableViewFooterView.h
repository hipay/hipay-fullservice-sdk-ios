//
//  HPFSecurityCodeTableViewFooterView.h
//  Pods
//
//  Created by HiPay on 12/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface HPFSecurityCodeTableViewFooterView : UITableViewHeaderFooterView
{
    __weak IBOutlet UIImageView *cardImageView;
    __weak IBOutlet UILabel *securityCodeTextLabel;
    __weak IBOutlet NSLayoutConstraint *trailingConstraint;
    __weak IBOutlet NSLayoutConstraint *leadingConstraint;
}

@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) NSString *paymentProductCode;

@end
