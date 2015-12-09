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

typedef void (^HPFSecureVaultClientCompletionBlock)(HPFPaymentCardToken * _Nullable cardToken, NSError * _Nullable error);

@interface HPFSecureVaultClient : HPFAbstractClient
{
    HPFHTTPClient *HTTPClient;
    HPFClientConfig *clientConfig;
}

+ (instancetype _Nonnull)sharedClient;

- (id<HPFRequest> _Nonnull)generateTokenWithCardNumber:(NSString * _Nonnull)cardNumber cardExpiryMonth:(NSString * _Nonnull)cardExpiryMonth cardExpiryYear:(NSString * _Nonnull)cardExpiryYear cardHolder:(NSString * _Nonnull)cardHolder securityCode:(NSString * _Nullable)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)lookupPaymentCardWithToken:(NSString * _Nonnull)token requestID:(NSString * _Nonnull)requestID andCompletionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)updatePaymentCardWithToken:(NSString * _Nonnull)token requestID:(NSString * _Nonnull)requestID setCardExpiryMonth:(NSString * _Nonnull)cardExpiryMonth cardExpiryYear:(NSString * _Nonnull)cardExpiryYear cardHolder:(NSString * _Nonnull)cardHolder completionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

@end
