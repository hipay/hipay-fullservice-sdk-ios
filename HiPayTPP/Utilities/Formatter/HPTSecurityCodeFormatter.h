//
//  HPTSecurityCodeFormatter.h
//  Pods
//
//  Created by Jonathan TIRET on 10/11/2015.
//
//

#import "HPTFormatter.h"
#import "HPTPaymentProduct.h"

@interface HPTSecurityCodeFormatter : HPTFormatter

+ (instancetype)sharedFormatter;

- (NSString *)formattedCodeWithPlainText:(NSString *)plainText;
- (BOOL)codeIsCompleteForPlainText:(NSString *)plainText andPaymentProductCode:(NSString *)paymentProductCode;


@end
