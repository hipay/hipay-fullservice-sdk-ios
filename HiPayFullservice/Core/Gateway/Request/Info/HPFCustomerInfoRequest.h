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

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSNumber *birthDateDay;
@property (nonatomic, copy) NSNumber *birthDateMonth;
@property (nonatomic, copy) NSNumber *birthDateYear;
@property (nonatomic) HPFGender gender;

@end
