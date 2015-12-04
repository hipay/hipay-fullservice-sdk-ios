//
//  HPFCardTokenPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFAbstractPaymentMethodRequest.h"
#import "HPFTransaction.h"

typedef NS_ENUM(NSInteger, HPFAuthenticationIndicator) {
    HPFAuthenticationIndicatorUndefined = NSIntegerMax,
    HPFAuthenticationIndicatorBypass = 0,
    HPFAuthenticationIndicatorIfAvailable = 1,
    HPFAuthenticationIndicatorMandatory = 2,
};

@interface HPFCardTokenPaymentMethodRequest : HPFAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *cardToken;
@property (nonatomic) HPFECI eci;
@property (nonatomic) HPFAuthenticationIndicator authenticationIndicator;

+ (instancetype)cardTokenPaymentMethodRequestWithToken:(NSString *)token eci:(HPFECI)eci authenticationIndicator:(HPFAuthenticationIndicator)authenticationIndicator;

@end
