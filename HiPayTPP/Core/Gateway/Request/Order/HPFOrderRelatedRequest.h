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

@interface HPFOrderRelatedRequest : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic) HPFOrderRequestOperation operation;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSString *longDescription;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSNumber *shipping;
@property (nonatomic, copy) NSNumber *tax;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, copy) NSURL *acceptURL;
@property (nonatomic, copy) NSURL *declineURL;
@property (nonatomic, copy) NSURL *pendingURL;
@property (nonatomic, copy) NSURL *exceptionURL;
@property (nonatomic, copy) NSURL *cancelURL;
@property (nonatomic, copy) NSString *HTTPAccept;
@property (nonatomic, copy) NSString *HTTPUserAgent;
@property (nonatomic, copy) NSString *deviceFingerprint;
@property (nonatomic, copy) NSString *language;

@property (nonatomic) HPFCustomerInfoRequest *customer;
@property (nonatomic) HPFPersonalInfoRequest *shippingAddress;

@property (nonatomic, copy) NSDictionary *customData;

@property (nonatomic, copy) NSString *cdata1;
@property (nonatomic, copy) NSString *cdata2;
@property (nonatomic, copy) NSString *cdata3;
@property (nonatomic, copy) NSString *cdata4;
@property (nonatomic, copy) NSString *cdata5;
@property (nonatomic, copy) NSString *cdata6;
@property (nonatomic, copy) NSString *cdata7;
@property (nonatomic, copy) NSString *cdata8;
@property (nonatomic, copy) NSString *cdata9;
@property (nonatomic, copy) NSString *cdata10;

- (instancetype)initWithOrderRelatedRequest:(HPFOrderRelatedRequest *)orderRelatedRequest;

@end
