//
//  HPFSubmitTableViewCell.m
//  HiPayFullservice
//
//  Created by HiPay on 29/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import "HPFSubmitTableViewCell.h"
//#import "HPFPaymentScreenUtils.h"

@implementation HPFSubmitTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [button setTitle:NSLocalizedString(@"FORM_SUBMIT", nil) forState:UIControlStateNormal];
    
    if (@available(iOS 13.0, *)) {
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    } else {
        // Fallback on earlier versions
    }
}

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate submitTableViewCellDidTouchButton:self];
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

- (BOOL)isEnabled
{
    return button.enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    button.enabled = enabled;
}

@end



