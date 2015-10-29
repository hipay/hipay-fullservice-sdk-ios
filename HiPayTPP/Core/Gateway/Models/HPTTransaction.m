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

@end
