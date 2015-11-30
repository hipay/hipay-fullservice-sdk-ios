//
//  HPTPaymentCardToken.m
//  Pods
//
//  Created by Jonathan TIRET on 18/09/2015.
//
//

#import "HPTPaymentCardToken.h"

@implementation HPTPaymentCardToken

- (BOOL)isEqualToPaymentCardToken:(HPTPaymentCardToken  * _Nonnull )object
{
    if ([object isKindOfClass:[HPTPaymentCardToken class]] && (self.token != nil)) {
        return [object.token isEqual:self.token];
    }
    
    return NO;
}

- (BOOL)isEqual:(id)object
{
    return [self isEqualToPaymentCardToken:object];
}

@end
