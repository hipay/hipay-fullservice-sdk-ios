//
//  HPTPaymentCardToken.h
//  Pods
//
//  Created by Jonathan TIRET on 18/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTPaymentMethod.h"

@interface HPTPaymentCardToken : HPTPaymentMethod

@property (nonatomic, readonly, nonnull) NSString *token;
@property (nonatomic, readonly, nonnull) NSString *brand;
@property (nonatomic, readonly, nonnull) NSString *requestID;
@property (nonatomic, readonly, nonnull) NSString *pan;
@property (nonatomic, readonly, nonnull) NSString *cardHolder;
@property (nonatomic, readonly, nonnull) NSString *cardExpiryMonth;
@property (nonatomic, readonly, nonnull) NSString *cardExpiryYear;
@property (nonatomic, readonly, nonnull) NSString *issuer;
@property (nonatomic, readonly, nonnull) NSString *country;
@property (nonatomic, readonly, nullable) NSString *domesticNetwork;

@end
