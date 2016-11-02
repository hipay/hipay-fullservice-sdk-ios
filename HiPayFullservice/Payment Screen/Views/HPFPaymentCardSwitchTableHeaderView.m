//
//  HPFPaymentCardSwitchTableHeaderView.m
//  Pods
//
//  Created by Nicolas FILLION on 26/10/2016.
//
//

#import "HPFPaymentCardSwitchTableHeaderView.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFPaymentCardSwitchTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    saveTextLabel.textColor = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0];
    saveTextLabel.text = HPFLocalizedString(@"CARD_SWITCH_STORE_DESCRIPTION");
}

- (BOOL)isEnabled
{
    return [self.saveSwitch isEnabled];
}

- (void)setEnabled:(BOOL)enabled
{
    self.saveSwitch.enabled = enabled;
}

@end
