//
//  HPFFraudScreening.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPFFraudScreeningResult) {
    
    HPFFraudScreeningResultUnknown,
    HPFFraudScreeningResultPending,
    HPFFraudScreeningResultAccepted,
    HPFFraudScreeningResultBlocked,
    HPFFraudScreeningResultChallenged,
    
};

typedef NS_ENUM(NSInteger, HPFFraudScreeningReview) {
    
    HPFFraudScreeningReviewNone,
    HPFFraudScreeningReviewPending,
    HPFFraudScreeningReviewAllowed,
    HPFFraudScreeningReviewDenied,
    
};

@interface HPFFraudScreening : NSObject

@property (nonatomic, readonly) NSInteger scoring;
@property (nonatomic, readonly) HPFFraudScreeningResult result;
@property (nonatomic, readonly) HPFFraudScreeningReview review;

@end
