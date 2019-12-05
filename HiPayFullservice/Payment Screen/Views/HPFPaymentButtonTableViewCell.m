//
//  PaymentButtonTableViewCell.m
//  Pods
//
//  Created by HiPay on 28/10/2015.
//
//

#import "HPFPaymentButtonTableViewCell.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFPaymentButtonTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [button setTitle:HPFLocalizedString(@"HPF_PAY_BUTTON_TITLE") forState:UIControlStateNormal];
    
    if (@available(iOS 13.0, *)) {
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    } else {
        // Fallback on earlier versions
    }
}

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate paymentButtonTableViewCellDidTouchButton:self];
    }
}

- (BOOL)isLoading
{
    return [spinner isAnimating];
}

- (void)setLoading:(BOOL)loading
{
    if (loading) {
        [spinner startAnimating];
    } else {
        [spinner stopAnimating];
    }
    
    button.hidden = loading;
}

- (void)setTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isEnabled
{
    return button.enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    button.enabled = enabled;
}

@end
