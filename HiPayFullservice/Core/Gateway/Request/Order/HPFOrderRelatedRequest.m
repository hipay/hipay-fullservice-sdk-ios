//
//  HPFOrderRelatedRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFClientConfig.h"
#import "HPFGatewayClient.h"
#import "DevicePrint.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation HPFOrderRelatedRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [[NSLocale currentLocale] localeIdentifier];
        [self defineURLParameters];
        self.customer = [[HPFCustomerInfoRequest alloc] init];
        self.shippingAddress = [[HPFPersonalInfoRequest alloc] init];
        self.HTTPUserAgent = [HPFClientConfig sharedClientConfig].userAgent;

        id devicePrintClass = NSClassFromString(@"DevicePrint");
        
        if ([devicePrintClass respondsToSelector:@selector(blackbox)]) {
            self.deviceFingerprint = [devicePrintClass blackbox];
        }
    }
    
    return self;
}

- (void)defineURLParameters
{
    NSURL *appURL = [HPFClientConfig sharedClientConfig].appRedirectionURL;
    
    NSString *baseString;
    
    if (self.orderId == nil) {
        baseString = [NSString stringWithFormat:@"/%@/%@", HPFGatewayCallbackURLPathName, HPFGatewayCallbackURLOrderPathName];
    } else {
        baseString = [NSString stringWithFormat:@"/%@/%@/%@", HPFGatewayCallbackURLPathName, HPFGatewayCallbackURLOrderPathName, self.orderId];
    }
    
    NSURL *orderURL = [appURL URLByAppendingPathComponent:baseString];
    
    self.acceptURL = [orderURL URLByAppendingPathComponent:@"/accept"];
    self.declineURL = [orderURL URLByAppendingPathComponent:@"/decline"];
    self.pendingURL = [orderURL URLByAppendingPathComponent:@"/pending"];
    self.exceptionURL = [orderURL URLByAppendingPathComponent:@"/exception"];
    self.cancelURL = [orderURL URLByAppendingPathComponent:@"/cancel"];
}

- (void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
    [self defineURLParameters];
}

- (instancetype)initWithOrderRelatedRequest:(HPFOrderRelatedRequest *)orderRelatedRequest
{
    HPFOrderRelatedRequest *request = [self init];
    
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
