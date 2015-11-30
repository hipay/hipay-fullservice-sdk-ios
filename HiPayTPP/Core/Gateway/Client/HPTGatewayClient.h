//
//  HPTGatewayClient.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <HiPayTPP/HiPayTPP.h>
#import "HPTHTTPClient.h"
#import "HPTClientConfig.h"
#import "HPTAbstractClient.h"

#import "HPTHostedPaymentPage.h"
#import "HPTOperation.h"
#import "HPTTransaction.h"

#import "HPTPaymentPageRequest.h"
#import "HPTOrderRequest.h"
#import "HPTPaymentProduct.h"

#define HPTGatewayClientBaseURLStage        @"https://stage-secure-gateway.hipay-tpp.com/rest/v1/"
#define HPTGatewayClientBaseURLProduction   @"https://secure-gateway.hipay-tpp.com/rest/v1/"
#define HPTGatewayCallbackURLPathName       @"gateway"

extern NSString *const HPTGatewayClientDidRedirectSuccessfullyNotification;
extern NSString *const HPTGatewayClientDidRedirectWithMappingErrorNotification;

typedef void (^HPTHostedPaymentPageCompletionBlock)(HPTHostedPaymentPage *hostedPaymentPage, NSError *error);
typedef void (^HPTOperationCompletionBlock)(HPTOperation *operation, NSError *error);
typedef void (^HPTTransactionCompletionBlock)(HPTTransaction *transaction, NSError *error);
typedef void (^HPTTransactionsCompletionBlock)(NSArray <HPTTransaction *> *transactions, NSError *error);
typedef void (^HPTPaymentProductsCompletionBlock)(NSArray <HPTPaymentProduct *> *paymentProducts, NSError *error);

@interface HPTGatewayClient : HPTAbstractClient
{
    HPTHTTPClient *HTTPClient;
    HPTClientConfig *clientConfig;
}

+ (instancetype)sharedClient;
+ (BOOL)isTransactionErrorFinal:(NSError *)error;

- (id<HPTRequest>)initializeHostedPaymentPageRequest:(HPTPaymentPageRequest *)hostedPaymentPageRequest withCompletionHandler:(HPTHostedPaymentPageCompletionBlock)completionBlock;

- (id<HPTRequest>)requestNewOrder:(HPTOrderRequest *)orderRequest withCompletionHandler:(HPTTransactionCompletionBlock)completionBlock;

- (id<HPTRequest>)getTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPTTransactionCompletionBlock)completionBlock;

- (id<HPTRequest>)getTransactionsWithOrderId:(NSString *)orderId withCompletionHandler:(HPTTransactionsCompletionBlock)completionBlock;

- (id<HPTRequest>)performMaintenanceOperation:(HPTOperationType)operation amount:(NSNumber *)amount onTransactionWithReference:(NSString *)transactionReference withCompletionHandler:(HPTOperationCompletionBlock)completionBlock;

- (id<HPTRequest>)getPaymentProductsForRequest:(HPTPaymentPageRequest *)paymentPageRequest withCompletionHandler:(HPTPaymentProductsCompletionBlock)completionBlock;

- (BOOL)handleOpenURL:(NSURL *)URL;

@end