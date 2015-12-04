//
//  SecureVaultClient.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFPaymentCardToken.h"
#import "HPFPaymentCardTokenMapper.h"
#import "HPFHTTPClient.h"
#import "HPFClientConfig.h"
#import "HPFAbstractClient.h"

#define HPFSecureVaultClientBaseURLStage        @"https://stage-secure-vault.hipay-tpp.com/rest/v1/"
#define HPFSecureVaultClientBaseURLProduction   @"https://secure-vault.hipay-tpp.com/rest/v1/"

typedef void (^HPFSecureVaultClientCompletionBlock)(HPFPaymentCardToken *cardToken, NSError *error);

@interface HPFSecureVaultClient : HPFAbstractClient
{
    HPFHTTPClient *HTTPClient;
    HPFClientConfig *clientConfig;
}

+ (instancetype)sharedClient;

- (id<HPFRequest>)generateTokenWithCardNumber:(NSString *)cardNumber cardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder securityCode:(NSString *)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPFSecureVaultClientCompletionBlock)completionBlock;

- (id<HPFRequest>)lookupPaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID andCompletionHandler:(HPFSecureVaultClientCompletionBlock)completionBlock;

- (id<HPFRequest>)updatePaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID setCardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder completionHandler:(HPFSecureVaultClientCompletionBlock)completionBlock;

@end
