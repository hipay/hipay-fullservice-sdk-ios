//
//  HPTTransactionErrorsManagerResult.m
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import "HPTTransactionErrorResult.h"

@implementation HPTTransactionErrorResult

- (instancetype)initWithFormAction:(HPTFormAction)formAction
{
    self = [super init];
    if (self) {
        _formAction = formAction;
    }
    return self;
}

@end
