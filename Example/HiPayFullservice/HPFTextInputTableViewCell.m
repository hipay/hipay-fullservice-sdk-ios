//
//  HPFTextInputTableViewCell.m
//  HiPayFullservice_Example
//
//  Created by HiPay on 06/12/2018.
//  Copyright © 2018 HiPay. All rights reserved.
//

#import "HPFTextInputTableViewCell.h"

@interface HPFTextInputTableViewCell() <UITextFieldDelegate>

@end

@implementation HPFTextInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textfield.delegate = self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textfield.keyboardType == UIKeyboardTypeNumberPad) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(doneTapped:)];
        
        
        [toolbar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
        self.textfield.inputAccessoryView = toolbar;
    }
}

-(void)doneTapped:(id)sender {
    [self.textfield endEditing:YES];
}

@end
