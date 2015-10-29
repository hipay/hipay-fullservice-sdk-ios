//
//  HPTQiwiWalletPaymentMethodRequest.m
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPTQiwiWalletPaymentMethodRequest.h"

@implementation HPTQiwiWalletPaymentMethodRequest

+ (instancetype)qiwiWalletPaymentMethodRequestUsername:(NSString *)username
{
    HPTQiwiWalletPaymentMethodRequest *result = [[HPTQiwiWalletPaymentMethodRequest alloc] init];

    result.username = username;
    
    return result;
}

@end
