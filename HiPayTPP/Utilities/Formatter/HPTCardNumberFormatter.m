//
//  CardNumberFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 05/11/2015.
//
//

#import "HPTCardNumberFormatter.h"
#import "HPTCardNumberFormatter_Private.h"
#import "HPTFormatter_Private.h"
#import "HPTPaymentProduct.h"

HPTCardNumberFormatter *HPTCardNumberFormatterSharedInstance = nil;

@implementation HPTCardNumberFormatter

+ (instancetype)sharedFormatter
{
    if (HPTCardNumberFormatterSharedInstance == nil) {
        HPTCardNumberFormatterSharedInstance = [[HPTCardNumberFormatter alloc] init];
    }
    
    return HPTCardNumberFormatterSharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSBundle *utilitiesBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HPTUtilitiesResources" ofType:@"bundle"]];
        
        NSString *filePath = [utilitiesBundle pathForResource:@"card-numbers-info" ofType:@"plist"];
        NSDictionary *cardNumbersInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        paymentProductsInfo = [self paymentProductInfoWithCardNumbersInfo:cardNumbersInfo];
        
    }
    return self;
}

- (NSDictionary *)paymentProductInfoWithCardNumbersInfo:(NSDictionary *)cardNumbersInfo
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSString *paymentProduct in cardNumbersInfo.allKeys) {
        
        NSDictionary *rawInfo = cardNumbersInfo[paymentProduct];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        [info setObject:rawInfo[@"format"] forKey:@"format"];
        [info setObject:[self indexSetForStringRanges:rawInfo[@"lengths"]] forKey:@"lengths"];
        [info setObject:[self indexSetForStringRanges:rawInfo[@"ranges"]] forKey:@"ranges"];
        
        [result setObject:info forKey:paymentProduct];
    }
    
    return result;

}

- (NSIndexSet *)indexSetForStringRanges:(NSArray *)stringRanges
{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    for (NSString *stringRange in stringRanges) {
        [indexSet addIndexesInRange:NSRangeFromString(stringRange)];
    }
    
    return indexSet;
}

- (NSArray *)paymentProductCodesForPlainTextNumber:(NSString *)plainTextNumber
{
    NSString *digits = [self digitsOnlyFromPlainText:plainTextNumber];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *paymentProductCode in paymentProductsInfo.allKeys) {
        
        NSIndexSet *ranges = paymentProductsInfo[paymentProductCode][@"ranges"];
            
        NSUInteger indexFound = [ranges indexPassingTest:^BOOL(NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *stringIndex = [NSString stringWithFormat:@"%lu", (unsigned long)idx];
            NSString *digitsSubstring = digits;
            
            if (digitsSubstring.length > stringIndex.length) {
                digitsSubstring = [digits substringToIndex:stringIndex.length];
            } else if (digitsSubstring.length < stringIndex.length) {
                stringIndex = [stringIndex substringToIndex:digitsSubstring.length];
            }
            
            BOOL result = [stringIndex containsString:digitsSubstring];
            
            *stop = result;
            
            return result;
        }];
        
        if (indexFound != NSNotFound) {
            [result addObject:paymentProductCode];
        }
    }

    return result;
}

- (BOOL)plainTextNumber:(NSString *)plainTextNumber reachesMaxLengthForPaymentProductCode:(NSString *)paymentProductCode
{
    NSUInteger inputLength = [self digitsOnlyFromPlainText:plainTextNumber].length;
    
    NSIndexSet *lengthValues = paymentProductsInfo[paymentProductCode][@"lengths"];
    
    return (lengthValues.count > 0) && ([lengthValues indexGreaterThanIndex:inputLength] == NSNotFound);
}

- (BOOL)plainTextNumber:(NSString *)plainTextNumber hasValidLengthForPaymentProductCode:(NSString *)paymentProductCode
{
    return [paymentProductsInfo[paymentProductCode][@"lengths"] containsIndex:[self digitsOnlyFromPlainText:plainTextNumber].length];
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
    NSString *digits = [self digitsOnlyFromPlainText:plainTextNumber];
    
    BOOL lengthValid = [self plainTextNumber:plainTextNumber hasValidLengthForPaymentProductCode:paymentProductCode];
    BOOL BINValid = [[self paymentProductCodesForPlainTextNumber:plainTextNumber] containsObject:paymentProductCode];
    BOOL luhnCheck = [self luhnCheck:digits];
    
    return lengthValid && BINValid && luhnCheck;
}

- (NSAttributedString *)formatPlainTextNumber:(NSString *)plainTextNumber forPaymentProductCode:(NSString *)paymentProductCode
{
    NSString *digits = [self digitsOnlyFromPlainText:plainTextNumber];
    
    NSArray *groups = paymentProductsInfo[paymentProductCode][@"format"];
    
    if (groups != nil) {
        
        NSMutableAttributedString *formattedNumber = [[NSMutableAttributedString alloc] initWithString:digits];
        NSUInteger currentPosition = 0;

        for (NSNumber *numberOfDigits in groups) {
            NSUInteger newPosition = (currentPosition + numberOfDigits.unsignedIntegerValue - 1);
            if (formattedNumber.length > newPosition) {
                [formattedNumber addAttribute:NSKernAttributeName value:@7 range:NSMakeRange(newPosition, 1)];

                currentPosition = newPosition + 1;
            } else {
                break;
            }
        }
        
        return formattedNumber;
    }
    
    return [[NSAttributedString alloc] initWithString:digits];
}

@end
