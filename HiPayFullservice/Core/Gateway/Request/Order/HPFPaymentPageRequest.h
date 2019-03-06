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

/**
 *  Describes a hosted payment page initialization request. You need to instantiate this class and fill its properties either for initializing a hosted payment page (Web) or for generating a mobile native payment screen.
 */
@interface HPFPaymentPageRequest : HPFOrderRelatedRequest

/**
 *  List of codes for payment products to be displayed on the payment page.
 *  Available payment product codes are defined in HPFPaymentProduct.h.
 */
@property (nonatomic, copy, nullable) NSArray *paymentProductList;

/**
 *  List of category codes for payment products to be displayed on the payment page.
 *  Available payment product category codes are defined in HPFPaymentProduct.h.
 */
@property (nonatomic, copy, nullable) NSArray *paymentProductCategoryList;

/**
 *  Electronic Commerce Indicator (ECI). The ECI indicates the security level at which the payment information is processed between the cardholder and merchant.
 */
@property (nonatomic) HPFECI eci;

/**
 *  Indicates if the 3-D Secure authentication should be performed for this transaction.
 */
@property (nonatomic) HPFAuthenticationIndicator authenticationIndicator;

/**
 *  Indicates the tokenization module if the credit card token should be generated either for a single-use or a multi-use. While a single-use token is typically generated for a short time and for processing a single transaction, multi-use tokens are generally generated for recurrent payments.
 */
@property (nonatomic) BOOL multiUse;

/**
 *  Enable/disable the payment products selector.
 */
@property (nonatomic) BOOL displaySelector;

/**
 *  The template name.
 */
@property (nonatomic, nullable) NSString *templateName;

/**
 *  URL to merchant style sheet. Important: HTTPS protocol is required.
 */
@property (nonatomic, nullable) NSURL *css;

/**
 *  Whether the debit/credit card payment products should be grouped in a single "payment card" selection. This option only works when generating an iOS native payment screen, not with the Web page.
 */
@property (nonatomic) BOOL paymentCardGroupingEnabled;

/**
 *  When the paymentCardGroupingEnabled option is activated, this set is used to define the codes of payment products that should be grouped in the single "card" payment product selection.
 *  Available payment product codes are defined in HPFPaymentProduct.h.
 *
 *  @see paymentCardGroupingEnabled
 */
@property (nonatomic, nonnull) NSMutableSet <NSString *> *groupedPaymentCardProductCodes;

/**
 *  Time before payment page get expired (in seconds). An error will be raised after the delay. This option will dismiss iOS native payment screen when error raised
 */
@property (nonatomic, nullable) NSNumber *timeout;

@end
