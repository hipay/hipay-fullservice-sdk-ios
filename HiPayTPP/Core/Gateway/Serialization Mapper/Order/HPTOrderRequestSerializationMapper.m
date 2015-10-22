//
//  HPTOrderRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRequestSerializationMapper.h"
#import "HPTOrderRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPTAbstractSerializationMapper+Encode.h"
#import "HPTOrderRelatedRequestSerializationMapper_Private.h"
#import "HPTCardTokenPaymentMethodRequestSerializationMapper.h"

@implementation HPTOrderRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];
    
    [result setNullableObject:[self getStringForKey:@"paymentProduct"] forKey:@"payment_product"];
    
    [result mergeDictionary:[self paymentMethodSerializedRequest] withPrefix:nil];
    
    return [self createImmutableDictionary:result];
}

- (NSDictionary *)paymentMethodSerializedRequest
{
    HPTAbstractPaymentMethodRequest *paymentMethodRequest = [self.request valueForKey:@"paymentMethod"];

    if ([paymentMethodRequest isKindOfClass:[HPTCardTokenPaymentMethodRequest class]]) {
        return [HPTCardTokenPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    return nil;
}

@end
