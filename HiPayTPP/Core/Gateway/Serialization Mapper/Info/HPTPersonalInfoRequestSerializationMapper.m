//
//  HPTPersonalInfoSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTPersonalInfoRequestSerializationMapper.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPTAbstractSerializationMapper+Encode.h"
#import "HPTPersonalInfoRequest.h"

@implementation HPTPersonalInfoRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setNullableObject:[self getStringForKeyPath:@"firstname"] forKey:@"firstname"];
    [result setNullableObject:[self getStringForKeyPath:@"lastname"] forKey:@"lastname"];
    [result setNullableObject:[self getStringForKeyPath:@"streetAddress"] forKey:@"streetaddress"];
    [result setNullableObject:[self getStringForKeyPath:@"streetAddress2"] forKey:@"streetaddress2"];
    [result setNullableObject:[self getStringForKeyPath:@"recipientInfo"] forKey:@"recipientinfo"];
    [result setNullableObject:[self getStringForKeyPath:@"city"] forKey:@"city"];
    [result setNullableObject:[self getStringForKeyPath:@"state"] forKey:@"state"];
    [result setNullableObject:[self getStringForKeyPath:@"zipCode"] forKey:@"zipcode"];
    [result setNullableObject:[self getStringForKeyPath:@"country"] forKey:@"country"];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
