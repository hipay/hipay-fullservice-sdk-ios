//
//  HPTSwitchTableViewCell.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 28/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTSwitchTableViewCell.h"

@implementation HPTSwitchTableViewCell

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
