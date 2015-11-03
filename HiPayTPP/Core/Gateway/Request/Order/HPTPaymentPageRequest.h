//
//  HPTHostedPaymentPageRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRelatedRequest.h"
#import "HPTCardTokenPaymentMethodRequest.h"

@interface HPTPaymentPageRequest : HPTOrderRelatedRequest

@property (nonatomic, copy) NSArray *paymentProductList;
@property (nonatomic, copy) NSArray *paymentProductCategoryList;
@property (nonatomic) HPTECI eci;
@property (nonatomic) HPTAuthenticationIndicator authenticationIndicator;
@property (nonatomic) BOOL multiUse;

@end
