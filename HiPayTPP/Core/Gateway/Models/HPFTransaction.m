//
//  HPFTransaction.m
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import "HPFTransaction.h"

@implementation HPFTransaction

- (BOOL)isHandled
{
    if ((self.state == HPFTransactionStatePending) || (self.state == HPFTransactionStateCompleted)) {
        return YES;
    }
    
    return NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eci = HPFECIUndefined;
        _avsResult = HPFAVSResultNotApplicable;
        _cvcResult = HPFCVCResultNotApplicable;
    }
    return self;
}

- (BOOL)isMoreRelevantThan:(HPFTransaction *)transaction
{
    if ([transaction isHandled]) {
        return NO;
    }
    
    if ([self isHandled]) {
        return YES;
    }

    return [transaction.dateCreated compare:self.dateCreated] == NSOrderedAscending;
}

+ (NSArray<HPFTransaction *> *)sortTransactionsByRelevance:(NSArray<HPFTransaction *> *)transactions
{
    return [transactions sortedArrayUsingComparator:^NSComparisonResult(HPFTransaction * _Nonnull obj1, HPFTransaction *  _Nonnull obj2) {
       
        if ([obj1 isMoreRelevantThan:obj2]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
}

@end
