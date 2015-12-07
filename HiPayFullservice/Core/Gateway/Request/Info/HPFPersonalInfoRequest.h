//
//  HPFPersonalInfoRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFPersonalInfoRequest : NSObject

@property (nonatomic, copy, nullable) NSString *firstname;
@property (nonatomic, copy, nullable) NSString *lastname;
@property (nonatomic, readonly, nullable) NSString *displayName;
@property (nonatomic, copy, nullable) NSString *streetAddress;
@property (nonatomic, copy, nullable) NSString *streetAddress2;
@property (nonatomic, copy, nullable) NSString *recipientInfo;
@property (nonatomic, copy, nullable) NSString *city;
@property (nonatomic, copy, nullable) NSString *state;
@property (nonatomic, copy, nullable) NSString *zipCode;
@property (nonatomic, copy, nullable) NSString *country;

@end
