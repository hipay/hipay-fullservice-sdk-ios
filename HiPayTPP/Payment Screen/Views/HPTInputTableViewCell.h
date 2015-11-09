//
//  HPTInputTableViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 30/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTFormTableViewCell.h"

@interface HPTInputTableViewCell : HPTFormTableViewCell
{
    UIColor *defaultBackgroundColor;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@end
