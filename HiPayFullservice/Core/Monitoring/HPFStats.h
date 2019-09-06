//
//  HPFStats.h
//  HiPayFullservice_Example
//
//  Created by Morgan BAUMARD on 02/09/2019.
//  Copyright © 2019 Jonathan TIRET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPFMonitoring.h"
#import "HPFComponent.h"

typedef NS_ENUM(NSInteger, HPFEvent) {
    HPFEventInit,
    HPFEventTokenize,
    HPFEventRequest
};

@interface HPFStats : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSString *cardCountry;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, assign) HPFEvent event;

@property (nonatomic, strong) HPFMonitoring *monitoring;


- (NSDictionary *)toJSON;
- (void)send;

@property (class, nonatomic, strong) HPFStats *current;


@end
