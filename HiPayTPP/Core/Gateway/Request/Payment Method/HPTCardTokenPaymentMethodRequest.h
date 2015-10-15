//
//  HPTCardTokenPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTAbstractPaymentMethodRequest.h"
#import "HPTTransaction.h"

typedef NS_ENUM(NSInteger, HPTAuthenticationIndicator) {
    HPTAuthenticationIndicatorUndefined = NSIntegerMax,
    HPTAuthenticationIndicatorBypass = 0,
    HPTAuthenticationIndicatorIfAvailable = 1,
    HPTAuthenticationIndicatorMandatory = 2,
};

@interface HPTCardTokenPaymentMethodRequest : HPTAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *cardToken;
@property (nonatomic) HPTECI eci;
@property (nonatomic) HPTAuthenticationIndicator authenticationIndicator;

@end
