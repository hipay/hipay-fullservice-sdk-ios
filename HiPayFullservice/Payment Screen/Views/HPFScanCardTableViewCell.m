//
//  HPFScanCardTableViewCell.m
//  Pods
//
//  Created by Nicolas FILLION on 16/02/2017.
//
//

#import "HPFScanCardTableViewCell.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFScanCardTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [button setTitle:HPFLocalizedString(@"SCAN_PAYMENT_CARD") forState:UIControlStateNormal];
}

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate scanCardTableViewCellDidTouchButton:self];
    }
}

- (BOOL)isEnabled
{
    return button.enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    button.enabled = enabled;
}

@end
