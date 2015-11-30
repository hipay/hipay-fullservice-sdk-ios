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
#import "HPTFormattedTextField.h"

@interface HPTCardNumberTextField : HPTFormattedTextField

@property (nonatomic, readonly) NSSet *paymentProductCodes;

@end
