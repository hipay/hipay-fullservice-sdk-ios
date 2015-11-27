//
//  HPTHostedPaymentPageRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRelatedRequest.h"
#import "HPTCardTokenPaymentMethodRequest.h"

extern NSString *const HPTPaymentPageRequestTemplateNameBasic;
extern NSString *const HPTPaymentPageRequestTemplateNameFrame;

@interface HPTPaymentPageRequest : HPTOrderRelatedRequest

@property (nonatomic, copy) NSArray *paymentProductList;
@property (nonatomic, copy) NSArray *paymentProductCategoryList;
@property (nonatomic) HPTECI eci;
@property (nonatomic) HPTAuthenticationIndicator authenticationIndicator;
@property (nonatomic) BOOL multiUse;
@property (nonatomic) BOOL displaySelector;
@property (nonatomic) NSString *templateName;
@property (nonatomic) NSURL *css;
@property (nonatomic) BOOL paymentCardGroupingEnabled;
@property (nonatomic) NSMutableSet <NSString *> *groupedPaymentCardProductCodes;

@end
