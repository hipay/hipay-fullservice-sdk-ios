//
//  HPFCardNumberTextField.h
//  Pods
//
//  Created by Jonathan TIRET on 04/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFCardNumberFormatter.h"
#import "HPFFormTableViewCell.h"
#import "HPFFormattedTextField.h"

@interface HPFCardNumberTextField : HPFFormattedTextField

@property (nonatomic, readonly) NSSet *paymentProductCodes;

@end
