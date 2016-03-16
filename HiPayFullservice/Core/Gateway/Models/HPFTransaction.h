//
//  HPFTransaction.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFTransactionRelatedItem.h"
#import "HPFOrder.h"
#import "HPFThreeDSecure.h"
#import "HPFFraudScreening.h"
#import "HPFPaymentMethod.h"

/**
 *  The Address Verification Service (AVS) is a system that allows e-commerce merchants to check a cardholder's billing address. AVS provides merchants with a key indicator that helps verify whether or not a transaction is valid. This enum lists the available result codes as returned in the API response messages.
 */
typedef NS_ENUM(char, HPFAVSResult) {

    /**
     *  No AVS response was obtained (Default value).
     */
    HPFAVSResultNotApplicable = ' ',
    
    /**
     *  Street addresses and postal codes match.
     */
    HPFAVSResultExactMatch = 'Y',
    
    /**
     *  The street addresses match; the postal codes do not match.
     *  Either the request does not include the postal codes or postal codes are not verified due to incompatible formats.
     */
    HPFAVSResultAddressMatch = 'A',
    
    /**
     *  The postal codes match; the street addresses do not match.
     *  Either the request does not include the street addresses or street addresses are not verified due to incompatible formats.
     */
    HPFAVSResultPostalCodeMatch = 'P',
    
    /**
     *  Neither the street addresses nor the postal codes match.
     */
    HPFAVSResultNoMatch = 'N',
    
    /**
     *  Street addresses and postal codes not verified due to incompatible formats.
     */
    HPFAVSResultNotCompatible = 'C',
    
    /**
     *  AVS data is invalid or AVS is not allowed for this card type.
     */
    HPFAVSResultNotAllowed = 'E',
    
    /**
     *  Address information is unavailable for that account number, or the card issuer does not support AVS.
     */
    HPFAVSResultUnavailable = 'U',
    
    /**
     *  Issuer authorization system is unavailable, try again later.
     */
    HPFAVSResultRetry = 'R',
    
    /**
     *  Card issuer does not support AVS.
     */
    HPFAVSResultNotSupported = 'S',
};

/**
 *  The ECI indicates the security level at which the payment information is processed between the cardholder and merchant. 
 *  This enum lists the available indicators as they are supposed to be sent along with each authorization request.
 */
typedef NS_ENUM(NSInteger, HPFECI) {
   
    /**
     *  If you use this value, the default ECI will be used. The default ECI value can be set in the Integration section of the HiPay Fullservice merchant back office. An ECI value sent along in the transaction will overwrite the default ECI value.
     */
    HPFECIDefault = NSIntegerMax,
    
    /**
     *  The merchant received the customer's financial details over the phone or via fax/mail, but he does not have the customer's card at hand.
     */
    HPFECIMOTO = 1,
    
    /**
     *  The first transaction of the customer was a Mail Order / Telephone Order transaction; i.e. the customer gave his financial details over the phone or via mail/fax to the merchant. 
     *  Either the merchant stores the details by himself or these details are stored in our system using an Alias and is performing another transaction for the same customer (recurring transaction).
     */
    HPFECIRecurringMOTO = 2,
    
    /**
     *  Partial payment of goods/services that have already been delivered, but will be paid for in several spread payments.
     */
    HPFECIInstallmentPayment = 3,

    /**
     *  The customer is physically present in front of the merchant. The merchant has the customer's card within easy reach. The card details are manually entered; the card is not swiped through a machine.
     */
    HPFECIManuallyKeyedCardPresent = 4,
    
    /**
     *  The payment transaction was conducted over a secure channel (for example, SSL/TLS), but payment authentication was not performed, or when the issuer responded that authentication could not be performed.
     */
    HPFECISecureECommerce = 7,
    
    /**
     *  The first transaction of the customer was an e-Commerce transaction; i.e. the customer entered his financial details himself on a secure website (either the merchant's website or our secure platform). 
     *  Either the merchant stores the details by himself or these details are stored in our system using an Alias and is now performing another transaction for the same customer (recurring transaction), using the Alias details.
     */
    HPFECIRecurringECommerce = 9,
};

/**
 *  The CVC is available on the following credit and debit cards: Visa (Card Verification Value CVV2), MasterCard (Card Validation Code CVC2), Maestro, Diners Club, Discover (Card Identification Number CID), and American Express (Card Identification Number CID).
 *  When the acquirer enables you to perform a CVC check, a result code (returned along with the response to authorization request) informs you on the CVC check status.
 *
 *  Procedure: you evaluate the CVC result code that you received with the transaction authorization, and you take appropriate action based on all transaction characteristics.
 *  
 *  Warning: only a few acquirers return specific CVC check results. For most acquirers, the CVC is assumed to be correct if the transaction is successfully authorized.
 *
 * This enum lists the available result codes as returned in the API response messages.
 */
typedef NS_ENUM(char, HPFCVCResult) {
   
    /**
     *  CVC check was not possible.
     */
    HPFCVCResultNotApplicable = ' ',
    
    /**
     *  CVC match.
     */
    HPFCVCResultMatch = 'M',
    
    /**
     *  CVC does not match.
     */
    HPFCVCResultNoMatch = 'N',
    
    /**
     *  CVC request not processed.
     */
    HPFCVCResultNotProcessed = 'P',
    
    /**
     *  CVC should be on the card, but the cardholder has reported that it isn't.
     */
    HPFCVCResultMissing = 'S',
    
    /**
     *  Card issuer does not support CVC.
     */
    HPFCVCResultNotSupported = 'U',
};

/**
 *  The HiPay Fullservice payment gateway can process transactions through many different acquirers using different payment methods and involving some anti-fraud checks. All these aspects change the transaction processing flow significantly for you.
 *  When you send a transaction request to the gateway, you receive a response describing the transaction state.
 */
typedef NS_ENUM(NSInteger, HPFTransactionState) {
    
    /**
     *  Transaction was not processed due to some reasons.
     
     */
    HPFTransactionStateError,
    
    /**
     *  If the transaction state is completed you are done.
     *  This is the most common case for credit card transaction processing. Almost all credit card acquirers work in that way. Then you have to look into the status field of the response to know the exact transaction status.
     */
    HPFTransactionStateCompleted,
    
    /**
     *  If the transaction state is forwarding you have to redirect your customer to an URL provided in the forward_url field of the response. In that case the transaction processing is not yet done. You will have to wait until the customer returned to your website after doing all redirects.
     */
    HPFTransactionStateForwarding,
   
    /**
     *  Transaction request was submitted to the acquirer but response is not yet available.
     */
    HPFTransactionStatePending,
   
    /**
     *  Transaction was processed and was declined by gateway.
     */
    HPFTransactionStateDeclined,
};

/**
 *  Describes a payment transaction.
 */
@interface HPFTransaction : HPFTransactionRelatedItem

/**
 *  Transaction state.
 */
@property (nonatomic, readonly) HPFTransactionState state;

/**
 *  Optional element. Reason why transaction was declined.
 */
@property (nonatomic, readonly, nullable) NSString *reason;

/**
 *  If returned, merchant must redirect the customer's browser to this URL.
 */
@property (nonatomic, readonly, nullable) NSURL *forwardUrl;

/**
 *  Attempt id of the payment.
 */
@property (nonatomic, readonly, nullable) NSString *attemptId;

/**
 *  In some payment methods the customer can receive a reference to pay, at this point, the customer has the option to physically paying with cash at any bank branch, or at authorized processors such as drugstores, supermarkets or post offices, or paying electronically at an electronic banking point.
 */
@property (nonatomic, readonly, nullable) NSString *referenceToPay;

/**
 *  The IP address of the customer making the purchase.
 */
@property (nonatomic, readonly, nullable) NSString *ipAddress;

/**
 *  Country code associated to the customer's IP address.
 */
@property (nonatomic, readonly, nullable) NSString *ipCountry;

/**
 *  Unique identifier assigned to device (the customer's browser) by HiPay Fullservice.
 */
@property (nonatomic, readonly, nullable) NSString *deviceId;

/**
 *  Result of the Address Verification Service (AVS).
 */
@property (nonatomic, readonly) HPFAVSResult avsResult;

/**
 *  Result of the CVC (Card Verification Code) check.
 */
@property (nonatomic, readonly) HPFCVCResult cvcResult;

/**
 *  Electronic Commerce Indicator (ECI).
 */
@property (nonatomic, readonly) HPFECI eci;

/**
 *  Code of the payment product used to complete the transaction.
 */
@property (nonatomic, readonly, nonnull) NSString *paymentProduct;

/**
 *  Informated related to the payment method being used to complete the transaction.
 */
@property (nonatomic, readonly, nullable) HPFPaymentMethod *paymentMethod;

/**
 *  Optional element. Result of the 3-D Secure Authentication
 */
@property (nonatomic, readonly, nullable) HPFThreeDSecure *threeDSecure;

/**
 *  Result of the fraud screening.
 */
@property (nonatomic, readonly, nullable) HPFFraudScreening *fraudScreening;

/**
 *  The order related to the transaction.
 */
@property (nonatomic, readonly, nonnull) HPFOrder *order;

/**
 *  Custom data 1.
 */
@property (nonatomic, readonly, nullable) NSString *cdata1;

/**
 *  Custom data 2.
 */
@property (nonatomic, readonly, nullable) NSString *cdata2;

/**
 *  Custom data 3.
 */
@property (nonatomic, readonly, nullable) NSString *cdata3;

/**
 *  Custom data 4.
 */
@property (nonatomic, readonly, nullable) NSString *cdata4;

/**
 *  Custom data 5.
 */
@property (nonatomic, readonly, nullable) NSString *cdata5;

/**
 *  Custom data 6.
 */
@property (nonatomic, readonly, nullable) NSString *cdata6;

/**
 *  Custom data 7.
 */
@property (nonatomic, readonly, nullable) NSString *cdata7;

/**
 *  Custom data 8.
 */
@property (nonatomic, readonly, nullable) NSString *cdata8;

/**
 *  Custom data 9.
 */
@property (nonatomic, readonly, nullable) NSString *cdata9;

/**
 *  Custom data 10.
 */
@property (nonatomic, readonly, nullable) NSString *cdata10;

@property (readonly, getter=isHandled) BOOL handled;

+ (NSArray<HPFTransaction *> * _Nonnull)sortTransactionsByRelevance:(NSArray<HPFTransaction *> * _Nonnull)transactions;

- (BOOL)isMoreRelevantThan:(HPFTransaction * _Nonnull)transaction;

- (instancetype _Nonnull)initWithOrder:(HPFOrder * _Nullable)order state:(HPFTransactionState)state;

@end
