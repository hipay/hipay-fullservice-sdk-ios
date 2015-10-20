//
//  HPTThreeDSecure.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(char, HPTThreeDSecureEnrollmentStatus) {
    
    HPTThreeDSecureEnrollmentStatusUnknown = ' ',
    HPTThreeDSecureEnrollmentStatusAuthenticationAvailable = 'Y',
    HPTThreeDSecureEnrollmentStatusCardholderNotEnrolled = 'N',
    HPTThreeDSecureEnrollmentStatusUnableToAuthenticate = 'U',
    HPTThreeDSecureEnrollmentStatusOtherError = 'E',
    
};

typedef NS_ENUM(char, HPTThreeDSecureAuthenticationStatus) {
    
    HPTThreeDSecureAuthenticationStatusUnknown = ' ',
    HPTThreeDSecureAuthenticationStatusSuccessful = 'Y',
    HPTThreeDSecureAuthenticationStatusAttempted = 'A',
    HPTThreeDSecureAuthenticationStatusCouldNotBePerformed = 'U',
    HPTThreeDSecureAuthenticationStatusAuthenticationFailed = 'N',
    HPTThreeDSecureAuthenticationStatusOther = 'E',

    
};

@interface HPTThreeDSecure : NSObject

@property (nonatomic, readonly) HPTThreeDSecureEnrollmentStatus enrollmentStatus;
@property (nonatomic, readonly) NSString *enrollmentMessage;
@property (nonatomic, readonly) HPTThreeDSecureAuthenticationStatus authenticationStatus;
@property (nonatomic, readonly) NSString *authenticationMessage;
@property (nonatomic, readonly) NSString *authenticationToken;
@property (nonatomic, readonly) NSString *xid;

@end
