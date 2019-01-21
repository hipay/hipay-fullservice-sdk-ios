//
//  HPFSepaDirectDebitPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by Morgan BAUMARD on 21/12/2018.
//

#import "HPFSepaDirectDebitPaymentMethodRequestSerializationMapper.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "NSMutableDictionary+Serialization.h"

@implementation HPFSepaDirectDebitPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"firstname"] forKey:@"firstname"];
    [result setNullableObject:[self getStringForKey:@"lastname"] forKey:@"lastname"];
    [result setNullableObject:[self getStringForKey:@"iban"] forKey:@"iban"];
    [result setNullableObject:[self getIntegerForKey:@"recurringPayment"] forKey:@"recurring_payment"];

    return [NSDictionary dictionaryWithDictionary:result];
}

@end
