//
//  HPTInputTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 30/10/2015.
//
//

#import "HPTInputTableViewCell.h"

@implementation HPTInputTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    defaultBackgroundColor = self.contentView.backgroundColor;
}

- (void)setIncorrectInput:(BOOL)incorrectInput
{
    [super setIncorrectInput:incorrectInput];
    
    if (self.incorrectInput) {
        self.contentView.backgroundColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:.15];
    } else {
        self.contentView.backgroundColor = defaultBackgroundColor;
    }
}

@end
