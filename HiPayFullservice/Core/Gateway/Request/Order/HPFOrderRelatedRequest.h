//
//  HPFOrderRelatedRequest.h
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import "HPFCustomerInfoRequest.h"

#define HPFGatewayCallbackURLOrderPathName @"orders"

/**
 *  Indicates how you want to process the payment. A transaction type sent along with the transaction will overwrite the default payment procedure.
 */
typedef NS_ENUM(NSInteger, HPFOrderRequestOperation) {
    
    /**
     *  The default transaction type. This value is set in the HiPay Fullservice Merchant Interface (Default payment procedure in the Integration section).
     */
    HPFOrderRequestOperationDefault,

    /**
     *  Authorization indicates this transaction is sent for authorization only. The transaction will not be sent for settlement until the transaction is submitted for capture manually by the Merchant.
     */
    HPFOrderRequestOperationAuthorization,
    
    /**
     *  Sale indicates transaction is sent for authorization, and if approved, is automatically submitted for capture.
     */
    HPFOrderRequestOperationSale,
};

extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathAccept;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathDecline;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathPending;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathException;
extern NSString * _Nonnull const HPFOrderRelatedRequestRedirectPathCancel;

/**
 *  Describes information for performing a request that will create a new order. It can either be a hosted payment page initialization or a simple order request. This class must not be instantiated directly. You must use either HPFOrderRequest or HPFPaymentPageRequest.
 *
 *  @see HPFOrderRequest
 *  @see HPFPaymentPageRequest
 */
@interface HPFOrderRelatedRequest : NSObject

/**
 *  Unique order ID (defined by you)
 */
@property (nonatomic, copy, nullable) NSString *orderId;

/**
 *  Transaction type.
 */
@property (nonatomic) HPFOrderRequestOperation operation;

/**
 *  The order short description (up to 255 characters).
 */
@property (nonatomic, copy, nullable) NSString *shortDescription;

/**
 *  Additional order description.
 */
@property (nonatomic, copy, nullable) NSString *longDescription;

/**
 *  Base currency for this order (Default to EUR).
 *  This three-character currency code complies with ISO 4217.
 */
@property (nonatomic, copy, nullable) NSString *currency;

/**
 *  The total order amount. It should be calculated as a sum of the items purchased, plus the shipping fee (if present), plus the tax fee (if present).
 */
@property (nonatomic, copy, nullable) NSNumber *amount;

/**
 *  The order shipping fee (Default to zero).
 *  It can be omitted if the shipping fee value is zero.
 */
@property (nonatomic, copy, nullable) NSNumber *shipping;

/**
 *  The order tax fee (Default to zero).
 * It can be omitted if the order tax value is zero.
 */
@property (nonatomic, copy, nullable) NSNumber *tax;

/**
 *  Unique customer id (for fraud detection reasons).
 */
@property (nonatomic, copy, nullable) NSString *clientId;

/**
 *  The IP address of your customer making a purchase.
 */
@property (nonatomic, copy, nullable) NSString *ipAddress;

/**
 *  The URL to return your customer to once the payment process is completed successfully.
 */
@property (nonatomic, copy, nonnull) NSURL *acceptURL;

/**
 *  The URL to return your customer to after the acquirer declines the payment.
 */
@property (nonatomic, copy, nonnull) NSURL *declineURL;

/**
 *  The URL to return your customer to when the payment request was submitted to the acquirer but response is not yet available.
 */
@property (nonatomic, copy, nonnull) NSURL *pendingURL;

/**
 *  The URL to return your customer to after a system failure.
 */
@property (nonatomic, copy, nonnull) NSURL *exceptionURL;

/**
 *  The URL to return your customer to when he or she decides to abort the payment.
 */
@property (nonatomic, copy, nonnull) NSURL *cancelURL;

/**
 *  This element should contain the exact content of the HTTP "Accept" header as sent to the merchant from the customer's browser.
 */
@property (nonatomic, copy, nullable) NSString *HTTPAccept;

/**
 *  This element should contain the exact content of the HTTP "User-Agent" header as sent to the merchant from the customer's browser (Default to "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)").
 */
@property (nonatomic, copy, nonnull) NSString *HTTPUserAgent;

/**
 *  Iovation Device Fingerprint.
 */
@property (nonatomic, copy, nullable) NSString *deviceFingerprint;

/**
 *  Locale code of your customer (Default to en_GB – English – Great Britain).
 *  It may be used for sending confirmation emails to your customer or for displaying payment pages.
 *  Examples: en_GB fr_FR es_ES it_IT.
 */
@property (nonatomic, copy, nonnull) NSString *language;


/**
 *  Customer-related information.
 */
@property (nonatomic, nonnull) HPFCustomerInfoRequest *customer;

/**
 *  Shipping address-related information.
 */
@property (nonatomic, nonnull) HPFPersonalInfoRequest *shippingAddress;

/**
 *  Merchant risk statement
 */
@property (nonatomic, nonnull) NSDictionary *merchantRiskStatement;

/**
 *  Previous Authentication Informations
 */
@property (nonatomic, nonnull) NSDictionary *previousAuthInfo;

/**
 *  Account Informations
 */
@property (nonatomic, nonnull) NSDictionary *accountInfo;

/**
 *  Custom data. You can use these parameters to submit custom values you wish to show in HiPay back office transaction details, receive back in the API response messages, in the notifications or to activate specific FPS rules. 
 *  Examples:
 *  custom_data => { "shipping_method":"click and collect", "first_order":"0", "products_list":"First product, Second product, Third product"}
 */
@property (nonatomic, copy, nullable) NSDictionary *customData;

/**
 *  Custom data 1. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata1;

/**
 *  Custom data 2. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata2;

/**
 *  Custom data 3. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata3;

/**
 *  Custom data 4. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata4;

/**
 *  Custom data 5. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata5;

/**
 *  Custom data 6. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata6;

/**
 *  Custom data 7. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata7;

/**
 *  Custom data 8. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata8;

/**
 *  Custom data 9. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata9;

/**
 *  Custom data 10. This parameter is deprecated. Use it for compatibility reasons only. If possible, rely on customData instead.
 *
 *  @see customData
 */
@property (nonatomic, copy, nullable) NSString *cdata10;

@property (nonatomic, copy, readonly, nullable) NSDictionary *source;


- (instancetype _Nonnull)initWithOrderRelatedRequest:(HPFOrderRelatedRequest * _Nonnull)orderRelatedRequest;

@end
