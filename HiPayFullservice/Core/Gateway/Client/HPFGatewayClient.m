//
//  HPFGatewayClient.m
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import "HPFGatewayClient.h"
#import "HPFAbstractClient+Private.h"
#import "HPFPaymentPageRequestSerializationMapper.h"
#import "HPFOrderRequestSerializationMapper.h"
#import "HPFArrayMapper.h"
#import "HPFTransactionCallbackMapper.h"
#import "HPFHostedPaymentPageMapper.h"
#import "HPFTransactionMapper.h"
#import "HPFTransactionDetailsMapper.h"
#import "HPFPaymentProductMapper.h"
#import "HPFOperationMapper.h"
#import "HPFLogger.h"

NSString * _Nonnull const HPFGatewayClientDidRedirectSuccessfullyNotification = @"HPFGatewayClientDidRedirectSuccessfullyNotification";
NSString * _Nonnull const HPFGatewayClientDidRedirectWithMappingErrorNotification = @"HPFGatewayClientDidRedirectWithMappingErrorNotification";

@interface HPFGatewayClient ()
{
    HPFHTTPClient *HTTPClient;
    HPFClientConfig *clientConfig;
}

@end

@implementation HPFGatewayClient

+ (instancetype)sharedClient
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (BOOL)isTransactionErrorFinal:(NSError *)error
{
    if ([error.domain isEqual:HPFHiPayFullserviceErrorDomain]) {
        if (error.code == HPFErrorCodeAPICheckout) {
            
            if (error.userInfo[HPFErrorCodeAPICodeKey] != nil) {
                NSInteger code = [error.userInfo[HPFErrorCodeAPICodeKey] integerValue];
                
                NSMutableIndexSet *finalErrors = [NSMutableIndexSet indexSet];
                
                [finalErrors addIndex:HPFErrorAPIMaxAttemptsExceeded];
                [finalErrors addIndex:HPFErrorAPIDuplicateOrder];
                
                return [finalErrors containsIndex:code];
            }
        }
    }
    
    return NO;
}

- (instancetype)initWithHTTPClient:(HPFHTTPClient *)theHTTPClient clientConfig:(HPFClientConfig *)theClientConfig
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
        HTTPClient = [HPFGatewayClient createClient];
        clientConfig = [HPFClientConfig sharedClientConfig];
    }
    return self;
}

+ (HPFHTTPClient *)createClient
{
    NSString *baseURL;
    
    switch ([HPFClientConfig sharedClientConfig].environment) {
        case HPFEnvironmentProduction:
            baseURL = HPFGatewayClientBaseURLProduction;
            break;
            
        case HPFEnvironmentStage:
            baseURL = HPFGatewayClientBaseURLStage;
            break;
    }
    
    return [[HPFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL] username:[HPFClientConfig sharedClientConfig].username password:[HPFClientConfig sharedClientConfig].password];
    
}

- (id<HPFRequest>)handleRequestWithMethod:(HPFHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock
{
    return [HTTPClient performRequestWithMethod:method path:path parameters:parameters completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        if (completionBlock != nil) {
            
            NSError *resultError = nil;
            id resultObject = nil;
            
            if (error == nil) {
                id result;
                
                if (!isArray) {
                    result = ((HPFAbstractMapper *)[responseMapperClass mapperWithRawData:response.body]).mappedObject;
                } else {
                    result = ((HPFAbstractMapper *)[HPFArrayMapper mapperWithRawData:response.body objectMapperClass:responseMapperClass]).mappedObject;
                }
                
                if (result != nil) {
                    resultObject = result;
                } else {
                    resultError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeAPIOther userInfo:@{NSLocalizedFailureReasonErrorKey: @"Malformed server response"}];
                }
                
            } else {
                resultError = [self errorForResponseBody:response.body andError:error];
            }
            
            if (resultError != nil) {
                [[HPFLogger sharedLogger] debug:@"<Gateway>: %@", error];
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

- (id<HPFRequest>)initializeHostedPaymentPageRequest:(HPFPaymentPageRequest *)hostedPaymentPageRequest withCompletionHandler:(HPFHostedPaymentPageCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPFPaymentPageRequestSerializationMapper mapperWithRequest:hostedPaymentPageRequest].serializedRequest;
    
    return [self handleRequestWithMethod:HPFHTTPMethodPost path:@"hpayment" parameters:parameters responseMapperClass:[HPFHostedPaymentPageMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPFRequest>)requestNewOrder:(HPFOrderRequest *)orderRequest withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPFOrderRequestSerializationMapper mapperWithRequest:orderRequest].serializedRequest;
        
    return [self handleRequestWithMethod:HPFHTTPMethodPost path:@"order" parameters:parameters responseMapperClass:[HPFTransactionMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPFRequest>)getTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock
{
    return [self handleRequestWithMethod:HPFHTTPMethodGet path:[@"transaction/" stringByAppendingString:transactionReference] parameters:@{} responseMapperClass:[HPFTransactionDetailsMapper class] isArray:NO completionHandler:^(id result, NSError *error) {
        
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

- (id<HPFRequest>)getTransactionsWithOrderId:(NSString *)orderId withCompletionHandler:(HPFTransactionsCompletionBlock)completionBlock
{
    return [self handleRequestWithMethod:HPFHTTPMethodGet path:@"transaction" parameters:@{@"orderid": orderId} responseMapperClass:[HPFTransactionDetailsMapper class] isArray:NO completionHandler:completionBlock];
}

- (NSString *)operationValueForOperationType:(HPFOperationType)operationType
{
    switch (operationType) {
            
        case HPFOperationTypeCapture:
            return @"capture";
            
        case HPFOperationTypeCancel:
            return @"cancel";
            
        case HPFOperationTypeAcceptChallenge:
            return @"acceptChallenge";
            
        case HPFOperationTypeDenyChallenge:
            return @"denyChallenge";
            
        case HPFOperationTypeRefund:
            return @"refund";
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown operation %ld, please refer to HPFOperationType to get the full list of available operation types.", (long)operationType] userInfo:nil];
            
            break;
    }
}

- (id<HPFRequest>)performMaintenanceOperation:(HPFOperationType)operation amount:(NSNumber *)amount onTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPFOperationCompletionBlock)completionBlock
{
    NSString *operationName = [self operationValueForOperationType:operation];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"operation": operationName}];
    
    if (amount != nil) {
        parameters[@"amount"] = [HPFAbstractSerializationMapper formatAmountNumber:amount];
    }
    
    return [self handleRequestWithMethod:HPFHTTPMethodPost path:[@"maintenance/transaction/" stringByAppendingString:transactionReference] parameters:parameters responseMapperClass:[HPFOperationMapper class] isArray:NO completionHandler:completionBlock];
}

- (id<HPFRequest>)getPaymentProductsForRequest:(HPFPaymentPageRequest *)paymentPageRequest withCompletionHandler:(HPFPaymentProductsCompletionBlock)completionBlock
{
    NSDictionary *parameters = [HPFPaymentPageRequestSerializationMapper mapperWithRequest:paymentPageRequest].serializedRequest;
    
    return [self handleRequestWithMethod:HPFHTTPMethodGet path:@"payment_products" parameters:parameters responseMapperClass:[HPFPaymentProductMapper class] isArray:YES completionHandler:completionBlock];
}

- (BOOL)isRedirectURLComponentsPathValid:(NSArray *)pathComponents
{
    NSArray *existingRedirectPath = @[HPFOrderRelatedRequestRedirectPathAccept, HPFOrderRelatedRequestRedirectPathDecline, HPFOrderRelatedRequestRedirectPathPending, HPFOrderRelatedRequestRedirectPathException, HPFOrderRelatedRequestRedirectPathCancel];

    return (pathComponents.count == 5) && [pathComponents[1] isEqualToString:HPFGatewayCallbackURLPathName] && [pathComponents[2] isEqualToString:HPFGatewayCallbackURLOrderPathName] && [existingRedirectPath containsObject:pathComponents[4]];
}

- (BOOL)handleOpenURL:(NSURL *)URL
{
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
    
    if ([URLComponents.host isEqualToString:HPFClientConfigCallbackURLHost]) {
        
        NSArray *pathComponents = [URLComponents.path componentsSeparatedByString:@"/"];
        
        if ([self isRedirectURLComponentsPathValid:pathComponents]) {
         
            NSMutableDictionary *values = [NSMutableDictionary dictionary];
            
            for (NSURLQueryItem *item in URLComponents.queryItems) {
                [values setObject:item.value forKey:item.name];
            }

            NSMutableDictionary *notificationInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"orderId": pathComponents[3], @"path": pathComponents[4]}];
            
            HPFTransaction *transaction = [HPFTransactionCallbackMapper mapperWithRawData:values].mappedObject;
            
            if (transaction != nil) {
                
                [[HPFLogger sharedLogger] debug:@"<Gateway>: Handles valid URL with mapped transaction %@", transaction.transactionReference];
                
                [notificationInfo setObject:transaction forKey:@"transaction"];
                [[NSNotificationCenter defaultCenter] postNotificationName:HPFGatewayClientDidRedirectSuccessfullyNotification object:nil userInfo:notificationInfo];
            }
            
            else {
                
                [[HPFLogger sharedLogger] debug:@"<Gateway>: Handles valid URL without mapped transaction"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HPFGatewayClientDidRedirectWithMappingErrorNotification object:nil userInfo:notificationInfo];
            }
            
            return YES;
        }
        
        [[HPFLogger sharedLogger] emerg:@"<Gateway>: Could not handle invalid URL: %@", URL];
    }

    return NO;
}

@end
