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

- (BOOL)isValid
{
    return YES;
}

@end
