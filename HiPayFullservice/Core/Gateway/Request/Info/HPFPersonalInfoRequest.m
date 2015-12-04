//
//  HPFPersonalInfoRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPersonalInfoRequest.h"
#import "NSString+HPFValidation.h"

@implementation HPFPersonalInfoRequest

- (NSString *)displayName
{
    NSString *firstname = self.firstname;
    NSString *lastname = self.lastname;
    
    if ([firstname isDefined] && [lastname isDefined]) {
        return [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    }
    
    else if ([firstname isDefined]) {
        return firstname;
    }
    
    else if ([lastname isDefined]) {
        return lastname;
    }
    
    return nil;
}

@end
