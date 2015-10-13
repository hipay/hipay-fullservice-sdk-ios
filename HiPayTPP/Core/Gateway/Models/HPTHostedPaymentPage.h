//
//  HPTHostedPaymentPage.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTOrder.h"

@interface HPTHostedPaymentPage : NSObject

@property (nonatomic, readonly) BOOL test;
@property (nonatomic, readonly) NSString *mid;
@property (nonatomic, readonly) NSURL *forwardUrl;

@property (nonatomic, readonly) HPTOrder *order;

@property (nonatomic, readonly) NSString *cdata1;
@property (nonatomic, readonly) NSString *cdata2;
@property (nonatomic, readonly) NSString *cdata3;
@property (nonatomic, readonly) NSString *cdata4;
@property (nonatomic, readonly) NSString *cdata5;
@property (nonatomic, readonly) NSString *cdata6;
@property (nonatomic, readonly) NSString *cdata7;
@property (nonatomic, readonly) NSString *cdata8;
@property (nonatomic, readonly) NSString *cdata9;
@property (nonatomic, readonly) NSString *cdata10;

@end