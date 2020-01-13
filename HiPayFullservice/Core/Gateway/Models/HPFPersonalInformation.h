//
//  HPFCustomerInfo.h
//  Pods
//
//  Created by HiPay on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

/**
 *  Describes perfonal information (such as a customer or shipping information).
 */
@interface HPFPersonalInformation : NSObject

/**
 *  First name.
 */
@property (nonatomic, readonly, nullable) NSString *firstname;

/**
 *  Last name.
 */
@property (nonatomic, readonly, nullable) NSString *lastname;

/**
 *  Street address.
 */
@property (nonatomic, readonly, nullable) NSString *streetAddress;

/**
 *  Locality.
 */
@property (nonatomic, readonly, nullable) NSString *locality;

/**
 *  Zip or postal code.
 */
@property (nonatomic, readonly, nullable) NSString *postalCode;

/**
 *  Country code. This two-letter country code complies with ISO 3166-1 (alpha 2).
 */
@property (nonatomic, readonly, nullable) NSString *country;

/**
 *  Mobile phone number.
 */
@property (nonatomic, readonly, nullable) NSString *msisdn;

/**
 *  Phone number.
 */
@property (nonatomic, readonly, nullable) NSString *phone;

/**
 *  Phone operator.
 */
@property (nonatomic, readonly, nullable) NSString *phoneOperator;

/**
 *  E-mail address.
 */
@property (nonatomic, readonly, nullable) NSString *email;

@end
