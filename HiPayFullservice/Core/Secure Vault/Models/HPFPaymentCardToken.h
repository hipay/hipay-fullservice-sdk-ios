//
//  HPFPaymentCardToken.h
//  Pods
//
//  Created by HiPay on 18/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFPaymentMethod.h"

/**
 *  Describes a payment method and its related information.
 */
@interface HPFPaymentCardToken : HPFPaymentMethod <NSCoding>

/**
 *  Token that was created.
 */
@property (nonatomic, readonly, nonnull) NSString *token;

/**
 *  Card brand. (e.g., Visa, MasterCard, American Express, JCB, Discover, Diners Club, Solo, Laser, Maestro).
 */
@property (nonatomic, readonly, nonnull) NSString *brand;

/**
 *  The request ID linked to the token.
 */
@property (nonatomic, readonly, nonnull) NSString *requestID;

/**
 *  Card number (up to 19 characters). Note that, due to the PCI DSS security standards, our system has to mask credit card numbers in any output (e.g., 549619******4769).
 */
@property (nonatomic, readonly, nonnull) NSString *pan;

/**
 *  Cardholder name.
 */
@property (nonatomic, readonly, nonnull) NSString *cardHolder;

/**
 *  Card expiry month (2 digits).
 */
@property (nonatomic, readonly, nonnull) NSNumber *cardExpiryMonth;

/**
 *  Card expiry year (4 digits).
 */
@property (nonatomic, readonly, nonnull) NSNumber *cardExpiryYear;

/**
 *  Card issuing bank name. Do not rely on this value to remain static over time. Bank names may change over time due to acquisitions and mergers.
 */
@property (nonatomic, readonly, nonnull) NSString *issuer;

/**
 *  Bank country code where card was issued. This two-letter country code complies with ISO 3166-1 (alpha 2).
 */
@property (nonatomic, readonly, nonnull) NSString *country;

/**
 *  Card domestic network (if applicable, e.g. "cb").
 */
@property (nonatomic, readonly, nullable) NSString *domesticNetwork;

/**
 *  Date added.
 */
@property (nonatomic, nullable) NSDate *dateAdded;



- (BOOL)isEqualToPaymentCardToken:(HPFPaymentCardToken  * _Nonnull )object;

@end
