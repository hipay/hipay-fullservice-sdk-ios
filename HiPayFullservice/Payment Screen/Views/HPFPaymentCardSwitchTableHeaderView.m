//
//  HPFPaymentCardSwitchTableHeaderView.m
//  Pods
//
//  Created by HiPay on 26/10/2016.
//
//

#import "HPFPaymentCardSwitchTableHeaderView.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFPaymentCardSwitchTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    saveTextLabel.text = HPFLocalizedString(@"HPF_CARD_SWITCH_STORE_DESCRIPTION");
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
