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

+ (instancetype)cardTokenPaymentMethodRequestWithToken:(NSString *)token eci:(HPTECI)eci authenticationIndicator:(HPTAuthenticationIndicator)authenticationIndicator
{
    HPTCardTokenPaymentMethodRequest *result = [[HPTCardTokenPaymentMethodRequest alloc] init];
    result.cardToken = token;
    result.eci = eci;
    result.authenticationIndicator = authenticationIndicator;

    return result;
}

@end
