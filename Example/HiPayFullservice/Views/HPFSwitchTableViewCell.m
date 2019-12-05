//
//  HPFSwitchTableViewCell.m
//  HiPayFullservice
//
//  Created by HiPay on 28/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import "HPFSwitchTableViewCell.h"

@implementation HPFSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UISwitch alloc] init];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.accessoryView = [[UISwitch alloc] init];
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}

@end
