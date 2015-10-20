//
//  HPTHostedPaymentPageRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTPaymentPageRequestSerializationMapper.h"
#import "HPTPaymentPageRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPTAbstractSerializationMapper+Encode.h"
#import "HPTOrderRelatedRequestSerializationMapper_Private.h"

@implementation HPTPaymentPageRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];

    [result setNullableObject:[self getStringValuesListForKey:@"paymentProductList"] forKey:@"payment_product_list"];
    [result setNullableObject:[self getStringValuesListForKey:@"paymentProductCategoryList"] forKey:@"payment_product_category_list"];
    
    return [self createImmutableDictionary:result];
}

@end
