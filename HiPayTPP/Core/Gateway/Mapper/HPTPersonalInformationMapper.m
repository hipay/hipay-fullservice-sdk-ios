//
//  HPTPersonalInformationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTPersonalInformationMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTPersonalInformation.h"

@implementation HPTPersonalInformationMapper

- (id _Nonnull)mappedObject
{
    return [self mappedObjectWithPersonalInformation:[[HPTPersonalInformation alloc] init]];
}

- (id _Nonnull)mappedObjectWithPersonalInformation:(HPTPersonalInformation *)object
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
    return [self.rawData objectForKey:@"firstname"] != nil && [self.rawData objectForKey:@"lastname"] != nil;
}

@end
