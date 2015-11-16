//
//  SecureVaultClient.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTPaymentCardToken.h"
#import "HPTPaymentCardTokenMapper.h"
#import "HPTHTTPClient.h"
#import "HPTClientConfig.h"
#import "HPTAbstractClient.h"

#define HPTSecureVaultClientBaseURLStage        @"https://stage-secure-vault.hipay-tpp.com/rest/v1/"
#define HPTSecureVaultClientBaseURLProduction   @"https://secure-vault.hipay-tpp.com/rest/v1/"

typedef void (^HPTSecureVaultClientCompletionBlock)(HPTPaymentCardToken *cardToken, NSError *error);

@interface HPTSecureVaultClient : HPTAbstractClient
{
    HPTHTTPClient *HTTPClient;
    HPTClientConfig *clientConfig;
}

+ (instancetype)sharedClient;

- (id<HPTRequest>)generateTokenWithCardNumber:(NSString *)cardNumber cardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder securityCode:(NSString *)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock;

- (id<HPTRequest>)lookupPaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock;

- (id<HPTRequest>)updatePaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID setCardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder completionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock;

@end
