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

@implementation HPTTransactionDetailsMapper

- (id)mappedObject
{
    if ([self isRawDataSingleObject]) {
        return @[[HPTTransactionMapper mapperWithRawData:[self transactionData]].mappedObject];
    } else {
        NSMutableArray *result = [NSMutableArray array];
        
        if ([self isRawDataArray]) {
            for (NSDictionary *transactionInfo in [self transactionData]) {
                [result addObject:[HPTTransactionMapper mapperWithRawData:transactionInfo].mappedObject];
            }
        }
        
        else if ([self isRawDataDictionaryArray]) {
            for (NSDictionary *transactionInfo in [[self transactionData] allValues]) {
                [result addObject:[HPTTransactionMapper mapperWithRawData:transactionInfo].mappedObject];
            }
        }
        
        return result;
    }
}

- (BOOL)isClassValid
{
    return [[self transactionData] isKindOfClass:[NSArray class]] || [[self transactionData] isKindOfClass:[NSDictionary class]];
}

- (BOOL)isRawDataDictionaryArray
{
    NSDictionary *transactionData = [self transactionData];

    return [transactionData isKindOfClass:[NSDictionary class]] && [[transactionData allKeys] indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj isKindOfClass:[NSString class]]) {
            return NO;
        }
        
        NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSRange r = [obj rangeOfCharacterFromSet:nonNumbers];
        
        return r.location == NSNotFound && [[transactionData objectForKey:obj] isKindOfClass:[NSDictionary class]];
        
    }].count == [transactionData count];
}

- (BOOL)isRawDataArray
{
    NSArray *transactionData = [self transactionData];

    return [transactionData isKindOfClass:[NSArray class]] && [transactionData indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        return [obj isKindOfClass:[NSDictionary class]];
        
    }].count == [transactionData count];
}

- (BOOL)isRawDataSingleObject
{
    NSDictionary *transactionData = [self transactionData];
    
    return [transactionData isKindOfClass:[NSDictionary class]] && transactionData[@"state"] != nil;
}

- (BOOL)isValid
{
    return [super isValid] && ([self isRawDataSingleObject] || [self isRawDataDictionaryArray] || [self isRawDataArray]);
}

- (id)transactionData
{
    if ([self.rawData isKindOfClass:[NSDictionary class]]) {
        return self.rawData[@"transaction"];
    }
    
    return nil;
}

@end
