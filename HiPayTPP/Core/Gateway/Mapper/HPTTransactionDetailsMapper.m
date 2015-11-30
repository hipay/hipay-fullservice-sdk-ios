//
//  HPTTransactionDetailsMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 19/10/2015.
//
//

#import "HPTTransactionDetailsMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTTransactionMapper.h"
#import "HPTTransaction.h"

@implementation HPTTransactionDetailsMapper

- (id)mappedObject
{
    if ([self isRawDataSingleObject]) {
        return @[[HPTTransactionMapper mapperWithRawData:[self transactionData]].mappedObject];
    }
    else if ([self isEmpty]) {
        return @[];
    }
    else {
        NSMutableArray *result = [NSMutableArray array];
        
        for (NSDictionary *transactionInfo in [self getObjectsArrayForObject:[self transactionData]]) {
            [result addObject:[HPTTransactionMapper mapperWithRawData:transactionInfo].mappedObject];
        }
        
        return [HPTTransaction sortTransactionsByRelevance:result];
    }
}

- (BOOL)isClassValid
{
    return [[self transactionData] isKindOfClass:[NSArray class]] || [[self transactionData] isKindOfClass:[NSDictionary class]] || [self.rawData isKindOfClass:[NSDictionary class]];
}

- (BOOL)isEmpty
{
    return [self.rawData isKindOfClass:[NSDictionary class]] && [self.rawData objectForKey:@"transaction"] == nil;
}

- (BOOL)isRawDataSingleObject
{
    NSDictionary *transactionData = [self transactionData];
    
    return [transactionData isKindOfClass:[NSDictionary class]] && transactionData[@"state"] != nil;
}

- (BOOL)isValid
{
    return [super isValid] && ([self isRawDataSingleObject] || [self isEmpty] || ([self getObjectsArrayForObject:[self transactionData]] != nil));
}

- (id)transactionData
{
    if ([self.rawData isKindOfClass:[NSDictionary class]]) {
        return self.rawData[@"transaction"];
    }
    
    return nil;
}

@end
