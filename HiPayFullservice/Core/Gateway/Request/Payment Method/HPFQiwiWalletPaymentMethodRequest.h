//
//  HPFQiwiWalletPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPFAbstractPaymentMethodRequest.h"

@interface HPFQiwiWalletPaymentMethodRequest : HPFAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *username;

+ (instancetype)qiwiWalletPaymentMethodRequestWithUsername:(NSString *)username;

@end
