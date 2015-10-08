//
//  HPTCustomerInfo.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTPersonalInformation : NSObject

@property (nonatomic, readonly) NSString *gender;
@property (nonatomic, readonly) NSString *firstname;
@property (nonatomic, readonly) NSString *lastname;
@property (nonatomic, readonly) NSString *streetAddress;
@property (nonatomic, readonly) NSString *locality;
@property (nonatomic, readonly) NSString *postalCode;
@property (nonatomic, readonly) NSString *country;

@end
