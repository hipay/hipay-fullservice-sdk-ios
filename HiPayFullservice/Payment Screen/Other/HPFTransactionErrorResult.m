//
//  HPFTransactionErrorsManagerResult.m
//  Pods
//
//  Created by HiPay on 20/11/2015.
//
//

#import "HPFTransactionErrorResult.h"

@implementation HPFTransactionErrorResult

- (instancetype)initWithFormAction:(HPFFormAction)formAction
{
    self = [super init];
    if (self) {
        _formAction = formAction;
    }
    return self;
}

@end
