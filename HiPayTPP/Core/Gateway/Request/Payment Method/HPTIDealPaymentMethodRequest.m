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


@end
