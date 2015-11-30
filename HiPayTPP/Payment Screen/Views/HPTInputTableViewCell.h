//
//  HPTInputTableViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 30/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTFormTableViewCell.h"
#import "HPTFormattedTextField.h"

@interface HPTInputTableViewCell : HPTFormTableViewCell
{
    UIColor *defaultBackgroundColor;
    UIColor *defaultTextfieldColor;
    NSLayoutConstraint *inputLabelLeadingConstraint;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@end
