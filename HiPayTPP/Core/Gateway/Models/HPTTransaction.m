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

@end
