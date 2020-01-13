//
//  HPFSecurityCodeFormatter.h
//  Pods
//
//  Created by HiPay on 10/11/2015.
//
//

#import "HPFFormatter.h"

@interface HPFSecurityCodeFormatter : HPFFormatter

+ (instancetype)sharedFormatter;

- (NSString *)formattedCodeWithPlainText:(NSString *)plainText;
- (BOOL)codeIsCompleteForPlainText:(NSString *)plainText andPaymentProductCode:(NSString *)paymentProductCode;


@end
