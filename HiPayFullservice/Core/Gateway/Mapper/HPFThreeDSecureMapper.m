//
//  HPFThreeDSecureMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFThreeDSecureMapper.h"
#import "HPFThreeDSecure.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFThreeDSecureMapper

- (id _Nonnull)mappedObject
{
    
    HPFThreeDSecure *object = [[HPFThreeDSecure alloc] init];
    
    [object setValue:[self getStringForKey:@"enrollmentMessage"] forKey:@"enrollmentMessage"];
    [object setValue:[self getEnumCharForKey:@"enrollmentStatus"] forKey:@"enrollmentStatus"];
    [object setValue:[self getEnumCharForKey:@"authenticationStatus"] forKey:@"authenticationStatus"];
    [object setValue:[self getStringForKey:@"authenticationMessage"] forKey:@"authenticationMessage"];
    [object setValue:[self getStringForKey:@"authenticationToken"] forKey:@"authenticationToken"];
    [object setValue:[self getStringForKey:@"xid"] forKey:@"xid"];

    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"enrollmentStatus"] != nil;
}

@end
