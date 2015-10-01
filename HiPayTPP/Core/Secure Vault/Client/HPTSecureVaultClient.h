//
//  SecureVaultClient.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTPaymentCardToken.h"

typedef void (^HPTSecureVaultClientCompletionBlock)(HPTPaymentCardToken *cardToken, NSError *error);

@interface HPTSecureVaultClient : NSObject

- (void)generateTokenWithCardNumber:(NSString *)cardNumber cardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder securityCode:(NSString *)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock;

@end
