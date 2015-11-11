//
//  HPTSecurityCodeFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 10/11/2015.
//
//

#import "HPTSecurityCodeFormatter.h"

@implementation HPTSecurityCodeFormatter

+ (instancetype)sharedFormatter
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)formattedCodeWithPlainText:(NSString *)plainText
{
    return [self digitsOnlyFromPlainText:plainText];
}

- (BOOL)codeIsCompleteForPlainText:(NSString *)plainText andPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPTPaymentProductCodeVisa] || [paymentProductCode isEqualToString:HPTPaymentProductCodeMasterCard]) {
        
        return plainText.length >= 3;
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        
        return plainText.length >= 4;
    }
    
    return plainText;
}

@end
