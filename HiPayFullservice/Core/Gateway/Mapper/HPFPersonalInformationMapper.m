//
//  HPFPersonalInformationMapper.m
//  Pods
//
//  Created by HiPay on 09/10/2015.
//
//

#import "HPFPersonalInformationMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFPersonalInformation.h"

@implementation HPFPersonalInformationMapper

- (id _Nonnull)mappedObject
{
    return [self mappedObjectWithPersonalInformation:[[HPFPersonalInformation alloc] init]];
}

- (id _Nonnull)mappedObjectWithPersonalInformation:(HPFPersonalInformation *)object
{
    [object setValue:[self getStringForKey:@"firstname"] forKey:@"firstname"];
    [object setValue:[self getStringForKey:@"lastname"] forKey:@"lastname"];
    [object setValue:[self getStringForKey:@"streetAddress"] forKey:@"streetAddress"];
    [object setValue:[self getStringForKey:@"locality"] forKey:@"locality"];
    [object setValue:[self getStringForKey:@"postalCode"] forKey:@"postalCode"];
    [object setValue:[self getStringForKey:@"country"] forKey:@"country"];
    [object setValue:[self getStringForKey:@"msisdn"] forKey:@"msisdn"];
    [object setValue:[self getStringForKey:@"phone"] forKey:@"phone"];
    [object setValue:[self getStringForKey:@"phoneOperator"] forKey:@"phoneOperator"];
    [object setValue:[self getStringForKey:@"email"] forKey:@"email"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"email"] != nil;
}

@end
