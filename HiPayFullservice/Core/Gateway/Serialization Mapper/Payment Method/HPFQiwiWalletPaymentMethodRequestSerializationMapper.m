//
//  HPFQiwiWalletPaymentMethodRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPFQiwiWalletPaymentMethodRequestSerializationMapper.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "NSMutableDictionary+Serialization.h"

@implementation HPFQiwiWalletPaymentMethodRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"username"] forKey:@"qiwiuser"];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
