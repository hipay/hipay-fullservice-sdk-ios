//
//  HPTCardNumberTextField.h
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTCardNumberFormatter.h"
#import "HPTFormTableViewCell.h"

@interface HPTCardNumberTextField : UITextField <UITextFieldDelegate>
{
    id<UITextFieldDelegate> finalDelegate;
    HPTCardNumberFormatter *formatter;
}

@property (nonatomic, readonly) NSArray *paymentProductCodes;
@property (nonatomic, readonly, getter=isValid) BOOL valid;
@property (nonatomic, readonly, getter=isCompleted) BOOL completed;

@end
