//
//  HPFHostedPaymentPageRequestSerializationMapper.m
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import "HPFPaymentPageRequestSerializationMapper.h"
#import "HPFPaymentPageRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "HPFOrderRelatedRequestSerializationMapper_Private.h"

@implementation HPFPaymentPageRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];

    [result setNullableObject:[self getStringValuesListForKey:@"paymentProductList"] forKey:@"payment_product_list"];
    [result setNullableObject:[self getStringValuesListForKey:@"paymentProductCategoryList"] forKey:@"payment_product_category_list"];
    [result setNullableObject:[self getIntegerEnumValueForKey:@"eci"] forKey:@"eci"];    
    [result setNullableObject:[self getIntegerEnumValueForKey:@"authenticationIndicator"] forKey:@"authentication_indicator"];
    [result setNullableObject:[self getIntegerForKey:@"multiUse"] forKey:@"multi_use"];
    [result setNullableObject:[self getIntegerForKey:@"displaySelector"] forKey:@"display_selector"];
    [result setNullableObject:[self getStringForKey:@"templateName"] forKey:@"template"];
    [result setNullableObject:[self getURLForKey:@"css"] forKey:@"css"];
    
    return [self createImmutableDictionary:result];
}

@end
