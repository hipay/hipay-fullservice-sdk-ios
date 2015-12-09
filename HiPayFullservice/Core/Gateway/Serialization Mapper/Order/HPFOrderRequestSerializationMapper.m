//
//  HPFOrderRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRequestSerializationMapper.h"
#import "HPFOrderRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "HPFOrderRelatedRequestSerializationMapper_Private.h"
#import "HPFCardTokenPaymentMethodRequestSerializationMapper.h"
#import "HPFQiwiWalletPaymentMethodRequestSerializationMapper.h"
#import "HPFIDealPaymentMethodRequestSerializationMapper.h"

@implementation HPFOrderRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];
    
    [result setNullableObject:[self getStringForKey:@"paymentProductCode"] forKey:@"payment_product"];
    
    [result mergeDictionary:[self paymentMethodSerializedRequest] withPrefix:nil];
    
    return [self createImmutableDictionary:result];
}

- (NSDictionary *)paymentMethodSerializedRequest
{
    HPFAbstractPaymentMethodRequest *paymentMethodRequest = [self.request valueForKey:@"paymentMethod"];

    if ([paymentMethodRequest isKindOfClass:[HPFCardTokenPaymentMethodRequest class]]) {
        return [HPFCardTokenPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    else if ([paymentMethodRequest isKindOfClass:[HPFQiwiWalletPaymentMethodRequest class]]) {
        return [HPFQiwiWalletPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    else if ([paymentMethodRequest isKindOfClass:[HPFIDealPaymentMethodRequest class]]) {
        return [HPFIDealPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    return nil;
}

@end
