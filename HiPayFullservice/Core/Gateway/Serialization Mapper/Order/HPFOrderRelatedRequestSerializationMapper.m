//
//  HPFOrderRelatedRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequestSerializationMapper.h"
#import "HPFOrderRelatedRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "HPFCustomerInfoRequestSerializationMapper.h"

@implementation HPFOrderRelatedRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    return [self createImmutableDictionary:[self orderRelatedSerializedRequest]];
}

- (NSMutableDictionary *)orderRelatedSerializedRequest
{
    NSMutableDictionary *result = [self createResponseDictionary];
    
    [result setNullableObject:[self getStringForKey:@"orderId"] forKey:@"orderid"];
    [result setNullableObject:[self getOperation] forKey:@"operation"];
    [result setNullableObject:[self getStringForKey:@"shortDescription"] forKey:@"description"];
    [result setNullableObject:[self getStringForKey:@"longDescription"] forKey:@"long_description"];
    [result setNullableObject:[self getStringForKey:@"currency"] forKey:@"currency"];
    [result setNullableObject:[self getFloatForKey:@"amount"] forKey:@"amount"];
    [result setNullableObject:[self getFloatForKey:@"shipping"] forKey:@"shipping"];
    [result setNullableObject:[self getFloatForKey:@"tax"] forKey:@"tax"];
    [result setNullableObject:[self getStringForKey:@"clientId"] forKey:@"cid"];
    [result setNullableObject:[self getStringForKey:@"ipAddress"] forKey:@"ipaddr"];
    
    [result setNullableObject:[self getStringForKey:@"HTTPAccept"] forKey:@"http_accept"];
    [result setNullableObject:[self getStringForKey:@"HTTPUserAgent"] forKey:@"http_user_agent"];
    [result setNullableObject:[self getStringForKey:@"deviceFingerprint"] forKey:@"device_fingerprint"];
    [result setNullableObject:[self getStringForKey:@"language"] forKey:@"language"];
    
    [result setNullableObject:[self getURLForKey:@"acceptURL"] forKey:@"accept_url"];
    [result setNullableObject:[self getURLForKey:@"declineURL"] forKey:@"decline_url"];
    [result setNullableObject:[self getURLForKey:@"pendingURL"] forKey:@"pending_url"];
    [result setNullableObject:[self getURLForKey:@"exceptionURL"] forKey:@"exception_url"];
    [result setNullableObject:[self getURLForKey:@"cancelURL"] forKey:@"cancel_url"];
    
    [result setNullableObject:[self getSerializedJSONForKey:@"customData"] forKey:@"custom_data"];
    
    [result setNullableObject:[self getStringForKey:@"cdata1"] forKey:@"cdata1"];
    [result setNullableObject:[self getStringForKey:@"cdata2"] forKey:@"cdata2"];
    [result setNullableObject:[self getStringForKey:@"cdata3"] forKey:@"cdata3"];
    [result setNullableObject:[self getStringForKey:@"cdata4"] forKey:@"cdata4"];
    [result setNullableObject:[self getStringForKey:@"cdata5"] forKey:@"cdata5"];
    [result setNullableObject:[self getStringForKey:@"cdata6"] forKey:@"cdata6"];
    [result setNullableObject:[self getStringForKey:@"cdata7"] forKey:@"cdata7"];
    [result setNullableObject:[self getStringForKey:@"cdata8"] forKey:@"cdata8"];
    [result setNullableObject:[self getStringForKey:@"cdata9"] forKey:@"cdata9"];
    [result setNullableObject:[self getStringForKey:@"cdata10"] forKey:@"cdata10"];
    
    [result mergeDictionary:[[HPFCustomerInfoRequestSerializationMapper mapperWithRequest:[self.request valueForKey:@"customer"]] serializedRequest] withPrefix:nil];
    
    [result mergeDictionary:[[HPFPersonalInfoRequestSerializationMapper mapperWithRequest:[self.request valueForKey:@"shippingAddress"]] serializedRequest] withPrefix:@"shipto_"];
    
    [result setNullableObject:[self getSerializedJSONForKey:@"source"] forKey:@"source"];
    
    return result;
}

- (NSString *)getOperation
{
    NSNumber *operation = [self.request valueForKey:@"operation"];
    
    if (operation != nil) {
        switch (operation.integerValue) {
            case HPFOrderRequestOperationSale:
                return @"Sale";
                
            case HPFOrderRequestOperationAuthorization:
                return @"Authorization";
        }
    }
    
    return nil;
}

@end
