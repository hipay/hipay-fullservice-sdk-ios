//
//  HPFQiwiWalletPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 29/10/2015.
//
//

#import "HPFAbstractPaymentMethodRequest.h"

/**
 *  Describes Qiwi Wallet information to be sent alongside an order request.
 */
@interface HPFQiwiWalletPaymentMethodRequest : HPFAbstractPaymentMethodRequest

/**
 *  The Qiwi user's ID, to whom the invoice is issued.
 *  It is the user's phone number, in international format. Example: +79263745223
 */
@property (nonatomic, copy) NSString *username;

+ (instancetype)qiwiWalletPaymentMethodRequestWithUsername:(NSString *)username;

@end
