//
//  CardNumberFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 05/11/2015.
//
//

#import "HPTCardNumberFormatter.h"
#import "HPTCardNumberFormatter_Private.h"
#import "HPTPaymentProduct.h"

@implementation HPTCardNumberFormatter

- (NSString *)digitsOnlyNumberForPlainTextNumber:(NSString *)plainTextNumber
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[plainTextNumber componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

- (NSString *)paymentProductCodeForPlainTextNumber:(NSString *)plainTextNumber
{
    NSString *digits = [self digitsOnlyNumberForPlainTextNumber:plainTextNumber];
    
    NSDictionary *paymentProductCodeFormats = @{
                                                HPTPaymentProductCodeVisa: @"^4",
                                                HPTPaymentProductCodeMasterCard: @"^((5[1-5])|2221|2720)",
                                                HPTPaymentProductCodeDiners: @"^((30[0-5])|2014|2149|309|36|38|39)",
                                                HPTPaymentProductCodeMasterCard: @"^((5[1-5])|2221|2720)",
                                                HPTPaymentProductCodeAmericanExpress: @"^(34|37)",
                                                HPTPaymentProductCodeMaestro: @"^(50|(5[6-9])|(6[0-9]))",

                                               };
    
    for (NSString *paymentProductCode in paymentProductCodeFormats.allKeys) {
        
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:paymentProductCodeFormats[paymentProductCode] options:0 error:nil];
        
        if ([expression numberOfMatchesInString:digits options:0 range:NSMakeRange(0, [digits length])]) {
            return paymentProductCode;
        }
    }

    return nil;
}

@end
