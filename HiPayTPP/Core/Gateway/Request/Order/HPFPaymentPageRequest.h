//
//  HPFHostedPaymentPageRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFCardTokenPaymentMethodRequest.h"

extern NSString *const HPFPaymentPageRequestTemplateNameBasic;
extern NSString *const HPFPaymentPageRequestTemplateNameFrame;

@interface HPFPaymentPageRequest : HPFOrderRelatedRequest

@property (nonatomic, copy) NSArray *paymentProductList;
@property (nonatomic, copy) NSArray *paymentProductCategoryList;
@property (nonatomic) HPFECI eci;
@property (nonatomic) HPFAuthenticationIndicator authenticationIndicator;
@property (nonatomic) BOOL multiUse;
@property (nonatomic) BOOL displaySelector;
@property (nonatomic) NSString *templateName;
@property (nonatomic) NSURL *css;
@property (nonatomic) BOOL paymentCardGroupingEnabled;
@property (nonatomic) NSMutableSet <NSString *> *groupedPaymentCardProductCodes;

@end
