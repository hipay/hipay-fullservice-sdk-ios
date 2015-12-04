//
//  HPFGatewayClient.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <HiPayFullservice/HiPayFullservice.h>
#import "HPFHTTPClient.h"
#import "HPFClientConfig.h"
#import "HPFAbstractClient.h"

#import "HPFHostedPaymentPage.h"
#import "HPFOperation.h"
#import "HPFTransaction.h"

#import "HPFPaymentPageRequest.h"
#import "HPFOrderRequest.h"
#import "HPFPaymentProduct.h"

#define HPFGatewayClientBaseURLStage        @"https://stage-secure-gateway.hipay-tpp.com/rest/v1/"
#define HPFGatewayClientBaseURLProduction   @"https://secure-gateway.hipay-tpp.com/rest/v1/"
#define HPFGatewayCallbackURLPathName       @"gateway"

extern NSString *const HPFGatewayClientDidRedirectSuccessfullyNotification;
extern NSString *const HPFGatewayClientDidRedirectWithMappingErrorNotification;

typedef void (^HPFHostedPaymentPageCompletionBlock)(HPFHostedPaymentPage *hostedPaymentPage, NSError *error);
typedef void (^HPFOperationCompletionBlock)(HPFOperation *operation, NSError *error);
typedef void (^HPFTransactionCompletionBlock)(HPFTransaction *transaction, NSError *error);
typedef void (^HPFTransactionsCompletionBlock)(NSArray <HPFTransaction *> *transactions, NSError *error);
typedef void (^HPFPaymentProductsCompletionBlock)(NSArray <HPFPaymentProduct *> *paymentProducts, NSError *error);

@interface HPFGatewayClient : HPFAbstractClient
{
    HPFHTTPClient *HTTPClient;
    HPFClientConfig *clientConfig;
}

+ (instancetype)sharedClient;
+ (BOOL)isTransactionErrorFinal:(NSError *)error;

- (id<HPFRequest>)initializeHostedPaymentPageRequest:(HPFPaymentPageRequest *)hostedPaymentPageRequest withCompletionHandler:(HPFHostedPaymentPageCompletionBlock)completionBlock;

- (id<HPFRequest>)requestNewOrder:(HPFOrderRequest *)orderRequest withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock;

- (id<HPFRequest>)getTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPFTransactionCompletionBlock)completionBlock;

- (id<HPFRequest>)getTransactionsWithOrderId:(NSString *)orderId withCompletionHandler:(HPFTransactionsCompletionBlock)completionBlock;

- (id<HPFRequest>)performMaintenanceOperation:(HPFOperationType)operation amount:(NSNumber *)amount onTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPFOperationCompletionBlock)completionBlock;

- (id<HPFRequest>)getPaymentProductsForRequest:(HPFPaymentPageRequest *)paymentPageRequest withCompletionHandler:(HPFPaymentProductsCompletionBlock)completionBlock;

- (BOOL)handleOpenURL:(NSURL *)URL;

@end