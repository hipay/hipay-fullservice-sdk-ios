//
//  HPTTransactionRelatedItem.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTTransactionStatus) {
    
    HPTTransactionStatusUnknown = 0,
    HPTTransactionStatusCreated = 101,
    HPTTransactionStatusCardholderEnrolled = 103,
    HPTTransactionStatusCardholderNotEnrolled = 104,
    HPTTransactionStatusUnableToAuthenticate = 105,
    HPTTransactionStatusCardholderAuthenticated = 106,
    HPTTransactionStatusAuthenticationAttempted = 107,
    HPTTransactionStatusCouldNotAuthenticate = 108,
    HPTTransactionStatusAuthenticationFailed = 109,
    HPTTransactionStatusBlocked = 110,
    HPTTransactionStatusDenied = 111,
    HPTTransactionStatusAuthorizedAndPending = 112,
    HPTTransactionStatusRefused = 113,
    HPTTransactionStatusExpired = 114,
    HPTTransactionStatusCancelled = 115,
    HPTTransactionStatusAuthorized = 116,
    HPTTransactionStatusCaptureRequested = 117,
    HPTTransactionStatusCaptured = 118,
    HPTTransactionStatusPartiallyCaptured = 119,
    HPTTransactionStatusCollected = 120,
    HPTTransactionStatusPartiallyCollected = 121,
    HPTTransactionStatusSettled = 122,
    HPTTransactionStatusPartiallySettled = 123,
    HPTTransactionStatusRefundRequested = 124,
    HPTTransactionStatusRefunded = 125,
    HPTTransactionStatusPartiallyRefunded = 126,
    HPTTransactionStatusChargedBack = 129,
    HPTTransactionStatusDebited = 131,
    HPTTransactionStatusPartiallyDebited = 132,
    HPTTransactionStatusAuthenticationRequested = 140,
    HPTTransactionStatusAuthenticated = 141,
    HPTTransactionStatusAuthorizationRequested = 142,
    HPTTransactionStatusAcquirerFound = 150,
    HPTTransactionStatusAcquirernotFound = 151,
    HPTTransactionStatusCardholderEnrollmentUnknown = 160,
    HPTTransactionStatusRiskAccepted = 161,
    HPTTransactionStatusAuthorizationRefused = 163,
    HPTTransactionStatusCaptureRefused = 173,
    HPTTransactionStatusPendingPayment = 200,
    
};


@interface HPTTransactionRelatedItem : NSObject

@property (nonatomic, readonly) BOOL test;
@property (nonatomic, readonly) NSString *mid;
@property (nonatomic, readonly) NSString *authorizationCode;
@property (nonatomic, readonly) NSString *transactionReference;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, readonly) NSDate *dateUpdated;
@property (nonatomic, readonly) NSDate *dateAuthorized;
@property (nonatomic, readonly) HPTTransactionStatus status;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSNumber *authorizedAmount;
@property (nonatomic, readonly) NSNumber *capturedAmount;
@property (nonatomic, readonly) NSNumber *refundedAmount;
@property (nonatomic, readonly) NSNumber *decimals;
@property (nonatomic, readonly) NSString *currency;

@end