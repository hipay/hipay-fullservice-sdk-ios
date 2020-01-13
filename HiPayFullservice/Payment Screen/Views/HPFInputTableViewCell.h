//
//  HPFInputTableViewCell.h
//  Pods
//
//  Created by HiPay on 30/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFFormTableViewCell.h"
#import "HPFFormattedTextField.h"

@interface HPFInputTableViewCell : HPFFormTableViewCell
{
    UIColor *defaultBackgroundColor;
    UIColor *defaultTextfieldColor;
    NSLayoutConstraint *inputLabelLeadingConstraint;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@end
