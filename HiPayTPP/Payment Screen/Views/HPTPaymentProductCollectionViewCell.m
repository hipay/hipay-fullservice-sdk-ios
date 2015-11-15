//
//  HPTPaymentProductCollectionViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPTPaymentProductCollectionViewCell.h"

@implementation HPTPaymentProductCollectionViewCell

- (void)setPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    _paymentProduct = paymentProduct;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _paymentProductButton = [[HPTPaymentProductButton alloc] initWithPaymentProduct:paymentProduct];
    [self.contentView addSubview:_paymentProductButton];
    [_paymentProductButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
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
