//
//  HPFOrderRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFAbstractPaymentMethodRequest.h"

@interface HPFOrderRequest : HPFOrderRelatedRequest

@property (nonatomic, copy) NSString *paymentProductCode;
@property (nonatomic) HPFAbstractPaymentMethodRequest *paymentMethod;

@end
