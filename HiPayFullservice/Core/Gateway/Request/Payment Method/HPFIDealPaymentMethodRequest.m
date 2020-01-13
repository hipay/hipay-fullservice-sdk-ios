//
//  HPFIDealPaymentMethodRequest.m
//  Pods
//
//  Created by HiPay on 01/11/2015.
//
//

#import "HPFIDealPaymentMethodRequest.h"

@implementation HPFIDealPaymentMethodRequest

+ (instancetype)iDealPaymentMethodRequestWithIssuerBankId:(NSString *)issuerBankId
{
    HPFIDealPaymentMethodRequest *result = [[HPFIDealPaymentMethodRequest alloc] init];
    
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
