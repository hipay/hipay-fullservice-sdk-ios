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

/**
 *  This type of block is executed once a hosted payment Web page initialization request finishes.
 *
 *  @param hostedPaymentPage The hosted payment page definition. This argument is nil if the request fails.
 *  @param error             The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFHostedPaymentPageCompletionBlock)(HPFHostedPaymentPage  * _Nullable hostedPaymentPage, NSError * _Nullable error);

/**
 *  This type of block is executed once an operation maintenance request finishes.
 *
 *  @param operation The operation definition. This argument is nil if the request fails.
 *  @param error     The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFOperationCompletionBlock)(HPFOperation * _Nullable operation, NSError * _Nullable error);

/**
 *  This type of block is executed once a transaction-related request finishes.
 *
 *  @param transaction The transaction. This argument is nil if the request fails.
 *  @param error       The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFTransactionCompletionBlock)(HPFTransaction * _Nullable transaction, NSError * _Nullable error);

/**
 *  This type of block is executed once a transactions-related request finishes.
 *
 *  @param transactions The list of transactions. This argument is nil if the request fails.
 *  @param error        The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFTransactionsCompletionBlock)(NSArray <HPFTransaction *> * _Nullable transactions, NSError * _Nullable error);

/**
 *  This type of block is executed once a payment products fetching request finishes.
 *
 *  @param paymentProducts The list of payment products. This argument is nil if the request fails.
 *  @param error           The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFPaymentProductsCompletionBlock)(NSArray <HPFPaymentProduct *> * _Nonnull paymentProducts, NSError * _Nullable error);

/**
 *  Gateway Client is the middle component between your application and the HiPay Fullservice Payment Gateway.
 *  Use its methods to perform actions such as executing transactions.
 */
@interface HPFGatewayClient : HPFAbstractClient

/**
 *  Creates and returns the only instance of the Gateway client class that you need to use.
 *
 *  @return The shared Gateway client.
 */
+ (_Nonnull instancetype)sharedClient;

+ (BOOL)isTransactionErrorFinal:(NSError * _Nonnull)error;

/**
 *  This method creates an order and provides you with a forward URL. This forward URL is dedicated to display a payment page with customers’ CSS and validated payment products. 
 *  After payment form validation, the checkout is processed.
 *
 *  @param hostedPaymentPageRequest A request object (that you need to instantiate) describing your order (amount, currency, description, enabled payment methods, etc.)
 *  @param completionBlock          The HPFHostedPaymentPageCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFHostedPaymentPageCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)initializeHostedPaymentPageRequest:(HPFPaymentPageRequest * _Nonnull)hostedPaymentPageRequest withCompletionHandler:(HPFHostedPaymentPageCompletionBlock _Nullable)completionBlock;

/**
 *  This method creates an order, execute a payment and returns the details of the transaction. Depending on the payment method or the transaction state, you may be provided with a forward URL (if the payment process needs a few additional steps to complete).
 *
 *  @param orderRequest    A request object (that you need to instantiate) describing your order (amount, currency, description, payment method details, etc.)
 *  @param completionBlock The HPFTransactionCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFTransactionCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)requestNewOrder:(HPFOrderRequest * _Nonnull)orderRequest withCompletionHandler:(HPFTransactionCompletionBlock _Nullable)completionBlock;

/**
 *  To get the details of an existing transaction.
 *
 *  @param transactionReference The unique identifier of the transaction.
 *  @param completionBlock      The HPFTransactionCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFTransactionCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)getTransactionWithReference:(NSString * _Nonnull)transactionReference withCompletionHandler:(HPFTransactionCompletionBlock _Nullable)completionBlock;

/**
 *  To get the details of existing transactions related to a specific order.
 *
 *  @param orderId         Merchant unique order ID.
 *  @param completionBlock The HPFTransactionsCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFTransactionsCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)getTransactionsWithOrderId:(NSString * _Nonnull)orderId withCompletionHandler:(HPFTransactionsCompletionBlock _Nullable)completionBlock;

/**
 *  To perform a maintenance on an existing transaction (e.g., a capture).
 *
 *  @param operation            The operation you want to perform.
 *  @param amount               The amount, if the operation implies that you provide one. Send nil otherwise.
 *  @param transactionReference The unique identifier of the transaction.
 *  @param completionBlock      The HPFOperationCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFOperationCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)performMaintenanceOperation:(HPFOperationType)operation amount:(NSNumber * _Nullable)amount onTransactionWithReference:(NSString * _Nonnull)transactionReference withCompletionHandler:(HPFOperationCompletionBlock _Nullable)completionBlock;

/**
 *  This method provides you with the list of payment products activated for your account and available for specific order parameters.
 *
 *  @param paymentPageRequest A request object (that you need to instantiate) describing your order parameters for which you want to get the available payment products.
 *  @param completionBlock    The HPFPaymentProductsCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFPaymentProductsCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)getPaymentProductsForRequest:(HPFPaymentPageRequest * _Nonnull)paymentPageRequest withCompletionHandler:(HPFPaymentProductsCompletionBlock _Nullable)completionBlock;

/**
 *  Handles an app redirection URL. This method should be called from your app delegate when the user is sent back to your app after you redirected him to a forward URL.
 *
 *  @param URL The app redirection URL.
 *
 *  @return Boolean value indicating whether the SDK could handle this format of URL.
 */
- (BOOL)handleOpenURL:(NSURL * _Nonnull)URL;

@end