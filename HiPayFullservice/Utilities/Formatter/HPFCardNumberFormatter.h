//
//  CardNumberFormatter.h
//  Pods
//
//  Created by HiPay on 05/11/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFFormatter.h"

@interface HPFCardNumberFormatter : HPFFormatter
{
    NSDictionary *paymentProductsInfo;
}

+ (instancetype)sharedFormatter;

- (NSSet *)paymentProductCodesForPlainTextNumber:(NSString *)plainTextNumber;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber isInRangeForPaymentProductCode:(NSString *)paymentProductCode;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber reachesMaxLengthForPaymentProductCode:(NSString *)paymentProductCode;

- (BOOL)plainTextNumber:(NSString *)plainTextNumber isValidForPaymentProductCode:(NSString *)paymentProductCode;

- (NSAttributedString *)formatPlainTextNumber:(NSString *)plainTextNumber forPaymentProductCode:(NSString *)paymentProductCode;

@end
