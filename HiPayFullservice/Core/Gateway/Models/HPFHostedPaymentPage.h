//
//  HPFHostedPaymentPage.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFOrder.h"

@interface HPFHostedPaymentPage : NSObject

@property (nonatomic, readonly) BOOL test;
@property (nonatomic, readonly, nonnull) NSString *mid;
@property (nonatomic, readonly, nonnull) NSURL *forwardUrl;

@property (nonatomic, readonly, nonnull) HPFOrder *order;

@property (nonatomic, readonly, nullable) NSString *cdata1;
@property (nonatomic, readonly, nullable) NSString *cdata2;
@property (nonatomic, readonly, nullable) NSString *cdata3;
@property (nonatomic, readonly, nullable) NSString *cdata4;
@property (nonatomic, readonly, nullable) NSString *cdata5;
@property (nonatomic, readonly, nullable) NSString *cdata6;
@property (nonatomic, readonly, nullable) NSString *cdata7;
@property (nonatomic, readonly, nullable) NSString *cdata8;
@property (nonatomic, readonly, nullable) NSString *cdata9;
@property (nonatomic, readonly, nullable) NSString *cdata10;

@end