//
//  HPTOrderRelatedRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPTOrderRelatedRequest.h"

@implementation HPTOrderRelatedRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [[NSLocale currentLocale] localeIdentifier];
    }
    return self;
}

- (instancetype)initWithOrderRelatedRequest:(HPTOrderRelatedRequest *)orderRelatedRequest
{
    HPTOrderRelatedRequest *request = [self init];
    
    request.orderId = orderRelatedRequest.orderId;
    request.operation = orderRelatedRequest.operation;
    request.shortDescription = orderRelatedRequest.shortDescription;
    request.longDescription = orderRelatedRequest.longDescription;
    request.currency = orderRelatedRequest.currency;
    request.amount = orderRelatedRequest.amount;
    request.shipping = orderRelatedRequest.shipping;
    request.tax = orderRelatedRequest.tax;
    request.clientId = orderRelatedRequest.clientId;
    request.ipAddress = orderRelatedRequest.ipAddress;
    request.acceptURL = orderRelatedRequest.acceptURL;
    request.declineURL = orderRelatedRequest.declineURL;
    request.pendingURL = orderRelatedRequest.pendingURL;
    request.exceptionURL = orderRelatedRequest.exceptionURL;
    request.cancelURL = orderRelatedRequest.cancelURL;
    request.HTTPAccept = orderRelatedRequest.HTTPAccept;
    request.HTTPUserAgent = orderRelatedRequest.HTTPUserAgent;
    request.deviceFingerprint = orderRelatedRequest.deviceFingerprint;
    request.language = orderRelatedRequest.language;

    request.customer = orderRelatedRequest.customer;
    request.shippingAddress = orderRelatedRequest.shippingAddress;

    request.customData = orderRelatedRequest.customData;
    
    request.cdata1 = orderRelatedRequest.cdata1;
    request.cdata2 = orderRelatedRequest.cdata2;
    request.cdata3 = orderRelatedRequest.cdata3;
    request.cdata4 = orderRelatedRequest.cdata4;
    request.cdata5 = orderRelatedRequest.cdata5;
    request.cdata6 = orderRelatedRequest.cdata6;
    request.cdata7 = orderRelatedRequest.cdata7;
    request.cdata8 = orderRelatedRequest.cdata8;
    request.cdata9 = orderRelatedRequest.cdata9;
    request.cdata10 = orderRelatedRequest.cdata10;
    
    return request;
}

@end
