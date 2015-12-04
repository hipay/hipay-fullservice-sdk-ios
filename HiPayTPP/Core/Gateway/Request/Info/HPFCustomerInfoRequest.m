//
//  HPFCustomerInfoRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFCustomerInfoRequest.h"

@implementation HPFCustomerInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gender = HPFGenderUndefined;
    }
    return self;
}

@end