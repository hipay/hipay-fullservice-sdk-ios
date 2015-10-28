//
//  HPTOrderRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRelatedRequest.h"
#import "HPTAbstractPaymentMethodRequest.h"

@interface HPTOrderRequest : HPTOrderRelatedRequest

@property (nonatomic, copy) NSString *paymentProductCode;
@property (nonatomic) HPTAbstractPaymentMethodRequest *paymentMethod;

@end
