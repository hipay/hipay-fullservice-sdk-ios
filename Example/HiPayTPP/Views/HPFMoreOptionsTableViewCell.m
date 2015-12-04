//
//  HPFMoreOptionsTableViewCell.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 29/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPFMoreOptionsTableViewCell.h"

@implementation HPFMoreOptionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
