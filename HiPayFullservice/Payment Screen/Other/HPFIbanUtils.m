//
//  HPFIbanUtils.m
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 26/12/2018.
//

#import "HPFIbanUtils.h"

@implementation HPFIbanUtils

+(BOOL)isValidIBAN:(NSString *)iban
{
    NSDictionary* codeLengths = @{
                                  @"AD": @24, @"AE": @23, @"AT": @20, @"AZ": @28, @"BA": @20, @"BE": @16, @"BG": @22, @"BH": @22, @"BR": @29,
                                  @"BY": @28, @"CH": @21, @"CR": @21, @"CY": @28, @"CZ": @24, @"DE": @22, @"DK": @18, @"DO": @28, @"EE": @20,
                                  @"ES": @24, @"FI": @18, @"FO": @18, @"FR": @27, @"GB": @22, @"GI": @23, @"GL": @18, @"GR": @27, @"GT": @28,
                                  @"HR": @21, @"HU": @28, @"IE": @22, @"IL": @23, @"IS": @26, @"IT": @27, @"JO": @30, @"KW": @30, @"KZ": @20,
                                  @"LB": @28, @"LI": @21, @"LT": @20, @"LU": @20, @"LV": @21, @"MC": @27, @"MD": @24, @"ME": @22, @"MK": @19,
                                  @"MR": @27, @"MT": @31, @"MU": @30, @"NL": @18, @"NO": @15, @"PK": @24, @"PL": @28, @"PS": @29, @"PT": @25,
                                  @"QA": @29, @"RO": @24, @"RS": @22, @"SA": @24, @"SE": @24, @"SI": @19, @"SK": @24, @"SM": @27, @"TN": @24,
                                  @"TR": @26, @"VA": @22, @"VG": @24, @"XK": @20
                                  };
    
    iban = [[iban stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    
    NSString *regexString = [NSString stringWithFormat:@"[A-Z0-9]+"];
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    if (![predicate evaluateWithObject:iban]) {
        return NO;
    }
    
    if (iban.length <= 2) {
        return NO;
    }
    
    NSString *countryCode = [iban substringWithRange:NSMakeRange(0, 2)];
    NSNumber *ibanLength = codeLengths[countryCode];
    if (ibanLength.intValue != iban.length) {
        return NO;
    }
    
    int checkDigit = [iban substringWithRange:NSMakeRange(2, 2)].intValue;
    iban = [NSString stringWithFormat:@"%@%@",[iban substringWithRange:NSMakeRange(4, iban.length - 4)], [iban substringWithRange:NSMakeRange(0, 4)]] ;
    
    for (int i = 0; i < iban.length; i++) {
        unichar c = [iban characterAtIndex:i];
        if (c >= 'A' && c <= 'Z') {
            iban = [NSString stringWithFormat:@"%@%d%@", [iban substringWithRange:NSMakeRange(0, i)], (c - 'A' + 10),[iban substringWithRange:NSMakeRange(i+1, iban.length - i - 1)]];
        }
        
    }
    iban = [[iban substringWithRange:NSMakeRange(0, iban.length - 2)] stringByAppendingString:@"00"];
    
    while(true)
    {
        int iMin = (int)MIN(iban.length, 9);
        NSString* strPart = [iban substringWithRange:NSMakeRange(0, iMin)];
        int decnumber = strPart.intValue;
        if(decnumber < 97 || iban.length < 3)
            break;
        int del = decnumber % 97;
        iban =  [NSString stringWithFormat:@"%d%@", del, [iban substringFromIndex:iMin]];
    }
    int check = 98 - iban.intValue;
    
    return checkDigit == check;
}

@end
