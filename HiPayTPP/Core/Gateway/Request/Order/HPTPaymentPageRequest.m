//
//  HPTHostedPaymentPageRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTPaymentPageRequest.h"

NSString *const HPTPaymentPageRequestTemplateNameBasic = @"basic-js";
NSString *const HPTPaymentPageRequestTemplateNameFrame = @"iframe-js";

@implementation HPTPaymentPageRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authenticationIndicator = HPTAuthenticationIndicatorUndefined;
        _eci = HPTECIUndefined;
        _multiUse = NO;
        _displaySelector = NO;
    }
    return self;
}

@end