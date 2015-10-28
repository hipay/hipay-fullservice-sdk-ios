//
//  PaymentButtonTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPTPaymentButtonTableViewCell.h"

@implementation HPTPaymentButtonTableViewCell

- (void)awakeFromNib
{
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouched:(id)button
{
    if (self.delegate != nil) {
        [self.delegate paymentButtonTableViewCellDidTouchButton:self];
    }
}

@end
