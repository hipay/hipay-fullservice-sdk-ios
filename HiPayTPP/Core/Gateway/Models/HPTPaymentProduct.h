//
//  HPTPaymentProduct.h
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTPaymentProduct : NSObject

@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *paymentProductId;
@property (nonatomic, readonly) NSString *paymentProductDescription;
@property (nonatomic, readonly) NSString *paymentProductCategoryCode;
@property (nonatomic, readonly) BOOL tokenizable;

@end
