//
//  HPFSecurityCodeTableViewFooterView.m
//  Pods
//
//  Created by HiPay on 12/11/2015.
//
//

#import "HPFSecurityCodeTableViewFooterView.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFPaymentProduct.h"

@implementation HPFSecurityCodeTableViewFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _separatorInset = UIEdgeInsetsZero;

    cardImageView.tintColor = [UIColor colorWithRed:0.597255 green:0.597255 blue:0.597255 alpha:1.0];
    
    self.paymentProductCode = nil;
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
    _separatorInset = separatorInset;
    
    leadingConstraint.constant = separatorInset.left;
    trailingConstraint.constant = separatorInset.left;
}

- (void)setPaymentProductCode:(NSString *)paymentProductCode
{
    _paymentProductCode = paymentProductCode;

    NSString *text = nil;
    NSString *imageName = nil;
    
    if ([paymentProductCode isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
        text = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_DESCRIPTION_CID");
        imageName = @"cvc_amex";
    }
    
    else {
        text = HPFLocalizedString(@"HPF_CARD_SECURITY_CODE_DESCRIPTION_CVV");
        imageName = @"cvc_mv";
    }
    
    securityCodeTextLabel.text = text;
    
    if (imageName != nil) {
        cardImageView.image = [[UIImage imageNamed:imageName inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    else {
        cardImageView.image = nil;
    }
}

@end
