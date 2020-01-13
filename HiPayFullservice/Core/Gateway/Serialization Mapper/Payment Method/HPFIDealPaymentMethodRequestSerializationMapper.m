//
//  HPFIDealPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by HiPay on 01/11/2015.
//
//

#import "HPFIDealPaymentMethodRequestSerializationMapper.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "NSMutableDictionary+Serialization.h"

@implementation HPFIDealPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"issuerBankId"] forKey:@"issuer_bank_id"];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
