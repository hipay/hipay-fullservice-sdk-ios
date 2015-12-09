//
//  HPFHostedPaymentPageRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFCardTokenPaymentMethodRequest.h"

extern NSString * _Nonnull const HPFPaymentPageRequestTemplateNameBasic;
extern NSString * _Nonnull const HPFPaymentPageRequestTemplateNameFrame;

@interface HPFPaymentPageRequest : HPFOrderRelatedRequest

@property (nonatomic, copy, nullable) NSArray *paymentProductList;
@property (nonatomic, copy, nullable) NSArray *paymentProductCategoryList;
@property (nonatomic) HPFECI eci;
@property (nonatomic) HPFAuthenticationIndicator authenticationIndicator;
@property (nonatomic) BOOL multiUse;
@property (nonatomic) BOOL displaySelector;
@property (nonatomic, nullable) NSString *templateName;
@property (nonatomic, nullable) NSURL *css;
@property (nonatomic) BOOL paymentCardGroupingEnabled;
@property (nonatomic, nonnull) NSMutableSet <NSString *> *groupedPaymentCardProductCodes;

@end
