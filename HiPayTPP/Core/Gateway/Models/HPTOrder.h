//
//  HPTOrder.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTOrder : NSObject

@property (nonatomic, readonly) NSString *orderId;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, readonly) NSString *attempts;
@property (nonatomic, readonly) NSString *amount;
@property (nonatomic, readonly) NSString *shipping;
@property (nonatomic, readonly) NSString *tax;
@property (nonatomic, readonly) NSString *decimals;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSString *customerId;
@property (nonatomic, readonly) NSString *language;
@property (nonatomic, readonly) NSString *msisdn;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *phoneOperator;
@property (nonatomic, readonly) NSString *email;

@end