//
//  HPFOperationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFOperationMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFOperation.h"
#import "HPFTransactionRelatedItemMapper+Private.h"

@implementation HPFOperationMapper

+ (NSDictionary *)operationTypeMapping
{
    return @{@"capture": @(HPFOperationTypeCapture),
             @"refund": @(HPFOperationTypeRefund),
             @"cancel": @(HPFOperationTypeCancel),
             @"acceptChallenge": @(HPFOperationTypeAcceptChallenge),
             @"denyChallenge": @(HPFOperationTypeDenyChallenge)};
}

- (id _Nonnull)mappedObject
{
    HPFOperation *object = [self mappedObjectWithTransactionRelatedItem:[[HPFOperation alloc] init]];

    [object setValue:@([self getIntegerEnumValueWithKey:@"operation" defaultEnumValue:HPFOperationTypeUnknown allValues:[HPFOperationMapper operationTypeMapping]]) forKey:@"operation"];
    
    return object;
}

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"operation"] != nil;
}

@end
