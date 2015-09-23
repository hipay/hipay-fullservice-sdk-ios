//
//  HPTPaymentCardToken.h
//  Pods
//
//  Created by Jonathan TIRET on 18/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTPaymentCardToken : NSObject

@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *brand;
@property (nonatomic, readonly) NSString *pan;
@property (nonatomic, readonly) NSString *cardHolder;
@property (nonatomic, readonly) NSString *cardExpiryMonth;
@property (nonatomic, readonly) NSString *cardExpiryYear;
@property (nonatomic, readonly) NSString *issuer;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *domesticNetwork;

@end
