//
//  HPFPaymentCardToken.m
//  Pods
//
//  Created by Jonathan TIRET on 18/09/2015.
//
//

#import "HPFPaymentCardToken.h"

@implementation HPFPaymentCardToken

- (BOOL)isEqualToPaymentCardToken:(HPFPaymentCardToken  * _Nonnull )object
{
    if ([object isKindOfClass:[HPFPaymentCardToken class]] && (self.token != nil)) {
        return [object.token isEqual:self.token];
    }
    
    return NO;
}

- (BOOL)isEqual:(id)object
{
    return [self isEqualToPaymentCardToken:object];
}

@end
