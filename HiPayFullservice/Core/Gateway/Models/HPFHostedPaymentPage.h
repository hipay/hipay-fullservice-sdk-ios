//
//  HPFHostedPaymentPage.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFOrder.h"

/**
 *  Describes a hosted payment page and its information (particularly its forward URL)
 */
@interface HPFHostedPaymentPage : NSObject

/**
 *  Whether the transaction is a testing transaction.
 */
@property (nonatomic, readonly) BOOL test;

/**
 *  Your merchant account number (issued to you by HiPay).
 */
@property (nonatomic, readonly, nonnull) NSString *mid;

/**
 *  The hosted payment page URL.
 */
@property (nonatomic, readonly, nonnull) NSURL *forwardUrl;

/**
 *  The related order.
 */
@property (nonatomic, readonly, nonnull) HPFOrder *order;

/**
 *  Custom data 1.
 */
@property (nonatomic, readonly, nullable) NSString *cdata1;

/**
 *  Custom data 2.
 */
@property (nonatomic, readonly, nullable) NSString *cdata2;

/**
 *  Custom data 3.
 */
@property (nonatomic, readonly, nullable) NSString *cdata3;

/**
 *  Custom data 4.
 */
@property (nonatomic, readonly, nullable) NSString *cdata4;

/**
 *  Custom data 5.
 */
@property (nonatomic, readonly, nullable) NSString *cdata5;

/**
 *  Custom data 6.
 */
@property (nonatomic, readonly, nullable) NSString *cdata6;

/**
 *  Custom data 7.
 */
@property (nonatomic, readonly, nullable) NSString *cdata7;

/**
 *  Custom data 8.
 */
@property (nonatomic, readonly, nullable) NSString *cdata8;

/**
 *  Custom data 9.
 */
@property (nonatomic, readonly, nullable) NSString *cdata9;

/**
 *  Custom data 10.
 */
@property (nonatomic, readonly, nullable) NSString *cdata10;

@end