//
//  HPTErrors.h
//  Pods
//
//  Created by Jonathan TIRET on 29/09/2015.
//
//

#ifndef HPTErrors_h
#define HPTErrors_h

NSString * const HPTHiPayTPPErrorDomain;
NSString * const HPTErrorCodeHTTPOtherDescription;
NSString * const HPTErrorCodeHTTPNetworkUnavailableDescription;
NSString * const HPTErrorCodeHTTPConfigDescription;
NSString * const HPTErrorCodeHTTPConnectionFailedDescription;
NSString * const HPTErrorCodeHTTPClientDescription;
NSString * const HPTErrorCodeHTTPServerDescription;

NSString * const HPTErrorCodeAPIMessageKey;
NSString * const HPTErrorCodeAPICodeKey;


typedef NS_ENUM(NSInteger, HPTErrorCode) {
    
    // Unknown network/HTTP error
    HPTErrorCodeHTTPOther,
    
    // Network is unavailable, the request did not reach the server
    HPTErrorCodeHTTPNetworkUnavailable,
    
    // Config error (such as SSL, bad URL, etc.)
    HPTErrorCodeHTTPConfig,
    
    // The connection has been interupted, the data possibly reached the server
    HPTErrorCodeHTTPConnectionFailed,
    
    // HTTP client error (400)
    HPTErrorCodeHTTPClient,
    
    // HTTP client error (typically a 500 error)
    HPTErrorCodeHTTPServer,
    
    // Configuration errors (refer to the TPP API documentation appendix)
    HPTErrorCodeAPIConfiguration,
    
    // Validation errors (refer to the TPP API documentation appendix)
    HPTErrorCodeAPIValidation,
    
    // Error codes relating to the Checkout Process (refer to the TPP API documentation appendix)
    HPTErrorCodeAPICheckout,
    
    // Error codes relating to Maintenance Operations (refer to the TPP API documentation appendix)
    HPTErrorCodeAPIMaintenance,
    
    // Acquirer Reason Codes (refer to the TPP API documentation appendix)
    HPTErrorCodeAPIAcquirer,
    
    // Unknown error
    HPTErrorCodeAPIOther,
    
};

typedef NS_ENUM(NSInteger, HPTErrorAPIReason) {
    
    // Configuration errors
    HPTErrorAPIIncorrectCredentials = 1000001,
    HPTErrorAPIIncorrectSignature = 1000002,
    HPTErrorAPIAccountNotActive = 1000003,
    HPTErrorAPIAccountLocked = 1000004,
    HPTErrorAPIInsufficientPermissions = 1000005,
    HPTErrorAPIForbiddenAccess = 1000006,
    HPTErrorAPIUnsupportedVersion = 1000007,
    HPTErrorAPITemporarilyUnavailable = 1000008,
    HPTErrorAPINotAllowed = 1000009,
    HPTErrorAPIMethodNotAllowed = 1010001,
    HPTErrorAPIRequiredParameterMissing = 1010101,
    HPTErrorAPIInvalidParameterFormat = 1010201,
    HPTErrorAPIInvalidParameterLength = 1010202,
    HPTErrorAPIInvalidParameterNonAlpha = 1010203,
    HPTErrorAPIInvalidParameterNonNum = 1010204,
    HPTErrorAPIInvalidParameterNonDecimal = 1010205,
    HPTErrorAPIInvalidDate = 1010206,
    HPTErrorAPIInvalidTime = 1010207,
    HPTErrorAPIInvalidIPAddress = 1010208,
    HPTErrorAPIInvalidEmailAddress = 1010209,
    HPTErrorAPIInvalidSoftDescriptorCodeMessage = 1010301,
    HPTErrorAPINoRoutetoAcquirer = 1020001,
    HPTErrorAPIUnsupportedECIDescription = 1020002,
    HPTErrorAPIUnsupported = 1020003,
    
    // Validation errors
    HPTErrorAPIUnknownOrder = 3000001,
    HPTErrorAPIUnknownTransaction = 3000002,
    HPTErrorAPIUnknownMerchant = 3000003,
    HPTErrorAPIUnsupportedOperation = 3000101,
    HPTErrorAPIUnknownIPAddress = 3000102,
    HPTErrorAPISuspicionOfFraud = 3000201,
    HPTErrorAPIFraudSuspicion = 3040001,
    HPTErrorAPIUnknownToken = 3030001,
    
    // Error codes relating to the Checkout Process
    HPTErrorAPIUnsupportedCurrency = 3010001,
    HPTErrorAPIAmountLimitExceeded = 3010002,
    HPTErrorAPIMaxAttemptsExceeded = 3010003,
    HPTErrorAPIDuplicateOrder = 3010004,
    HPTErrorAPICheckoutSessionExpired = 3010005,
    HPTErrorAPIOrderCompleted = 3010006,
    HPTErrorAPIOrderExpired = 3010007,
    HPTErrorAPIOrderVoided = 3010008,
    
    // Error codes relating to Maintenance Operations
    HPTErrorAPIAuthorizationExpired = 3020001,
    HPTErrorAPIAllowableAmountLimitExceeded = 3020002,
    HPTErrorAPINotEnabled = 3020101,
    HPTErrorAPINotAllowedCapture = 3020102,
    HPTErrorAPINotAllowedPartialCapture = 3020103,
    HPTErrorAPIPermissionDenied = 3020104,
    HPTErrorAPICurrencyMismatch = 3020105,
    HPTErrorAPIAuthorizationCompleted = 3020106,
    HPTErrorAPINoMore = 3020107,
    HPTErrorAPIInvalidAmount = 3020108,
    HPTErrorAPIAmountLimitExceededCapture = 3020109,
    HPTErrorAPIAmountLimitExceededPartialCapture = 3020110,
    HPTErrorAPIOperationNotPermittedClosed = 3020111,
    HPTErrorAPIOperationNotPermittedFraud = 3020112,
    HPTErrorAPIRefundNotEnabled = 3020201,
    HPTErrorAPIRefundNotAllowed = 3020202,
    HPTErrorAPIPartialRefundNotAllowed = 3020203,
    HPTErrorAPIRefundPermissionDenied = 3020204,
    HPTErrorAPIRefundCurrencyMismatch = 3020205,
    HPTErrorAPIAlreadyRefunded = 3020206,
    HPTErrorAPIRefundNoMore = 3020207,
    HPTErrorAPIRefundInvalidAmount = 3020208,
    HPTErrorAPIRefundAmountLimitExceeded = 3020209,
    HPTErrorAPIRefundAmountLimitExceededPartial = 3020210,
    HPTErrorAPIOperationNotPermitted = 3020211,
    HPTErrorAPITooLate = 3020212,
    HPTErrorAPIReauthorizationNotEnabled = 3020301,
    HPTErrorAPIReauthorizationNotAllowed = 3020302,
    HPTErrorAPICannotReauthorize = 3020303,
    HPTErrorAPIMaxLimitExceeded = 3020304,
    HPTErrorAPIVoidNotAllowed = 3020401,
    HPTErrorAPICannotVoid = 3020402,
    HPTErrorAPIAuthorizationVoided = 3020403,
    
    // Acquirer Reason Codes
    HPTErrorAPIDeclinedAcquirer = 4000001,
    HPTErrorAPIDeclinedFinancialInstituion = 4000002,
    HPTErrorAPIInsufficientFundsAccount = 4000003,
    HPTErrorAPITechnicalProblem = 4000004,
    HPTErrorAPICommunicationFailure = 4000005,
    HPTErrorAPIAcquirerUnavailable = 4000006,
    HPTErrorAPIDuplicateTransaction = 4000007,
    HPTErrorAPIPaymentCancelledByTheCustomer = 4000008,
    HPTErrorAPIInvalidTransaction = 4000009,
    HPTErrorAPIPleaseCallTheAcquirerSupportCallNumber = 4000010,
    HPTErrorAPIAuthenticationFailedPleaseRetryOrCancel = 4000011,
    HPTErrorAPINoUIDConfiguredForThisOperation = 4000012,
    HPTErrorAPIRefusalNoExplicitReason = 4010101,
    HPTErrorAPIIssuerNotAvailable = 4010102,
    HPTErrorAPIInsufficientFundsCredit = 4010103,
    HPTErrorAPITransactionNotPermitted = 4010201,
    HPTErrorAPIInvalidCardNumber = 4010202,
    HPTErrorAPIUnsupportedCard = 4010203,
    HPTErrorAPICardExpired = 4010204,
    HPTErrorAPIExpiryDateIncorrect = 4010205,
    HPTErrorAPICVCRequired = 4010206,
    HPTErrorAPICVCError = 4010207,
    HPTErrorAPIAVSFailed = 4010301,
    HPTErrorAPIRetainCard = 4010302,
    HPTErrorAPILostOrStolenCard = 4010303,
    HPTErrorAPIRestrictedCard = 4010304,
    HPTErrorAPICardLimitExceeded = 4010305,
    HPTErrorAPICardBlacklisted = 4010306,
    HPTErrorAPIUnauthorisedIPAddressCountry = 4010307,
    HPTErrorAPICardnotInAuthorisersDatabase = 4010309,
};



#endif /* HPTErrors_h */
