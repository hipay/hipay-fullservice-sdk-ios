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

- (NSIndexSet *)cardNumberLengthForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPTPaymentProductCodeVisa]) {
        return [NSIndexSet indexSetWithIndex:16];
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeMasterCard]) {
        return [NSIndexSet indexSetWithIndex:16];
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeAmericanExpress]) {
        return [NSIndexSet indexSetWithIndex:15];
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeMaestro]) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(12, 7)];
    }
    
    else if ([paymentProductCode isEqualToString:HPTPaymentProductCodeDiners]) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(14, 2)];
    }
    
    return [NSIndexSet indexSet];
}

- (BOOL)plainTextNumber:(NSString *)plainTextNumber reachesMaxLengthForPaymentProductCode:(NSString *)paymentProductCode
{
    NSUInteger inputLength = [self digitsOnlyNumberForPlainTextNumber:plainTextNumber].length;
    
    NSIndexSet *lengthValues = [self cardNumberLengthForPaymentProductCode:paymentProductCode];
    
    return (lengthValues.count > 0) && ([lengthValues indexGreaterThanIndex:inputLength] == NSNotFound);
}

- (BOOL)plainTextNumber:(NSString *)plainTextNumber hasValidLengthForPaymentProductCode:(NSString *)paymentProductCode
{
    return [[self cardNumberLengthForPaymentProductCode:paymentProductCode] containsIndex:plainTextNumber.length];
}

- (NSArray *)charArrayFromString:(NSString *)string {
    
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[string length]];
    
    for (int i=0; i < [string length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%C", [string characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    return characters;
}

- (BOOL)luhnCheck:(NSString *)stringToTest
{
    // http://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Objective-C
    
    NSArray *stringAsChars = [self charArrayFromString:stringToTest];
    
    BOOL isOdd = YES;
    NSInteger oddSum = 0;
    NSInteger evenSum = 0;
    
    for (NSInteger i = stringToTest.length - 1; i >= 0; i--) {
        
        NSInteger digit = [(NSString *)stringAsChars[i] integerValue];
        
        if (isOdd) {
            oddSum += digit;
        } else {
            evenSum += digit/5. + (2 * digit) % 10;
        }
        
        isOdd = !isOdd;				 
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

- (BOOL)plainTextNumber:(NSString *)plainTextNumber isValidForPaymentProductCode:(NSString *)paymentProductCode
{
    NSString *digits = [self digitsOnlyNumberForPlainTextNumber:plainTextNumber];
    
    BOOL lengthValid = [self plainTextNumber:plainTextNumber hasValidLengthForPaymentProductCode:paymentProductCode];
    BOOL BINValid = [[self paymentProductCodeForPlainTextNumber:plainTextNumber] isEqualToString:paymentProductCode];
    BOOL luhnCheck = [self luhnCheck:digits];
    
    return lengthValid && BINValid && luhnCheck;
}

- (NSString *)formatPlainTextNumber:(NSString *)plainTextNumber forPaymentProductCode:(NSString *)paymentProductCode
{
    NSString *digits = [self digitsOnlyNumberForPlainTextNumber:plainTextNumber];
    
    NSDictionary *groupingInfo = @{
                                   HPTPaymentProductCodeMasterCard: @[@4, @4, @4],
                                   HPTPaymentProductCodeVisa: @[@4, @4, @4],
                                   HPTPaymentProductCodeMaestro: @[@4, @4, @4, @4],
                                   HPTPaymentProductCodeAmericanExpress: @[@4, @6],
                                   HPTPaymentProductCodeDiners: @[@4, @6],
                                   };
    
    NSArray *groups = groupingInfo[paymentProductCode];
    
    if (groups != nil) {
        
        NSMutableString *formattedNumber = [NSMutableString stringWithString:digits];
        NSUInteger currentPosition = 0;

        for (NSNumber *numberOfDigits in groups) {
            NSUInteger newPosition = (currentPosition + numberOfDigits.unsignedIntegerValue);
            if (formattedNumber.length > newPosition) {
                [formattedNumber insertString:@" " atIndex:newPosition];
                currentPosition = newPosition + 1;
            } else {
                break;
            }
        }
        
        return formattedNumber;
    }
    
    return digits;
}

@end
