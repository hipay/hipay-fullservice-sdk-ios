//
//  PaymentButtonTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPTPaymentButtonTableViewCell.h"

@implementation HPTPaymentButtonTableViewCell

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate paymentButtonTableViewCellDidTouchButton:self];
    }
}

- (BOOL)isLoading
{
    return [spinner isAnimating];
}

- (void)setLoading:(BOOL)loading
{
    if (loading) {
        [spinner startAnimating];
    } else {
        [spinner stopAnimating];
    }
    
    button.hidden = loading;
}

@end
