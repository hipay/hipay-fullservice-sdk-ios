//
//  HPFThreeDSecure.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(char, HPFThreeDSecureEnrollmentStatus) {
    
    HPFThreeDSecureEnrollmentStatusUnknown = ' ',
    HPFThreeDSecureEnrollmentStatusAuthenticationAvailable = 'Y',
    HPFThreeDSecureEnrollmentStatusCardholderNotEnrolled = 'N',
    HPFThreeDSecureEnrollmentStatusUnableToAuthenticate = 'U',
    HPFThreeDSecureEnrollmentStatusOtherError = 'E',
    
};

typedef NS_ENUM(char, HPFThreeDSecureAuthenticationStatus) {
    
    HPFThreeDSecureAuthenticationStatusUnknown = ' ',
    HPFThreeDSecureAuthenticationStatusSuccessful = 'Y',
    HPFThreeDSecureAuthenticationStatusAttempted = 'A',
    HPFThreeDSecureAuthenticationStatusCouldNotBePerformed = 'U',
    HPFThreeDSecureAuthenticationStatusAuthenticationFailed = 'N',
    HPFThreeDSecureAuthenticationStatusOther = 'E',

    
};

@interface HPFThreeDSecure : NSObject

@property (nonatomic, readonly) HPFThreeDSecureEnrollmentStatus enrollmentStatus;
@property (nonatomic, readonly) NSString *enrollmentMessage;
@property (nonatomic, readonly) HPFThreeDSecureAuthenticationStatus authenticationStatus;
@property (nonatomic, readonly) NSString *authenticationMessage;
@property (nonatomic, readonly) NSString *authenticationToken;
@property (nonatomic, readonly) NSString *xid;

@end
