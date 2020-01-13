//
//  HPFPersonalInfoRequest.h
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

/**
 *  Personal information may describe customer data to be sent alongside an order or shipping information.
 */
@interface HPFPersonalInfoRequest : NSObject

/**
 *  First name.
 */
@property (nonatomic, copy, nullable) NSString *firstname;

/**
 *  Last name.
 */
@property (nonatomic, copy, nullable) NSString *lastname;

/**
 *  Concatenation of first name and last name.
 */
@property (nonatomic, readonly, nullable) NSString *displayName;

/**
 *  The street address.
 */
@property (nonatomic, copy, nullable) NSString *streetAddress;

/**
 *  Additional address information (e.g., building, floor, flat, etc.).
 */
@property (nonatomic, copy, nullable) NSString *streetAddress2;

/**
 *  Additional information (e.g., quality or function, company name, department, etc.).
 */
@property (nonatomic, copy, nullable) NSString *recipientInfo;

/**
 *  The city.
 */
@property (nonatomic, copy, nullable) NSString *city;

/**
 *  The USA state or the Canada state. Send this information only if the address country of the customer is US (USA) or CA (Canada).
 */
@property (nonatomic, copy, nullable) NSString *state;

/**
 *  The zip or postal code.
 */
@property (nonatomic, copy, nullable) NSString *zipCode;

/**
 *  The country code. This two-letter country code complies with ISO 3166-1 (alpha 2).
 */
@property (nonatomic, copy, nullable) NSString *country;

@end
