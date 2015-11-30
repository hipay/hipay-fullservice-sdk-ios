//
//  HPTIDealPaymentMethodRequest.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPTIDealPaymentMethodRequest.h"

@implementation HPTIDealPaymentMethodRequest

+ (instancetype)iDealPaymentMethodRequestWithIssuerBankId:(NSString *)issuerBankId
{
    HPTIDealPaymentMethodRequest *result = [[HPTIDealPaymentMethodRequest alloc] init];
    
    result.issuerBankId = issuerBankId;
    
    return result;
}

+ (NSDictionary *)issuerBanks
{
    return @{
             @"ABNANL2A": @"ABN AMRO",
             @"INGBNL2A": @"ING",
             @"RABONL2U": @"Rabobank",
             @"SNSBNL2A": @"SNS Bank",
             @"ASNBNL21": @"ASN Bank",
             @"FRBKNL2L": @"Friesland Bank",
             @"KNABNL2H": @"Knab",
             @"RBRBNL21": @"SNS Regio Bank",
             @"TRIONL2U": @"Triodos bank",
             @"FVLBNL22": @"Van Lanschot"
             };
}

@end
