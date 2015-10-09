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

- (id _Nullable)mappedObject
{
    if ([self.rawData objectForKey:@"enrollmentStatus"] == nil) {
        return nil;
    }
    
    HPTThreeDSecure *object = [[HPTThreeDSecure alloc] init];
    
    [object setValue:[self getStringForKey:@"enrollmentMessage"] forKey:@"enrollmentMessage"];
    [object setValue:[self getEnumCharForKey:@"enrollmentStatus"] forKey:@"enrollmentStatus"];

    
    return object;
}

@end
