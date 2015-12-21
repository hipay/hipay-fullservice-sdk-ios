//
//  HPFGatewayClient.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

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

extern NSString * _Nonnull const HPFGatewayClientDidRedirectSuccessfullyNotification;
extern NSString * _Nonnull const HPFGatewayClientDidRedirectWithMappingErrorNotification;

typedef void (^HPFHostedPaymentPageCompletionBlock)(HPFHostedPaymentPage  * _Nullable hostedPaymentPage, NSError * _Nullable error);
typedef void (^HPFOperationCompletionBlock)(HPFOperation * _Nullable operation, NSError * _Nullable error);
typedef void (^HPFTransactionCompletionBlock)(HPFTransaction * _Nullable transaction, NSError * _Nullable error);
typedef void (^HPFTransactionsCompletionBlock)(NSArray <HPFTransaction *> * _Nullable transactions, NSError * _Nullable error);
typedef void (^HPFPaymentProductsCompletionBlock)(NSArray <HPFPaymentProduct *> * _Nonnull paymentProducts, NSError * _Nullable error);

@interface HPFGatewayClient : HPFAbstractClient
{
    HPFHTTPClient *HTTPClient;
    HPFClientConfig *clientConfig;
}

+ (_Nonnull instancetype)sharedClient;

+ (BOOL)isTransactionErrorFinal:(NSError * _Nonnull)error;

- (id<HPFRequest> _Nonnull)initializeHostedPaymentPageRequest:(HPFPaymentPageRequest * _Nonnull)hostedPaymentPageRequest withCompletionHandler:(HPFHostedPaymentPageCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)requestNewOrder:(HPFOrderRequest * _Nonnull)orderRequest withCompletionHandler:(HPFTransactionCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)getTransactionWithReference:(NSString * _Nonnull)transactionReference withCompletionHandler:(HPFTransactionCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)getTransactionsWithOrderId:(NSString * _Nonnull)orderId withCompletionHandler:(HPFTransactionsCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)performMaintenanceOperation:(HPFOperationType)operation amount:(NSNumber * _Nullable)amount onTransactionWithReference:(NSString * _Nonnull)transactionReference withCompletionHandler:(HPFOperationCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)getPaymentProductsForRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest withCompletionHandler:(HPFPaymentProductsCompletionBlock _Nullable)completionBlock;

- (BOOL)handleOpenURL:(NSURL * _Nonnull)URL;

@end