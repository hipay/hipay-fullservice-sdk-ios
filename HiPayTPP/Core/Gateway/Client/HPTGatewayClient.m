//
//  HPTGatewayClient.m
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import "HPTGatewayClient.h"
#import "HPTAbstractClient+Private.h"
#import "HPTHostedPaymentPageRequestSerializationMapper.h"
#import "HPTOrderRequestSerializationMapper.h"

@implementation HPTGatewayClient

- (instancetype)initWithHTTPClient:(HPTHTTPClient *)theHTTPClient clientConfig:(HPTClientConfig *)theClientConfig
{
    self = [super init];
    if (self) {
        HTTPClient = theHTTPClient;
        clientConfig = theClientConfig;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        HTTPClient = [HPTGatewayClient createClient];
        clientConfig = [HPTClientConfig sharedClientConfig];
    }
    return self;
}

+ (HPTHTTPClient *)createClient
{
    NSString *baseURL;
    
    switch ([HPTClientConfig sharedClientConfig].environment) {
        case HPTEnvironmentProduction:
            baseURL = HPTGatewayClientBaseURLProduction;
            break;
            
        case HPTEnvironmentStage:
            baseURL = HPTGatewayClientBaseURLStage;
            break;
    }
    
    return [[HPTHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL] username:[HPTClientConfig sharedClientConfig].username password:[HPTClientConfig sharedClientConfig].password];
    
}

- (void)handleRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass completionHandler:(void (^)(id result, NSError *error))completionBlock
{
    [HTTPClient performRequestWithMethod:method path:path parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        if (error == nil) {
            id result = ((HPTAbstractMapper *)[responseMapperClass mapperWithRawData:response.body]).mappedObject;
            
            if (result != nil) {
                completionBlock(result, nil);
            } else {
                completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeAPIOther userInfo:@{NSLocalizedFailureReasonErrorKey: @"Malformed server response"}]);
            }
            
        } else {
            completionBlock(nil, [self errorForResponseBody:response.body andError:error]);
        }
    }];
}

- (void)initializeHostedPaymentPageRequest:(HPTHostedPaymentPageRequest *)hostedPaymentPageRequest withCompletionHandler:(HPTHostedPaymentPageCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPTHostedPaymentPageRequestSerializationMapper mapperWithRequest:hostedPaymentPageRequest].serializedRequest;
    
    [self handleRequestWithMethod:HPTHTTPMethodPost path:@"hpayment" parameters:parameters responseMapperClass:[HPTHostedPaymentPageMapper class] completionHandler:completionBlock];
}

@end
