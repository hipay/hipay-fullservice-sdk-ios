//
//  HPTGatewayClient.m
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import "HPTGatewayClient.h"
#import "HPTAbstractClient+Private.h"
#import "HPTPaymentPageRequestSerializationMapper.h"
#import "HPTOrderRequestSerializationMapper.h"
#import "HPTArrayMapper.h"

HPTGatewayClient *HPTGatewayClientSharedInstance = nil;

@implementation HPTGatewayClient

+ (instancetype)sharedClient
{
    if (HPTGatewayClientSharedInstance == nil) {
        HPTGatewayClientSharedInstance = [[HPTGatewayClient alloc] init];
    }
    
    return HPTGatewayClientSharedInstance;
}

+ (BOOL)isTransactionErrorFinal:(NSError *)error
{
    if (error.domain == HPTHiPayTPPErrorDomain) {
        if (error.code == HPTErrorCodeAPICheckout) {
            return [error.userInfo[HPTErrorCodeAPICodeKey] isEqualToNumber:@(3010003)] || [error.userInfo[HPTErrorCodeAPICodeKey] isEqualToNumber:@(3010004)];
        }
    }
    
    return NO;
}

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

- (id<HPTRequest>)handleRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock
{
    return [HTTPClient performRequestWithMethod:method path:path parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        if (completionBlock != nil) {
            
            NSError *resultError = nil;
            id resultObject = nil;
            
            if (error == nil) {
                id result;
                
                if (!isArray) {
                    result = ((HPTAbstractMapper *)[responseMapperClass mapperWithRawData:response.body]).mappedObject;
                } else {
                    result = ((HPTAbstractMapper *)[HPTArrayMapper mapperWithRawData:response.body objectMapperClass:responseMapperClass]).mappedObject;
                }
                
                if (result != nil) {
                    resultObject = result;
                } else {
                    resultError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeAPIOther userInfo:@{NSLocalizedFailureReasonErrorKey: @"Malformed server response"}];
                }
                
            } else {
                resultError = [self errorForResponseBody:response.body andError:error];
            }
            
            if ([NSThread isMainThread]) {
                completionBlock(resultObject, resultError);
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(resultObject, resultError);
                });
            }
        }
    }];
}

- (id<HPTRequest>)initializeHostedPaymentPageRequest:(HPTPaymentPageRequest *)hostedPaymentPageRequest withCompletionHandler:(HPTHostedPaymentPageCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPTPaymentPageRequestSerializationMapper mapperWithRequest:hostedPaymentPageRequest].serializedRequest;
    
    return [self handleRequestWithMethod:HPTHTTPMethodPost path:@"hpayment" parameters:parameters responseMapperClass:[HPTHostedPaymentPageMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPTRequest>)requestNewOrder:(HPTOrderRequest *)orderRequest withCompletionHandler:(HPTTransactionCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPTOrderRequestSerializationMapper mapperWithRequest:orderRequest].serializedRequest;
    
    return [self handleRequestWithMethod:HPTHTTPMethodPost path:@"order" parameters:parameters responseMapperClass:[HPTTransactionMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPTRequest>)getTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPTTransactionCompletionBlock)completionBlock
{
    return [self handleRequestWithMethod:HPTHTTPMethodGet path:[@"transaction/" stringByAppendingString:transactionReference] parameters:@{} responseMapperClass:[HPTTransactionDetailsMapper class] isArray:NO completionHandler:^(id result, NSError *error) {
        
        NSError *resultError = nil;
        id resultObject = nil;
        
        if (error == nil) {
            if (result[0] != nil) {
                resultObject = result[0];
            }
        } else {
            resultError = error;
        }
        
        if ([NSThread isMainThread]) {
            completionBlock(resultObject, resultError);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(resultObject, resultError);
            });
        }
        
    }];
}

- (id<HPTRequest>)getTransactionsWithOrderId:(NSString *)orderId withCompletionHandler:(HPTTransactionsCompletionBlock)completionBlock
{
    return [self handleRequestWithMethod:HPTHTTPMethodGet path:@"transaction" parameters:@{@"orderid": orderId} responseMapperClass:[HPTTransactionDetailsMapper class] isArray:NO completionHandler:completionBlock];
}

- (NSString *)operationValueForOperationType:(HPTOperationType)operationType
{
    switch (operationType) {
            
        case HPTOperationTypeCapture:
            return @"capture";
            
        case HPTOperationTypeCancel:
            return @"cancel";
            
        case HPTOperationTypeAcceptChallenge:
            return @"acceptChallenge";
            
        case HPTOperationTypeDenyChallenge:
            return @"denyChallenge";
            
        case HPTOperationTypeRefund:
            return @"refund";
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown operation %ld, please refer to HPTOperationType to get the full list of available operation types.", (long)operationType] userInfo:nil];
            
            break;
    }
}

- (id<HPTRequest>)performMaintenanceOperation:(HPTOperationType)operation amount:(NSNumber *)amount onTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPTOperationCompletionBlock)completionBlock
{
    NSString *operationName = [self operationValueForOperationType:operation];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"operation": operationName}];
    
    if (amount != nil) {
        parameters[@"amount"] = [HPTAbstractSerializationMapper formatAmountNumber:amount];
    }
    
    return [self handleRequestWithMethod:HPTHTTPMethodPost path:[@"maintenance/transaction/" stringByAppendingString:transactionReference] parameters:parameters responseMapperClass:[HPTOperationMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPTRequest>)getPaymentProductsForRequest:(HPTPaymentPageRequest *)paymentPageRequest withCompletionHandler:(HPTPaymentProductsCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPTPaymentPageRequestSerializationMapper mapperWithRequest:paymentPageRequest].serializedRequest;
    
    return [self handleRequestWithMethod:HPTHTTPMethodGet path:@"payment_products" parameters:parameters responseMapperClass:[HPTPaymentProductMapper class] isArray:YES completionHandler:completionBlock];
}

@end
