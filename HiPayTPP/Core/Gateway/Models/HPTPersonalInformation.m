//
//  HPTCustomerInfo.m
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import "HPTPersonalInformation.h"
#import "NSString+HPTValidation.h"

@implementation HPTPersonalInformation

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
