//
//  HPFPersonalInfoSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPersonalInfoRequestSerializationMapper.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "HPFPersonalInfoRequest.h"
#import "HPFPersonalInfoRequestSerializationMapper_Protected.h"

@implementation HPFPersonalInfoRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    return [NSDictionary dictionaryWithDictionary:[self personalInformationSerializedRequest]];
}

- (NSMutableDictionary *)personalInformationSerializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKey:@"firstname"] forKey:@"firstname"];
    [result setNullableObject:[self getStringForKey:@"lastname"] forKey:@"lastname"];
    [result setNullableObject:[self getStringForKey:@"streetAddress"] forKey:@"streetaddress"];
    [result setNullableObject:[self getStringForKey:@"streetAddress2"] forKey:@"streetaddress2"];
    [result setNullableObject:[self getStringForKey:@"recipientInfo"] forKey:@"recipientinfo"];
    [result setNullableObject:[self getStringForKey:@"city"] forKey:@"city"];
    [result setNullableObject:[self getStringForKey:@"state"] forKey:@"state"];
    [result setNullableObject:[self getStringForKey:@"zipCode"] forKey:@"zipcode"];
    [result setNullableObject:[self getStringForKey:@"country"] forKey:@"country"];
    
    return result;
}

@end
