//
//  HPTQiwiWalletPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPTAbstractPaymentMethodRequest.h"

@interface HPTQiwiWalletPaymentMethodRequest : HPTAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *username;

+ (instancetype)qiwiWalletPaymentMethodRequestUsername:(NSString *)username;

@end
