//
//  HPFMonitoring.h
//  HiPayFullservice_Example
//
//  Created by HiPay on 02/09/2019.
//  Copyright © 2019 HiPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPFMonitoring : NSObject

@property (nonatomic, strong) NSDate *initializeDate;
@property (nonatomic, strong) NSDate *displayDate;
@property (nonatomic, strong) NSDate *payDate;
@property (nonatomic, strong) NSDate *requestDate;
@property (nonatomic, strong) NSDate *responseDate;

- (NSDictionary *)toJSON;

@end
