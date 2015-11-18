//
//  HPTTransaction.m
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import "HPTTransaction.h"

@implementation HPTTransaction

- (BOOL)isHandled
{
    if ((self.state == HPTTransactionStatePending) || (self.state == HPTTransactionStateCompleted)) {
        return YES;
    }
    
    return NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eci = HPTECIUndefined;
        _avsResult = HPTAVSResultNotApplicable;
        _cvcResult = HPTCVCResultNotApplicable;
    }
    return self;
}

- (BOOL)isMoreRelevantThan:(HPTTransaction *)transaction
{
    if ([transaction isHandled]) {
        return NO;
    }
    
    if ([self isHandled]) {
        return YES;
    }

    return [transaction.dateCreated compare:self.dateCreated] == NSOrderedAscending;
}

+ (NSArray<HPTTransaction *> *)sortTransactionsByRelevance:(NSArray<HPTTransaction *> *)transactions
{
    return [transactions sortedArrayUsingComparator:^NSComparisonResult(HPTTransaction * _Nonnull obj1, HPTTransaction *  _Nonnull obj2) {
       
        if ([obj1 isMoreRelevantThan:obj2]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
}

@end
