//
//  HPFSecurityCodeTableViewFooterView.m
//  Pods
//
//  Created by Jonathan TIRET on 12/11/2015.
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
    
    if ([paymentProductCode isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
        text = HPFLocalizedString(@"CARD_SECURITY_CODE_DESCRIPTION_CID");
        imageName = @"cvc_amex";
    }
    
    else {
        text = HPFLocalizedString(@"CARD_SECURITY_CODE_DESCRIPTION_CVV");
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
