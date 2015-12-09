//
//  HPFCardNumberFormatter_Private.h
//  Pods
//
//  Created by Jonathan TIRET on 05/11/2015.
//
//

#import "HPFCardNumberFormatter.h"

@interface HPFCardNumberFormatter ()

- (BOOL)luhnCheck:(NSString *)stringToTest;
- (BOOL)plainTextNumber:(NSString *)plainTextNumber hasValidLengthForPaymentProductCode:(NSString *)paymentProductCode;

@end
