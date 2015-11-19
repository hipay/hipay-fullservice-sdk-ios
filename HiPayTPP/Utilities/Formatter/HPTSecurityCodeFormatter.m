//
//  HPTSecurityCodeFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 10/11/2015.
//
//

#import "HPTSecurityCodeFormatter.h"
#import "HPTPaymentProduct.h"

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
    NSString *digits = [self digitsOnlyFromPlainText:plainText];
    HPTSecurityCodeType type = [HPTPaymentProduct securityCodeTypeForPaymentProductCode:paymentProductCode];
    
    if (type == HPTSecurityCodeTypeCVV) {
        
        return digits.length >= 3;
    }
    
    else if (type == HPTSecurityCodeTypeCID) {
        
        return digits.length >= 4;
    }
    
    return YES;
}

@end
