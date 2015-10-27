//
//  HPTPaymentProductCollectionViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPTPaymentProductCollectionViewCell.h"
#import "HPTPaymentProductButton.h"

@implementation HPTPaymentProductCollectionViewCell

- (void)setPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    _paymentProduct = paymentProduct;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:[[HPTPaymentProductButton alloc] initWithPaymentProductCode:paymentProduct.code]];
}

@end
