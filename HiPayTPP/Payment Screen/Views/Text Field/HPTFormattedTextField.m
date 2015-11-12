//
//  HPTFormattedTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTFormattedTextField.h"

@implementation HPTFormattedTextField

- (void)awakeFromNib
{
    [super setDelegate:self];
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(id)sender
{
    // Empty implementation
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [finalDelegate textFieldShouldClear:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [finalDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [finalDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([finalDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [finalDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([finalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [finalDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([finalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [finalDelegate textFieldDidEndEditing:textField];
    }
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    finalDelegate = delegate;
}

@end
