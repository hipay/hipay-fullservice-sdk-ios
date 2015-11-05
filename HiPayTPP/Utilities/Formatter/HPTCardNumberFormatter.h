//
//  CardNumberFormatter.h
//  Pods
//
//  Created by Jonathan TIRET on 05/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTCardNumberFormatter : NSObject

- (NSString *)digitsOnlyNumberForPlainTextNumber:(NSString *)plainTextNumber;

- (NSString *)paymentProductCodeForPlainTextNumber:(NSString *)plainTextNumber;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber reachesMaxLengthForPaymentProductCode:(NSString *)paymentProductCode;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber isValidForPaymentProductCode:(NSString *)paymentProductCode;

- (NSString *)formatPlainTextNumber:(NSString *)plainTextNumber forPaymentProductCode:(NSString *)paymentProductCode;

@end
