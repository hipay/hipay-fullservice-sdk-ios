//
//  HPFPaymentCardToken.m
//  Pods
//
//  Created by HiPay on 18/09/2015.
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

#define kTokenKey                   @"token"
#define kBrandKey                   @"brand"
#define kRequestIdKey               @"requestID"
#define kPanKey                     @"pan"
#define kCardHolderKey              @"cardHolder"
#define kCardExpiryMonthKey         @"cardExpiryMonth"
#define kCardExpiryYearKey          @"cardExpiryYear"
#define kIssuerKey                  @"issuer"
#define kCountryKey                 @"country"
#define kDomesticNetworkKey         @"domesticNetwork"
#define kDateAddedKey               @"dateAdded"

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.token forKey:kTokenKey];
    [coder encodeObject:self.brand forKey:kBrandKey];
    [coder encodeObject:self.requestID forKey:kRequestIdKey];
    [coder encodeObject:self.pan forKey:kPanKey];
    [coder encodeObject:self.cardHolder forKey:kCardHolderKey];
    [coder encodeObject:self.cardExpiryMonth forKey:kCardExpiryMonthKey];
    [coder encodeObject:self.cardExpiryYear forKey:kCardExpiryYearKey];
    [coder encodeObject:self.issuer forKey:kIssuerKey];
    [coder encodeObject:self.country forKey:kCountryKey];
    [coder encodeObject:self.domesticNetwork forKey:kDomesticNetworkKey];
    [coder encodeObject:self.dateAdded forKey:kDateAddedKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder {

    HPFPaymentCardToken *cardToken = [[HPFPaymentCardToken alloc] init];

    [cardToken setValue:[coder decodeObjectForKey:kTokenKey] forKey:kTokenKey];
    [cardToken setValue:[coder decodeObjectForKey:kBrandKey] forKey:kBrandKey];
    [cardToken setValue:[coder decodeObjectForKey:kRequestIdKey] forKey:kRequestIdKey];
    [cardToken setValue:[coder decodeObjectForKey:kPanKey] forKey:kPanKey];
    [cardToken setValue:[coder decodeObjectForKey:kCardHolderKey] forKey:kCardHolderKey];
    [cardToken setValue:[coder decodeObjectForKey:kCardExpiryMonthKey] forKey:kCardExpiryMonthKey];
    [cardToken setValue:[coder decodeObjectForKey:kCardExpiryYearKey] forKey:kCardExpiryYearKey];
    [cardToken setValue:[coder decodeObjectForKey:kIssuerKey] forKey:kIssuerKey];
    [cardToken setValue:[coder decodeObjectForKey:kCountryKey] forKey:kCountryKey];
    [cardToken setValue:[coder decodeObjectForKey:kDomesticNetworkKey] forKey:kDomesticNetworkKey];
    [cardToken setValue:[coder decodeObjectForKey:kDateAddedKey] forKey:kDateAddedKey];

    return cardToken;
}

@end
