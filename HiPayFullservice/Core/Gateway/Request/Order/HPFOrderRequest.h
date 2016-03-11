//
//  HPFOrderRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFAbstractPaymentMethodRequest.h"

/**
 *  Describes an order request. You need to instantiate this class and fill its properties for executing a "request new order" request.
 */
@interface HPFOrderRequest : HPFOrderRelatedRequest

/**
 *  The payment product (e.g., visa, mastercard, ideal). Available payment product codes are defined in HPFPaymentProduct.h.
 */
@property (nonatomic, copy, nullable) NSString *paymentProductCode;

/**
 *  Optional payment method information (e.g. credit card token).
 */
@property (nonatomic, nullable) HPFAbstractPaymentMethodRequest *paymentMethod;

@end
