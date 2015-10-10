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

@interface HPTThreeDSecure : NSObject

@property (nonatomic, readonly) HPTThreeDSecureEnrollmentStatus enrollmentStatus;
@property (nonatomic, readonly) NSString *enrollmentMessage;

@end
