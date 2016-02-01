//
//  HPFOrderRelatedRequest.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFCustomerInfoRequest.h"

#define HPFGatewayCallbackURLOrderPathName @"orders"

typedef NS_ENUM(NSInteger, HPFOrderRequestOperation) {
    HPFOrderRequestOperationUndefined,
    HPFOrderRequestOperationAuthorization,
    HPFOrderRequestOperationSale,
};

extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathAccept;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathDecline;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathPending;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathException;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathCancel;

@interface HPFOrderRelatedRequest : NSObject

@property (nonatomic, copy, nullable) NSString *orderId;
@property (nonatomic) HPFOrderRequestOperation operation;
@property (nonatomic, copy, nullable) NSString *shortDescription;
@property (nonatomic, copy, nullable) NSString *longDescription;
@property (nonatomic, copy, nullable) NSString *currency;
@property (nonatomic, copy, nullable) NSNumber *amount;
@property (nonatomic, copy, nullable) NSNumber *shipping;
@property (nonatomic, copy, nullable) NSNumber *tax;
@property (nonatomic, copy, nullable) NSString *clientId;
@property (nonatomic, copy, nullable) NSString *ipAddress;
@property (nonatomic, copy, nonnull) NSURL *acceptURL;
@property (nonatomic, copy, nonnull) NSURL *declineURL;
@property (nonatomic, copy, nonnull) NSURL *pendingURL;
@property (nonatomic, copy, nonnull) NSURL *exceptionURL;
@property (nonatomic, copy, nonnull) NSURL *cancelURL;
@property (nonatomic, copy, nullable) NSString *HTTPAccept;
@property (nonatomic, copy, nonnull) NSString *HTTPUserAgent;
@property (nonatomic, copy, nullable) NSString *deviceFingerprint;
@property (nonatomic, copy, nonnull) NSString *language;

@property (nonatomic, nonnull) HPFCustomerInfoRequest *customer;
@property (nonatomic, nonnull) HPFPersonalInfoRequest *shippingAddress;

@property (nonatomic, copy, nullable) NSDictionary *customData;

@property (nonatomic, copy, nullable) NSString *cdata1;
@property (nonatomic, copy, nullable) NSString *cdata2;
@property (nonatomic, copy, nullable) NSString *cdata3;
@property (nonatomic, copy, nullable) NSString *cdata4;
@property (nonatomic, copy, nullable) NSString *cdata5;
@property (nonatomic, copy, nullable) NSString *cdata6;
@property (nonatomic, copy, nullable) NSString *cdata7;
@property (nonatomic, copy, nullable) NSString *cdata8;
@property (nonatomic, copy, nullable) NSString *cdata9;
@property (nonatomic, copy, nullable) NSString *cdata10;

- (instancetype _Nonnull)initWithOrderRelatedRequest:(HPFOrderRelatedRequest * _Nonnull)orderRelatedRequest;

@end
