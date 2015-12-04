//
//  HPFPersonalInfoRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFPersonalInfoRequest : NSObject

@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *streetAddress2;
@property (nonatomic, copy) NSString *recipientInfo;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSString *country;

@end
