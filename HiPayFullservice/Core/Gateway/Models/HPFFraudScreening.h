//
//  HPFFraudScreening.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

/**
 *  The overall result of risk assessment returned by the Payment Gateway.
 */
typedef NS_ENUM(NSInteger, HPFFraudScreeningResult) {

    /**
     *  Unknown result.
     */
    HPFFraudScreeningResultUnknown,
    
    /**
     *  Rules were not checked.
     */
    HPFFraudScreeningResultPending,
    
    /**
     *  Transaction accepted.
     */
    HPFFraudScreeningResultAccepted,
    
    /**
     *  Transaction rejected due to system rules.
     */
    HPFFraudScreeningResultBlocked,
    
    /**
     *  Transaction has been marked for review.
     */
    HPFFraudScreeningResultChallenged,
};

/**
 *  The decision made when the overall risk result returns challenged.
 */
typedef NS_ENUM(NSInteger, HPFFraudScreeningReview) {

    /**
     *  No review required.
     */
    HPFFraudScreeningReviewNone,
    
    /**
     *  A decision to release or cancel the transaction is pending.
     */
    HPFFraudScreeningReviewPending,
    
    /**
     *  The transaction has been released for processing.
     */
    HPFFraudScreeningReviewAllowed,

    /**
     *  The transaction has been cancelled.
     */
    HPFFraudScreeningReviewDenied,
};

/**
 *  Describes the result of the fraud screening.
 */
@interface HPFFraudScreening : NSObject

/**
 *  Total score assigned to the transaction (main risk indicator).
 */
@property (nonatomic, readonly) NSInteger scoring;

/**
 *  The overall result of risk assessment returned by the Payment Gateway.
 */
@property (nonatomic, readonly) HPFFraudScreeningResult result;

/**
 *  The decision made when the overall risk result returns "challenged".
 */
@property (nonatomic, readonly) HPFFraudScreeningReview review;

@end
