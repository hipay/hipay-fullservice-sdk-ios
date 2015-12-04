//
//  HPFFormattedTextField.h
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface HPFFormattedTextField : UITextField <UITextFieldDelegate>
{
    id<UITextFieldDelegate> finalDelegate;
}

@property (nonatomic, readonly, getter=isValid) BOOL valid;
@property (nonatomic, readonly, getter=isCompleted) BOOL completed;

@end
