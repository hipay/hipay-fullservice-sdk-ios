//
//  HPTFraudScreeningMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTFraudScreeningMapper.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTFraudScreeningMapper

- (id _Nonnull)mappedObject
{
    
    HPTFraudScreening *object = [[HPTFraudScreening alloc] init];
    
    [object setValue:@([self getIntegerFromKey:@"scoring"]) forKey:@"scoring"];
    [object setValue:@([self getIntegerEnumValueWithKey:@"result" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper resultMapping]]) forKey:@"result"];
    [object setValue:@([self getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPTFraudScreeningReviewNone allValues:[HPTFraudScreeningMapper reviewMapping]]) forKey:@"review"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"result"] != nil && [self.rawData objectForKey:@"scoring"] != nil;
}

+ (NSDictionary *)resultMapping
{
    return @{@"pending": @(HPTFraudScreeningReviewPending),
             @"accepted": @(HPTFraudScreeningResultAccepted),
             @"challenged": @(HPTFraudScreeningResultChallenged),
             @"blocked": @(HPTFraudScreeningResultBlocked)};
}

+ (NSDictionary *)reviewMapping
{
    return @{@"pending": @(HPTFraudScreeningReviewPending),
             @"allowed": @(HPTFraudScreeningReviewAllowed),
             @"denied": @(HPTFraudScreeningReviewDenied)};
}


@end
