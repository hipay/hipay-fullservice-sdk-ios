//
//  HPTQiwiWalletPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPTQiwiWalletPaymentMethodRequestSerializationMapper.h"
#import "HPTAbstractSerializationMapper+Encode.h"
#import "NSMutableDictionary+Serialization.h"

@implementation HPTQiwiWalletPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"username"] forKey:@"qiwiuser"];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
