//
//  HPTFormTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 06/11/2015.
//
//

#import "HPTFormTableViewCell.h"

@implementation HPTFormTableViewCell

- (void)awakeFromNib
{
    defaultTextLabelColor = self.textLabel.textColor;
}

- (void)setIncorrectInput:(BOOL)incorrectInput
{
    _incorrectInput = incorrectInput;
    
    if (_incorrectInput) {
        self.textLabel.textColor = [UIColor redColor];
    } else {
        self.textLabel.textColor = defaultTextLabelColor;
    }
}

- (BOOL)isValid
{
    return YES;
}

@end
