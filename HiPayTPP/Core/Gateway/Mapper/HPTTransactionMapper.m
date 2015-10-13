//
//  HPTTransactionMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTTransactionMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTTransaction.h"

@implementation HPTTransactionMapper

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"state"] != nil;
}

@end
