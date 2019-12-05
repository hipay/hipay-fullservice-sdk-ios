//
//  HPFStepperTableViewCell.m
//  HiPayFullservice
//
//  Created by HiPay on 29/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import "HPFStepperTableViewCell.h"

@implementation HPFStepperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UIStepper alloc] init];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.accessoryView = [[UIStepper alloc] init];
}

- (UIStepper *)stepper
{
    return (UIStepper *)self.accessoryView;
}

@end
