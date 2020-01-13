//
//  HPFQiwiWalletPaymentMethodRequest.m
//  Pods
//
//  Created by HiPay on 29/10/2015.
//
//

#import "HPFQiwiWalletPaymentMethodRequest.h"

@implementation HPFQiwiWalletPaymentMethodRequest

+ (instancetype)qiwiWalletPaymentMethodRequestWithUsername:(NSString *)username
{
    HPFQiwiWalletPaymentMethodRequest *result = [[HPFQiwiWalletPaymentMethodRequest alloc] init];

    result.username = username;
    
    return result;
}

@end
