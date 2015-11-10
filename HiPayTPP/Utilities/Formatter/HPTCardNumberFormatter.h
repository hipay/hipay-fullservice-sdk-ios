//
//  CardNumberFormatter.h
//  Pods
//
//  Created by Jonathan TIRET on 05/11/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTFormatter.h"

@interface HPTCardNumberFormatter : HPTFormatter
{
    NSDictionary *paymentProductsInfo;
}

+ (instancetype)sharedFormatter;

- (NSArray *)paymentProductCodesForPlainTextNumber:(NSString *)plainTextNumber;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber reachesMaxLengthForPaymentProductCode:(NSString *)paymentProductCode;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber isValidForPaymentProductCode:(NSString *)paymentProductCode;

- (NSAttributedString *)formatPlainTextNumber:(NSString *)plainTextNumber forPaymentProductCode:(NSString *)paymentProductCode;

@end
