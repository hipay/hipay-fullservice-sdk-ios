//
//  HPFFraudScreeningMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFFraudScreeningMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFFraudScreening.h"

@implementation HPFFraudScreeningMapper

- (id _Nonnull)mappedObject
{
    
    HPFFraudScreening *object = [[HPFFraudScreening alloc] init];
    
    [object setValue:@([self getIntegerForKey:@"scoring"]) forKey:@"scoring"];
    [object setValue:@([self getIntegerEnumValueWithKey:@"result" defaultEnumValue:HPFFraudScreeningResultUnknown allValues:[HPFFraudScreeningMapper resultMapping]]) forKey:@"result"];
    [object setValue:@([self getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPFFraudScreeningReviewNone allValues:[HPFFraudScreeningMapper reviewMapping]]) forKey:@"review"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"result"] != nil && [self.rawData objectForKey:@"scoring"] != nil;
}

+ (NSDictionary *)resultMapping
{
    return @{@"pending": @(HPFFraudScreeningReviewPending),
             @"accepted": @(HPFFraudScreeningResultAccepted),
             @"challenged": @(HPFFraudScreeningResultChallenged),
             @"blocked": @(HPFFraudScreeningResultBlocked)};
}

+ (NSDictionary *)reviewMapping
{
    return @{@"pending": @(HPFFraudScreeningReviewPending),
             @"allowed": @(HPFFraudScreeningReviewAllowed),
             @"denied": @(HPFFraudScreeningReviewDenied)};
}


@end
