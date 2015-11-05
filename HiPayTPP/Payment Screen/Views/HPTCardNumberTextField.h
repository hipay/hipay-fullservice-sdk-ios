//
//  HPTCardNumberTextField.h
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface HPTCardNumberTextField : UITextField <UITextFieldDelegate>
{
    id<UITextFieldDelegate> finalDelegate;
}

@property (nonatomic) NSMutableString *storedValue;

@end
