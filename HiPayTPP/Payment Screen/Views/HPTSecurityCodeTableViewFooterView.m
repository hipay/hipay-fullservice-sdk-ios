//
//  HPTSecurityCodeTableViewFooterView.m
//  Pods
//
//  Created by Jonathan TIRET on 12/11/2015.
//
//

#import "HPTSecurityCodeTableViewFooterView.h"
#import "HPTPaymentScreenUtils.h"
#import "HPTPaymentProduct.h"

@implementation HPTSecurityCodeTableViewFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _separatorInset = UIEdgeInsetsZero;

    securityCodeTextLabel.textColor = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0];

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
    
    if ([paymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        text = HPTLocalizedString(@"CARD_SECURITY_CODE_DESCRIPTION_AMEX");
        imageName = @"cvc_amex";
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeVisa] || [paymentProductCode isEqualToString:HPTPaymentProductCodeMasterCard]) {
        text = HPTLocalizedString(@"CARD_SECURITY_CODE_DESCRIPTION_DEFAULT");
        imageName = @"cvc_mv";
    }
    
    securityCodeTextLabel.text = text;
    
    if (imageName != nil) {
        cardImageView.image = [[UIImage imageNamed:imageName inBundle:HPTPaymentScreenViewsBundle() compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    else {
        cardImageView.image = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
