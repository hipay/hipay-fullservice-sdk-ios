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

@property (nonatomic, readonly, nonnull) NSString *orderId;
@property (nonatomic, readonly, nonnull) NSDate *dateCreated;
@property (nonatomic, readonly) NSInteger attempts;
@property (nonatomic, readonly, nonnull) NSNumber *amount;
@property (nonatomic, readonly, nullable) NSNumber *shipping;
@property (nonatomic, readonly, nullable) NSNumber *tax;
@property (nonatomic, readonly, nonnull) NSNumber *decimals;
@property (nonatomic, readonly, nonnull) NSString *currency;
@property (nonatomic, readonly, nullable) NSString *customerId;
@property (nonatomic, readonly, nullable) NSString *language;
@property (nonatomic, readonly) HPFGender gender;
@property (nonatomic, readonly, nullable) HPFPersonalInformation *shippingAddress;

@end