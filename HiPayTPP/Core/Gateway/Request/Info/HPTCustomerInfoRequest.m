//
//  HPTCustomerInfoRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTCustomerInfoRequest.h"

@implementation HPTCustomerInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gender = HPTGenderUndefined;
    }
    return self;
}

@end