//
//  HPTOperationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTOperationMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTOperation.h"

@implementation HPTOperationMapper

+ (NSDictionary *)operationTypeMapping
{
    return @{@"capture": @(HPTOperationTypeCapture),
             @"refund": @(HPTOperationTypeRefund),
             @"cancel": @(HPTOperationTypeCancel),
             @"acceptChallenge": @(HPTOperationTypeAcceptChallenge),
             @"denyChallenge": @(HPTOperationTypeDenyChallenge)};
}

@end
