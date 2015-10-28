//
//  HPTPaymentProductButton.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentProduct.h"

@interface HPTPaymentProductButton : UIButton

@property (nonatomic, readonly) NSString *paymentProductCode;

- (instancetype)initWithPaymentProductCode:(NSString *)paymentProductCode;

@end