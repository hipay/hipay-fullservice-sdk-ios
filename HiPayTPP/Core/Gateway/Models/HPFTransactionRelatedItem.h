//
//  HPFTransactionRelatedItem.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPFTransactionStatus) {
    
    HPFTransactionStatusUnknown = 0,
    HPFTransactionStatusCreated = 101,
    HPFTransactionStatusCardholderEnrolled = 103,
    HPFTransactionStatusCardholderNotEnrolled = 104,
    HPFTransactionStatusUnableToAuthenticate = 105,
    HPFTransactionStatusCardholderAuthenticated = 106,
    HPFTransactionStatusAuthenticationAttempted = 107,
    HPFTransactionStatusCouldNotAuthenticate = 108,
    HPFTransactionStatusAuthenticationFailed = 109,
    HPFTransactionStatusBlocked = 110,
    HPFTransactionStatusDenied = 111,
    HPFTransactionStatusAuthorizedAndPending = 112,
    HPFTransactionStatusRefused = 113,
    HPFTransactionStatusExpired = 114,
    HPFTransactionStatusCancelled = 115,
    HPFTransactionStatusAuthorized = 116,
    HPFTransactionStatusCaptureRequested = 117,
    HPFTransactionStatusCaptured = 118,
    HPFTransactionStatusPartiallyCaptured = 119,
    HPFTransactionStatusCollected = 120,
    HPFTransactionStatusPartiallyCollected = 121,
    HPFTransactionStatusSettled = 122,
    HPFTransactionStatusPartiallySettled = 123,
    HPFTransactionStatusRefundRequested = 124,
    HPFTransactionStatusRefunded = 125,
    HPFTransactionStatusPartiallyRefunded = 126,
    HPFTransactionStatusChargedBack = 129,
    HPFTransactionStatusDebited = 131,
    HPFTransactionStatusPartiallyDebited = 132,
    HPFTransactionStatusAuthenticationRequested = 140,
    HPFTransactionStatusAuthenticated = 141,
    HPFTransactionStatusAuthorizationRequested = 142,
    HPFTransactionStatusAcquirerFound = 150,
    HPFTransactionStatusAcquirernotFound = 151,
    HPFTransactionStatusCardholderEnrollmentUnknown = 160,
    HPFTransactionStatusRiskAccepted = 161,
    HPFTransactionStatusAuthorizationRefused = 163,
    HPFTransactionStatusCaptureRefused = 173,
    HPFTransactionStatusPendingPayment = 200,
    
};


@interface HPFTransactionRelatedItem : NSObject

@property (nonatomic, readonly) BOOL test;
@property (nonatomic, readonly) NSString *mid;
@property (nonatomic, readonly) NSString *authorizationCode;
@property (nonatomic, readonly) NSString *transactionReference;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, readonly) NSDate *dateUpdated;
@property (nonatomic, readonly) NSDate *dateAuthorized;
@property (nonatomic, readonly) HPFTransactionStatus status;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSNumber *authorizedAmount;
@property (nonatomic, readonly) NSNumber *capturedAmount;
@property (nonatomic, readonly) NSNumber *refundedAmount;
@property (nonatomic, readonly) NSNumber *decimals;
@property (nonatomic, readonly) NSString *currency;

@end