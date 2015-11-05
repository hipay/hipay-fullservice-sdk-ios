//
//  HPTCardNumberTextField.m
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import "HPTCardNumberTextField.h"

@implementation HPTCardNumberTextField

- (void)awakeFromNib
{
    [super setDelegate:self];
    _storedValue = [NSMutableString string];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    finalDelegate = delegate;
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

- (NSString *) formatCurrencyValue:(double)value
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setCurrencySymbol:@"$"];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *c = [NSNumber numberWithFloat:value];
    return [numberFormatter stringFromNumber:c];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [_storedValue appendString:string];
    NSString *newAmount = [self formatCurrencyValue:([_storedValue doubleValue]/100)];
    
    [textField setText:[NSString stringWithFormat:@"%@",newAmount]];
    return NO;
}

@end
