//
//  HPFTransactionRelatedItem.h
//  Pods
//
//  Created by HiPay on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

/**
 *  This is a list of the various transaction status names and a description of what each payment status name means.
 */
typedef NS_ENUM(NSInteger, HPFTransactionStatus) {
    
    /**
     *  Unknown status.
     */
    HPFTransactionStatusUnknown = 0,

    /**
     *  The payment attempt was created.
     */
    HPFTransactionStatusCreated = 101,
    
    /**
     *  Card is enrolled in the 3-D Secure program. The merchant has to forward the cardholder to the authentication pages of the card issuer.
     */
    HPFTransactionStatusCardholderEnrolled = 103,
    
    /**
     *  Card is not enrolled in 3-D Secure program.
     */
    HPFTransactionStatusCardholderNotEnrolled = 104,
    
    /**
     *  Unable to complete the authentication request.
     */
    HPFTransactionStatusUnableToAuthenticate = 105,
    
    /**
     *  Cardholder was successfully authenticated in the 3-D Secure program.
     */
    HPFTransactionStatusCardholderAuthenticated = 106,
    
    /**
     *  The Merchant has attempted to authenticate the cardholder in the 3-D Secure program and either the Issuer or cardholder is not enrolled.
     */
    HPFTransactionStatusAuthenticationAttempted = 107,
    
    /**
     *  The Issuer is not able to complete the authentication request.
     */
    HPFTransactionStatusCouldNotAuthenticate = 108,
    
    /**
     *  Cardholder authentication failed.
     *  Authorization request should not be submitted.
     *  An authentication failure may be a possible indication of a fraudulent user.
     */
    HPFTransactionStatusAuthenticationFailed = 109,
    
    /**
     *  The transaction has been rejected for reasons of suspected fraud.
     */
    HPFTransactionStatusBlocked = 110,
    
    /**
     *  Merchant denied the payment attempt. After reviewing the fraud screening result, the merchant decided to decline the payment.
     */
    HPFTransactionStatusDenied = 111,
    
    /**
     *  The payment was challenged by the fraud rule set and is pending.
     */
    HPFTransactionStatusAuthorizedAndPending = 112,
    
    /**
     *  The financial institution refused to authorize the payment.
     *  The refusal reasons can be : an exceeded credit limit, an incorrect expiry date, insufficient balance, or many other depending on the selected payment method.
     */
    HPFTransactionStatusRefused = 113,
    
    /**
     *  The validity period of the payment authorization has expired.
     *  This happens when no capture request is submitted for an authorized payment typically within 7 days after authorization.
     *  Note: Depending on the customer's issuing bank, the authorization validity period may last from 1-5 days for a debit card and up to 30 days for a credit card.
     */
    HPFTransactionStatusExpired = 114,
    
    /**
     *  Merchant cancelled the payment attempt.
     *  You can only cancel payments with status "Authorized" and that have not yet reached the status "Captured". In the case of a credit card payment, cancelling the transaction consists in voiding the authorization.
     */
    HPFTransactionStatusCancelled = 115,
    
    /**
     *  The financial institution has approved the payment.
     *  In the case of a credit card payment, funds are "held" and deducted from the customer's credit limit (or bank balance, in the case of a debit card) but are not yet transferred to the merchant. 
     *  In the case of bank transfers and some other payment methods, the payment immediately obtains the status "Captured" after being set to "Authorized".
     */
    HPFTransactionStatusAuthorized = 116,
    
    /**
     *  A capture request has been sent to the financial institution.
     */
    HPFTransactionStatusCaptureRequested = 117,
    
    /**
     *  The financial institution has processed the payment.
     *  The funds will be transferred to HiPay TPP before being settled to your bank account. Authorized payments can be captured as long as the authorization has not expired. Some payment methods, like bank transfers or direct debits, reach the "Captured" status straight away after being authorized.
     */
    HPFTransactionStatusCaptured = 118,

    /**
     *  The financial institution has processed part of the payment.
     *  If only part of the order can be shipped, it is allowed to capture an amount equal to the shipped part of the order. This is called a partial capture.
     *  Note: Remember! As all credit card companies dictate, it is not allowed for a merchant to capture a payment before shipping has completed. Merchant should start shipping the order once the status "Authorized" is reached!
     */
    HPFTransactionStatusPartiallyCaptured = 119,
    
    /**
     *  The funds have been made available for remittance to the merchant.
     *  A payment with the status "Collected" is ready to be paid out. HiPay Fullservice either will transfer the amount to your bank account within the next few days (depends on your settlement frequency), or the amount is already transferred to your bank account.
     */
    HPFTransactionStatusCollected = 120,
    
    /**
     *  A part of the transaction has been collected.
     */
    HPFTransactionStatusPartiallyCollected = 121,
    
    /**
     *  The financial operations linked to this transaction are closed. Funds have been debited or credited from your merchant account at HiPay.
     */
    HPFTransactionStatusSettled = 122,
    
    /**
     *  A part of the financial operations linked to this transaction is closed.
     */
    HPFTransactionStatusPartiallySettled = 123,
    
    /**
     *  A refund request has been sent to the financial institution.
     */
    HPFTransactionStatusRefundRequested = 124,
    
    /**
     *  The payment was refunded.
     *  A payment obtains the status "Refunded" when the financial institution processed the refund and the amount has been transferred to the shopper's account. The amount will be deducted from the next total amount, to be paid out to the merchant.
     */
    HPFTransactionStatusRefunded = 125,
    
    /**
     *  A part of the transaction has been refunded.
     */
    HPFTransactionStatusPartiallyRefunded = 126,
    
    /**
     *  The cardholder reversed a capture processed by their bank or credit card company. For instance, the cardholder contacts his credit card company and denies having made the transaction.
     *  The credit card company then revokes the already captured payment. Please note the legal difference between the shopper (who ordered the goods) and the cardholder (who owns the credit card and ends up paying for the order).
     *  In general, charge backs only occurs incidentally. When they do, a contact with the shopper can often solve the situation. Occasionally it is an indication of credit card fraud.
     */
    HPFTransactionStatusChargedBack = 129,
    
    /**
     *  The acquirer has informed us that a debit linked to the transaction is going to be applied.
     */
    HPFTransactionStatusDebited = 131,
    
    /**
     *  The acquirer has informed us that a partial debit linked to the transaction is going to be applied.
     */
    HPFTransactionStatusPartiallyDebited = 132,
    
    /**
     *  The payment method used requires authentication, authentication request was send and system is waiting for a customers’ action.
     */
    HPFTransactionStatusAuthenticationRequested = 140,
    
    /**
     *  The payment method used requires authentication and it was successfull.
     */
    HPFTransactionStatusAuthenticated = 141,
    
    /**
     *  The payment method used requires an authorization request; the request was sent and the system is waiting for the financial institution approval.
     */
    HPFTransactionStatusAuthorizationRequested = 142,
    
    /**
     *  The acquirer payment route has been found.
     */
    HPFTransactionStatusAcquirerFound = 150,
    
    /**
     *  The acquirer payment route has not been found.
     */
    HPFTransactionStatusAcquirernotFound = 151,
    
    /**
     *  Unable to verify if the card is enrolled in the 3-D Secure program.
     */
    HPFTransactionStatusCardholderEnrollmentUnknown = 160,
    
    /**
     *  The payment has been accepted by the fraud rule set.
     */
    HPFTransactionStatusRiskAccepted = 161,
    
    /**
     *  The authorization was refused by the financial institution.
     */
    HPFTransactionStatusAuthorizationRefused = 163,
    
    /**
     *  The refund operation was refused by the financial institution.
     */
    HPFTransactionStatusRefundRefused = 165,
    
    /**
     *  The capture was refused by the financial institution.
     */
    HPFTransactionStatusCaptureRefused = 173,
    
    /**
     *  The transaction request was submitted to the acquirer but response is not yet available.
     */
    HPFTransactionStatusPendingPayment = 200,
};

/**
 *  Describes a transaction-related item such as a Transaction or an Operation.
 */
@interface HPFTransactionRelatedItem : NSObject

/**
 *  Whether the transaction is a testing transaction.
 */
@property (nonatomic, readonly) BOOL test;

/**
 *  Your merchant account number (issued to you by HiPay Fullservice).
 */
@property (nonatomic, readonly, nonnull) NSString *mid;

/**
 *  An authorization code (up to 35 characters)
 */
@property (nonatomic, readonly, nullable) NSString *authorizationCode;

/**
 *  The unique identifier of the transaction.
 */
@property (nonatomic, readonly, nonnull) NSString *transactionReference;

/**
 *  Time when transaction was created.
 */
@property (nonatomic, readonly, nonnull) NSDate *dateCreated;

/**
 *  Time when transaction was last updated.
 */
@property (nonatomic, readonly, nonnull) NSDate *dateUpdated;

/**
 *  Time when transaction was authorized.
 */
@property (nonatomic, readonly, nullable) NSDate *dateAuthorized;

/**
 *  Transaction status.
 */
@property (nonatomic, readonly) HPFTransactionStatus status;

/**
 *  Transaction message
 */
@property (nonatomic, readonly, nullable) NSString *message;

/**
 *  The transaction authorized amount.
 */
@property (nonatomic, readonly, nullable) NSNumber *authorizedAmount;

/**
 *  The transaction captured amount.
 */
@property (nonatomic, readonly, nullable) NSNumber *capturedAmount;

/**
 *  The transaction refunded amount.
 */
@property (nonatomic, readonly, nullable) NSNumber *refundedAmount;

/**
 *  Decimal precision of transaction amount.
 */
@property (nonatomic, readonly, nonnull) NSNumber *decimals;

/**
 *  Base currency for this transaction. This three-character currency code complies with ISO 4217.
 */
@property (nonatomic, readonly, nonnull) NSString *currency;

@end
