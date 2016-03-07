//
//  HPFOrder.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFPersonalInformation.h"

/**
 *  Describes a gender.
 */
typedef NS_ENUM(char, HPFGender) {
    
    /**
     *  Undefined gender.
     */
    HPFGenderUndefined = ' ',
    
    /**
     *  Unknown gender
     */
    HPFGenderUnknown = 'U',
    
    /**
     *  Male
     */
    HPFGenderMale = 'M',
    
    /**
     *  Female
     */
    HPFGenderFemale = 'F',
    
};

/**
 *  Information about the customer and his order.
 */
@interface HPFOrder : HPFPersonalInformation

/**
 *  Unique identifier of the order as provided by the merchant.
 */
@property (nonatomic, readonly, nonnull) NSString *orderId;

/**
 *  Time when the order was created.
 */
@property (nonatomic, readonly, nonnull) NSDate *dateCreated;

/**
 *  Indicates how many payment attempts have been made for this order.
 */
@property (nonatomic, readonly) NSInteger attempts;

/**
 *  The total order amount (e.g., 150.00). It should be calculated as a sum of the items purchased, plus the shipping fee (if present), plus the tax fee (if present).
 */
@property (nonatomic, readonly, nonnull) NSNumber *amount;

/**
 *  The order shipping fee.
 */
@property (nonatomic, readonly, nullable) NSNumber *shipping;

/**
 *  The order tax fee.
 */
@property (nonatomic, readonly, nullable) NSNumber *tax;

/**
 *  Decimal precision of the order amount.
 */
@property (nonatomic, readonly, nonnull) NSNumber *decimals;

/**
 *  Base currency for this order. This three-character currency code complies with ISO 4217.
 */
@property (nonatomic, readonly, nonnull) NSString *currency;

/**
 *  Unique identifier of the customer as provided by the merchant.
 */
@property (nonatomic, readonly, nullable) NSString *customerId;

/**
 *  Language code of the customer.
 */
@property (nonatomic, readonly, nullable) NSString *language;

/**
 *  Gender of the customer.
 */
@property (nonatomic, readonly) HPFGender gender;

/**
 *  Shipping information.
 */
@property (nonatomic, readonly, nullable) HPFPersonalInformation *shippingAddress;

@end