//
//  HPFPaymentProductCollectionViewCell.m
//  Pods
//
//  Created by HiPay on 26/10/2015.
//
//

#import "HPFPaymentProductCollectionViewCell.h"

@implementation HPFPaymentProductCollectionViewCell

- (void)setPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    _paymentProduct = paymentProduct;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _paymentProductButton = [[HPFPaymentProductButton alloc] initWithPaymentProduct:paymentProduct];
    [self.contentView addSubview:_paymentProductButton];
    [_paymentProductButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];

    _paymentProductButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_paymentProductButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_paymentProductButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60.0]];
    
}

- (void)buttonTouched:(id)button
{
    if (self.delegate != nil) {
        [self.delegate paymentProductCollectionViewCellDidTouchButton:self];
    }
}

- (BOOL)isHighlighted
{
    return self.paymentProductButton.selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    self.paymentProductButton.selected = highlighted;
}

@end
