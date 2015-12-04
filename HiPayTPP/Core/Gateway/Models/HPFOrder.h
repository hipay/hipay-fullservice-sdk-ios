//
//  HPFOrder.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFPersonalInformation.h"

typedef NS_ENUM(char, HPFGender) {
    
    HPFGenderUndefined = ' ',
    HPFGenderUnknown = 'U',
    HPFGenderMale = 'M',
    HPFGenderFemale = 'F',
    
};

@interface HPFOrder : HPFPersonalInformation

@property (nonatomic, readonly) NSString *orderId;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, readonly) NSInteger attempts;
@property (nonatomic, readonly) NSNumber *amount;
@property (nonatomic, readonly) NSNumber *shipping;
@property (nonatomic, readonly) NSNumber *tax;
@property (nonatomic, readonly) NSNumber *decimals;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSString *customerId;
@property (nonatomic, readonly) NSString *language;
@property (nonatomic, readonly) HPFGender gender;
@property (nonatomic, readonly) HPFPersonalInformation *shippingAddress;

@end