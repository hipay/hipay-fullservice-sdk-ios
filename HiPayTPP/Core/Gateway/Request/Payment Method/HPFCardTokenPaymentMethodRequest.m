//
//  HPFCardTokenPaymentMethodRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFCardTokenPaymentMethodRequest.h"

@implementation HPFCardTokenPaymentMethodRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authenticationIndicator = HPFAuthenticationIndicatorUndefined;
        _eci = HPFECIUndefined;
    }
    return self;
}

+ (instancetype)cardTokenPaymentMethodRequestWithToken:(NSString *)token eci:(HPFECI)eci authenticationIndicator:(HPFAuthenticationIndicator)authenticationIndicator
{
    HPFCardTokenPaymentMethodRequest *result = [[HPFCardTokenPaymentMethodRequest alloc] init];
    result.cardToken = token;
    result.eci = eci;
    result.authenticationIndicator = authenticationIndicator;

    return result;
}

@end
