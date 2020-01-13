//
//  HPFPaymentCardTableViewCell.m
//  Pods
//
//  Created by HiPay on 27/10/2016.
//
//

#import "HPFPaymentCardTableViewCell.h"

@implementation HPFPaymentCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)removeDependency {

    _dependencyConstraint.active = NO;
}

- (void)addDependency {

    _dependencyConstraint.active = YES;
}

@end
