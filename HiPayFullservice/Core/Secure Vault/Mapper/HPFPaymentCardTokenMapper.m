//
//  HPFPaymentCardTokenMapper.m
//  Pods
//
//  Created by HiPay on 01/10/2015.
//
//

#import "HPFPaymentCardTokenMapper.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFPaymentCardTokenMapper

- (id _Nonnull)mappedObject
{

    HPFPaymentCardToken *object = [[HPFPaymentCardToken alloc] init];
    
    [object setValue:[self getStringForKey:@"token"] forKey:@"token"];
    [object setValue:[self getStringForKey:@"request_id"] forKey:@"requestID"];
    [object setValue:[self getStringForKey:@"pan"] forKey:@"pan"];
    [object setValue:[self getStringForKey:@"brand"] forKey:@"brand"];
    [object setValue:[self getStringForKey:@"card_holder"] forKey:@"cardHolder"];
    [object setValue:[self getNumberForKey:@"card_expiry_month"] forKey:@"cardExpiryMonth"];
    [object setValue:[self getNumberForKey:@"card_expiry_year"] forKey:@"cardExpiryYear"];
    [object setValue:[self getStringForKey:@"issuer"] forKey:@"issuer"];
    [object setValue:[self getStringForKey:@"country"] forKey:@"country"];
    [object setValue:[self getStringForKey:@"domestic_network"] forKey:@"domesticNetwork"];
    
    return object;
    
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"token"] != nil;
}

@end
