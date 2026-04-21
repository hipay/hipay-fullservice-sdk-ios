//
//  HPFSecurityCodeFormatter.m
//  Pods
//
//  Created by HiPay on 10/11/2015.
//
//

#import "HPFSecurityCodeFormatter.h"
#import "HPFPaymentProduct.h"

@implementation HPFSecurityCodeFormatter

+ (instancetype)sharedFormatter {
  static dispatch_once_t once;
  static id sharedInstance;

  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (NSString *)formattedCodeWithPlainText:(NSString *)plainText {
  return [self digitsOnlyFromPlainText:plainText];
}

- (BOOL)codeIsCompleteForPlainText:(NSString *)plainText
             andPaymentProductCode:(NSString *)paymentProductCode {
  NSString *digits = [self digitsOnlyFromPlainText:plainText];
  HPFSecurityCodeType type = [HPFPaymentProduct
      securityCodeTypeForPaymentProductCode:paymentProductCode];

  if (type == HPFSecurityCodeTypeCVV) {

    return digits.length >= 3;
  }

  else if (type == HPFSecurityCodeTypeCID) {

    return digits.length >= 4;
  }

  return digits.length >= 3;
}

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString *__autoreleasing _Nullable *)newString
            errorDescription:(NSString *__autoreleasing _Nullable *)error {

  if (partialString.length > 4) {
    return NO;
  }

  NSCharacterSet *nonDigits =
      [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  if ([partialString rangeOfCharacterFromSet:nonDigits].location !=
      NSNotFound) {
    return NO;
  }

  return YES;
}

@end
