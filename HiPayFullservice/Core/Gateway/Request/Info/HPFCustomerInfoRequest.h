//
//  HPFCustomerInfoRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPersonalInfoRequest.h"
#import "HPFOrder.h"

/**
 *  Personal information may describe customer data to be sent alongside an order or shipping information.
 */
@interface HPFCustomerInfoRequest : HPFPersonalInfoRequest

/**
 *  The customer's e-mail address.
 */
@property (nonatomic, copy, nullable) NSString *email;

/**
 *  The customer's phone number.
 */
@property (nonatomic, copy, nullable) NSString *phone;

/**
 *  Birth date day of the customer (for fraud detection reasons).
 */
@property (nonatomic, copy, nullable) NSNumber *birthDateDay;

/**
 *  Birth date month of the customer (for fraud detection reasons).
 */
@property (nonatomic, copy, nullable) NSNumber *birthDateMonth;

/**
 *  Birth date year of the customer (for fraud detection reasons).
 */
@property (nonatomic, copy, nullable) NSNumber *birthDateYear;

/**
 *  Gender of the customer.
 */
@property (nonatomic) HPFGender gender;

@end
