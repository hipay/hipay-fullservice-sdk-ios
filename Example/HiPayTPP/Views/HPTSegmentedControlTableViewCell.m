//
//  HPTSegmentedControlTableViewCell.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 29/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTSegmentedControlTableViewCell.h"

@implementation HPTSegmentedControlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UISegmentedControl alloc] init];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.accessoryView = [[UISegmentedControl alloc] init];
}

- (UISegmentedControl *)segmentedControl
{
    return (UISegmentedControl *)self.accessoryView;
}

@end
