//
//  HPTPaymentProductsTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPTPaymentProductsTableViewCell.h"

@implementation HPTPaymentProductsTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.paymentProductsCollectionView.decelerationRate = 0.993;
}

@end
