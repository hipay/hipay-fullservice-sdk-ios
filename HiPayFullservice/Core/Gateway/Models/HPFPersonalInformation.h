//
//  HPFCustomerInfo.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFPersonalInformation : NSObject

@property (nonatomic, readonly, nullable) NSString *firstname;
@property (nonatomic, readonly, nullable) NSString *lastname;
@property (nonatomic, readonly, nullable) NSString *displayName;
@property (nonatomic, readonly, nullable) NSString *streetAddress;
@property (nonatomic, readonly, nullable) NSString *locality;
@property (nonatomic, readonly, nullable) NSString *postalCode;
@property (nonatomic, readonly, nullable) NSString *country;
@property (nonatomic, readonly, nullable) NSString *msisdn;
@property (nonatomic, readonly, nullable) NSString *phone;
@property (nonatomic, readonly, nullable) NSString *phoneOperator;
@property (nonatomic, readonly, nullable) NSString *email;

@end
