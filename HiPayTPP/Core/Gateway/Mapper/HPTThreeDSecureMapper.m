//
//  HPTThreeDSecureMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTThreeDSecureMapper.h"
#import "HPTThreeDSecure.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTThreeDSecureMapper

- (id _Nonnull)mappedObject
{
    
    HPTThreeDSecure *object = [[HPTThreeDSecure alloc] init];
    
    [object setValue:[self getStringForKey:@"enrollmentMessage"] forKey:@"enrollmentMessage"];
    [object setValue:[self getEnumCharForKey:@"enrollmentStatus"] forKey:@"enrollmentStatus"];

    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"enrollmentStatus"] != nil;
}

@end
