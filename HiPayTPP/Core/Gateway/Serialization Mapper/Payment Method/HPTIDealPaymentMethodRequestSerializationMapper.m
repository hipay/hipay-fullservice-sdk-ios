//
//  HPTIDealPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPTIDealPaymentMethodRequestSerializationMapper.h"
#import "HPTAbstractSerializationMapper+Encode.h"
#import "NSMutableDictionary+Serialization.h"

@implementation HPTIDealPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"issuerBankId"] forKey:@"issuer_bank_id"];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
