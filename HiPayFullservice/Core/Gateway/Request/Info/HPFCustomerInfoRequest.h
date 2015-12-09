//
//  HPFCustomerInfoRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPersonalInfoRequest.h"
#import "HPFOrder.h"

@interface HPFCustomerInfoRequest : HPFPersonalInfoRequest

@property (nonatomic, copy, nullable) NSString *email;
@property (nonatomic, copy, nullable) NSString *phone;
@property (nonatomic, copy, nullable) NSNumber *birthDateDay;
@property (nonatomic, copy, nullable) NSNumber *birthDateMonth;
@property (nonatomic, copy, nullable) NSNumber *birthDateYear;
@property (nonatomic) HPFGender gender;

@end
