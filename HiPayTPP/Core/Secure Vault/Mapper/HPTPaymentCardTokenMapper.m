//
//  HPTPaymentCardTokenMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTPaymentCardTokenMapper.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTPaymentCardTokenMapper

- (id _Nonnull)mappedObject
{

    HPTPaymentCardToken *object = [[HPTPaymentCardToken alloc] init];
    
    [object setValue:[self getStringForKey:@"token"] forKey:@"token"];
    [object setValue:[self getStringForKey:@"request_id"] forKey:@"requestID"];
    [object setValue:[self getStringForKey:@"pan"] forKey:@"pan"];
    [object setValue:[self getStringForKey:@"brand"] forKey:@"brand"];
    [object setValue:[self getStringForKey:@"card_holder"] forKey:@"cardHolder"];
    [object setValue:[self getNumberForKey:@"card_expiry_month"] forKey:@"cardExpiryMonth"];
    [object setValue:[self getNumberForKey:@"card_expiry_year"] forKey:@"cardExpiryYear"];
    [object setValue:[self getStringForKey:@"issuer"] forKey:@"issuer"];
    [object setValue:[self getStringForKey:@"country"] forKey:@"country"];
    [object setValue:[self getStringForKey:@"domesticNetwork"] forKey:@"domesticNetwork"];
    
    return object;
    
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"token"] != nil;
}

@end
