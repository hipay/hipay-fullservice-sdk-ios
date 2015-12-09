//
//  HPFPersonalInfoRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPersonalInfoRequest.h"

@implementation HPFPersonalInfoRequest

- (NSString *)displayName
{
    NSString *firstname = self.firstname;
    NSString *lastname = self.lastname;
    
    BOOL firstNameDefined = firstname != nil && ![[firstname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    
    BOOL lastNameDefined = lastname != nil && ![[lastname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    
    if (firstNameDefined && lastNameDefined) {
        return [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    }
    
    else if (firstNameDefined) {
        return firstname;
    }
    
    else if (lastNameDefined) {
        return lastname;
    }
    
    return nil;
}

@end
