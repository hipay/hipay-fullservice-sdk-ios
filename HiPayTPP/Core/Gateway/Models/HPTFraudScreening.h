//
//  HPTFraudScreening.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTFraudScreeningResult) {
    
    HPTFraudScreeningResultUnknown,
    HPTFraudScreeningResultPending,
    HPTFraudScreeningResultAccepted,
    HPTFraudScreeningResultBlocked,
    HPTFraudScreeningResultChallenged,
    
};

typedef NS_ENUM(NSInteger, HPTFraudScreeningReview) {
    
    HPTFraudScreeningReviewNone,
    HPTFraudScreeningReviewPending,
    HPTFraudScreeningReviewAllowed,
    HPTFraudScreeningReviewDenied,
    
};

@interface HPTFraudScreening : NSObject

@property (nonatomic, readonly) NSInteger scoring;
@property (nonatomic, readonly) HPTFraudScreeningResult result;
@property (nonatomic, readonly) HPTFraudScreeningReview review;

@end
