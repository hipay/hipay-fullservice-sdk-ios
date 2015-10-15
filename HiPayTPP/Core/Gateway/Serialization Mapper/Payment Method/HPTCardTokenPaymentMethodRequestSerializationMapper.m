//
//  HPTCardTokenPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTCardTokenPaymentMethodRequestSerializationMapper.h"
#import "HPTCardTokenPaymentMethodRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPTAbstractSerializationMapper+Encode.h"

@implementation HPTCardTokenPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"cardToken"] forKey:@"cardtoken"];
    [result setNullableObject:[self getIntegerEnumValueForKey:@"eci"] forKey:@"eci"];
    [result setNullableObject:[self getIntegerEnumValueForKey:@"authenticationIndicator"] forKey:@"authentication_indicator"];

    return [NSDictionary dictionaryWithDictionary:result];
}

@end
