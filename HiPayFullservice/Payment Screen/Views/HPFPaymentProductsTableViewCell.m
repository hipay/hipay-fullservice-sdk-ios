//
//  HPFPaymentProductsTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPFPaymentProductsTableViewCell.h"

@implementation HPFPaymentProductsTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.paymentProductsCollectionView.decelerationRate = 0.993;
}

@end
