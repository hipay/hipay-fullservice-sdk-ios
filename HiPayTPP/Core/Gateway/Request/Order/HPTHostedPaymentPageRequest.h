//
//  HPTHostedPaymentPageRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRelatedRequest.h"

@interface HPTHostedPaymentPageRequest : HPTOrderRelatedRequest

@property (nonatomic, copy) NSArray *paymentProductList;
@property (nonatomic, copy) NSArray *paymentProductCategoryList;

@end
