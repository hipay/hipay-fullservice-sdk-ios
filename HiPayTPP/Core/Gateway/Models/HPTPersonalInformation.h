//
//  HPTCustomerInfo.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTPersonalInformation : NSObject

@property (nonatomic, readonly) NSString *firstname;
@property (nonatomic, readonly) NSString *lastname;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *streetAddress;
@property (nonatomic, readonly) NSString *locality;
@property (nonatomic, readonly) NSString *postalCode;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *msisdn;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *phoneOperator;
@property (nonatomic, readonly) NSString *email;

@end
