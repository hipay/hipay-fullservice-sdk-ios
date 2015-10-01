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

- (id _Nullable)mappedObject
{
    HPTPaymentCardToken *object = [[HPTPaymentCardToken alloc] init];
    
    [object setValue:[self getObjectForKey:@"token"] forKey:@"token"];
    [object setValue:[self getObjectForKey:@"brand"] forKey:@"brand"];
    [object setValue:[self getObjectForKey:@"pan"] forKey:@"pan"];
    [object setValue:[self getObjectForKey:@"card_holder"] forKey:@"cardHolder"];
    [object setValue:[self getObjectForKey:@"card_expiry_month"] forKey:@"cardExpiryMonth"];
    [object setValue:[self getObjectForKey:@"card_expiry_year"] forKey:@"cardExpiryYear"];
    [object setValue:[self getObjectForKey:@"issuer"] forKey:@"issuer"];
    [object setValue:[self getObjectForKey:@"country"] forKey:@"country"];
    [object setValue:[self getObjectForKey:@"domesticNetwork"] forKey:@"domesticNetwork"];
    
    return object;
    
}

@end
