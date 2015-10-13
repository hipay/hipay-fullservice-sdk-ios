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
#import "HPTTransactionRelatedItemMapper+Private.h"

@implementation HPTOperationMapper

+ (NSDictionary *)operationTypeMapping
{
    return @{@"capture": @(HPTOperationTypeCapture),
             @"refund": @(HPTOperationTypeRefund),
             @"cancel": @(HPTOperationTypeCancel),
             @"acceptChallenge": @(HPTOperationTypeAcceptChallenge),
             @"denyChallenge": @(HPTOperationTypeDenyChallenge)};
}

- (id)mappedObject
{
    HPTOperation *object = [self mappedObjectWithTransactionRelatedItem:[[HPTOperation alloc] init]];

    [object setValue:@([self getIntegerEnumValueWithKey:@"operation" defaultEnumValue:HPTOperationTypeUnknown allValues:[HPTOperationMapper operationTypeMapping]]) forKey:@"operation"];
    
    return object;
}

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"operation"] != nil;
}

@end
