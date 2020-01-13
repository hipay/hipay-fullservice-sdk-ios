//
//  HPFSwitchInfosTableViewCell.m
//  HiPayFullservice
//
//  Created by HiPay on 01/08/2017.
//  Copyright © 2017 HiPay. All rights reserved.
//

#import "HPFSwitchInfosTableViewCell.h"

@implementation HPFSwitchInfosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.accessoryView = [[UISwitch alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)isEnabled
{
    return [self.switchControl isEnabled];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.accessoryView = [[UISwitch alloc] init];
}


- (void)setEnabled:(BOOL)enabled
{
    self.switchControl.enabled = enabled;
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}

@end
