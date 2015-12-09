//
//  HPFSubmitTableViewCell.m
//  HiPayFullservice
//
//  Created by Jonathan Tiret on 29/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPFSubmitTableViewCell.h"

@implementation HPFSubmitTableViewCell

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

@end
