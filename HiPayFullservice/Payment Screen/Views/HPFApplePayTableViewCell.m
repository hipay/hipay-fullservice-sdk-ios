//
//  HPFApplePayTableViewCell.m
//  Pods
//
//  Created by Nicolas FILLION on 14/06/2017.
//
//

#import "HPFApplePayTableViewCell.h"

@implementation HPFApplePayTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    PKPaymentButtonType type;
    
    NSArray *array = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:array])
    {
        type = PKPaymentButtonTypeBuy;
        
    } else {
        
        if (@available(iOS 9.0, *)) {
            type = PKPaymentButtonTypeSetUp;
        } else {
            // Fallback on earlier versions
            type = PKPaymentButtonTypeBuy;
        }
    }

    PKPaymentButton *button;
    
    if (@available(iOS 9.0, *)) {
        button = [[PKPaymentButton alloc] initWithPaymentButtonType:type paymentButtonStyle:PKPaymentButtonStyleWhiteOutline];
    } else {
        
        button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleWhiteOutline];
    }
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];

    [[self contentView] addSubview:button];

    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.contentView addConstraint:c1];

    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:c2];

}

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate applePayButtonTableViewCellDidTouchButton:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
