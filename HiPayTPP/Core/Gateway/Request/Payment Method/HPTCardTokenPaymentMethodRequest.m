//
//  HPTCardTokenPaymentMethodRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTCardTokenPaymentMethodRequest.h"

@implementation HPTCardTokenPaymentMethodRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authenticationIndicator = HPTAuthenticationIndicatorUndefined;
        _eci = HPTECIUndefined;
    }
    return self;
}

@end
