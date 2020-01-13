//
//  HPFOrderRelatedRequest.m
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import "HPFOrderRelatedRequest.h"
#import "HPFClientConfig.h"
#import "HPFGatewayClient.h"
#import "DevicePrint.h"

NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathAccept      = @"accept";
NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathDecline     = @"decline";
NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathPending     = @"pending";
NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathException   = @"exception";
NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathCancel      = @"cancel";

@interface HPFOrderRelatedRequest()

@property (nonatomic, copy, nullable) NSDictionary *source;
@property (nonatomic, nonnull) NSDictionary *browserInfo;
@property (nonatomic, nullable) NSString *deviceChannel;

@end

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
        self.operation = HPFOrderRequestOperationDefault;
        
        NSString * brand_version = [NSString stringWithFormat:@"%ld.%ld.%ld", (long)[[NSProcessInfo processInfo] operatingSystemVersion].majorVersion, (long)[[NSProcessInfo processInfo] operatingSystemVersion].minorVersion, (long)[[NSProcessInfo processInfo] operatingSystemVersion].patchVersion];
        
        NSBundle *coreBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HPFCoreLocalization" ofType:@"bundle"]];
        NSString *integration_version = [coreBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        
        self.source = @{
                        @"source" : @"CSDK",
                        @"brand" : @"ios",
                        @"brand_version" : brand_version,
                        @"integration_version" : integration_version
                        };
        
        self.deviceChannel = @"2";
        
        NSMutableDictionary *browserInfo = [NSMutableDictionary new];
        browserInfo[@"java_enabled"] = @(NO);
        browserInfo[@"javascript_enabled"] = @(YES);
        
        NSString *language = [NSBundle mainBundle].preferredLocalizations.firstObject;
        if (language) {
            browserInfo[@"language"] = language;
        }
        
        browserInfo[@"color_depth"] = @32;
        
        CGFloat scale = [UIScreen mainScreen].scale;
        browserInfo[@"screen_width"] = @([[UIScreen mainScreen] bounds].size.width * scale);
        browserInfo[@"screen_height"] = @([[UIScreen mainScreen] bounds].size.height * scale);
        
        browserInfo[@"timezone"] = @(-1 * NSTimeZone.localTimeZone.secondsFromGMT / 60);
        browserInfo[@"ipaddr"] = @"";
        browserInfo[@"http_accept"] = @"*/*";
        
        NSString *useragent = [HPFClientConfig sharedClientConfig].userAgent;
        if (useragent) {
            browserInfo[@"http_user_agent"] = useragent;
        }
        
        self.browserInfo = browserInfo;
    }
    
    return self;
}

- (NSString *)deviceFingerprint
{
    if (_deviceFingerprint == nil) {
        id devicePrintClass = NSClassFromString(@"DevicePrint");
        
        if ([devicePrintClass respondsToSelector:@selector(blackbox)]) {
            static dispatch_once_t onceBlock;
            static NSString *deviceFingerprint;
            
            dispatch_once (&onceBlock, ^{
                deviceFingerprint = [devicePrintClass blackbox];
            });
            
            _deviceFingerprint = deviceFingerprint;
        }
    }
    
    return _deviceFingerprint;
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
    
    self.acceptURL = [orderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", HPFOrderRelatedRequestRedirectPathAccept]];
    self.declineURL = [orderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", HPFOrderRelatedRequestRedirectPathDecline]];
    self.pendingURL = [orderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", HPFOrderRelatedRequestRedirectPathPending]];
    self.exceptionURL = [orderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", HPFOrderRelatedRequestRedirectPathException]];
    self.cancelURL = [orderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", HPFOrderRelatedRequestRedirectPathCancel]];
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
    
    request.merchantRiskStatement = orderRelatedRequest.merchantRiskStatement;
    request.previousAuthInfo = orderRelatedRequest.previousAuthInfo;
    request.accountInfo = orderRelatedRequest.accountInfo;
    request.deviceChannel = orderRelatedRequest.deviceChannel;
    request.browserInfo = orderRelatedRequest.browserInfo;
    
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
    
    request.source = orderRelatedRequest.source;

    return request;
}

@end
