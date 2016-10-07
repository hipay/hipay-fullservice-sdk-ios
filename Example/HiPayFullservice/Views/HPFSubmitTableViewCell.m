//
//  HPFSubmitTableViewCell.m
//  HiPayFullservice
//
//  Created by Jonathan Tiret on 29/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPFSubmitTableViewCell.h"
//#import "HPFPaymentScreenUtils.h"

@implementation HPFSubmitTableViewCell

- (void)awakeFromNib
{
    [button setTitle:NSLocalizedString(@"FORM_SUBMIT", nil) forState:UIControlStateNormal];
    //[button setTitle:HPFLocalizedString(@"PAY_BUTTON_TITLE") forState:UIControlStateNormal];
}

- (IBAction)buttonTouched:(id)sender {
    if (self.delegate != nil) {
        [self.delegate submitTableViewCellDidTouchButton:self];
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

- (BOOL)isEnabled
{
    return button.enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    button.enabled = enabled;
}

/*
- (void)awakeFromNib
{
    [button setTitle:HPFLocalizedString(@"PAY_BUTTON_TITLE") forState:UIControlStateNormal];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.textLabel.font = [UIFont boldSystemFontOfSize:self.textLabel.font.pointSize];
        self.textLabel.textColor = self.tintColor;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if ([UIView appearance].tintColor != nil) {
        self.textLabel.textColor = [UIView appearance].tintColor;
    }
    else {
        self.textLabel.textColor = self.tintColor;
    }
}
*/

@end



