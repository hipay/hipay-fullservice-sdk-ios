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
    
    NSUInteger indexFound = [self.contentView.constraints indexOfObjectPassingTest:^BOOL(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
     
        BOOL result = (constraint.firstItem == self.inputLabel) && (constraint.firstAttribute == NSLayoutAttributeLeading);
        
        *stop = result;
        return result;
        
    }];
    
    if (indexFound != NSNotFound) {
        inputLabelLeadingConstraint = self.contentView.constraints[indexFound];
    }

    defaultBackgroundColor = self.contentView.backgroundColor;
    defaultTextfieldColor = self.textField.textColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    inputLabelLeadingConstraint.constant = self.textLabel.frame.origin.x;
}

- (void)setIncorrectInput:(BOOL)incorrectInput
{
    [super setIncorrectInput:incorrectInput];
    
    if (self.incorrectInput) {
        self.contentView.backgroundColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:.15];
        self.textField.textColor = [UIColor redColor];
    } else {
        self.contentView.backgroundColor = defaultBackgroundColor;
        self.textField.textColor = defaultTextfieldColor;
    }
}

@end
