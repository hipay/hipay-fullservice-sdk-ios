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
#import "HPTQiwiWalletPaymentMethodRequestSerializationMapper.h"

@implementation HPTOrderRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];
    
    [result setNullableObject:[self getStringForKey:@"paymentProductCode"] forKey:@"payment_product"];
    
    [result mergeDictionary:[self paymentMethodSerializedRequest] withPrefix:nil];
    
    return [self createImmutableDictionary:result];
}

- (NSDictionary *)paymentMethodSerializedRequest
{
    HPTAbstractPaymentMethodRequest *paymentMethodRequest = [self.request valueForKey:@"paymentMethod"];

    if ([paymentMethodRequest isKindOfClass:[HPTCardTokenPaymentMethodRequest class]]) {
        return [HPTCardTokenPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    else if ([paymentMethodRequest isKindOfClass:[HPTQiwiWalletPaymentMethodRequest class]]) {
        return [HPTQiwiWalletPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    return nil;
}

@end
