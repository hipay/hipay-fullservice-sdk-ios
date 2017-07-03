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

/**
 *  This type of block is executed once a credit card token-related request finishes.
 *
 *  @param cardToken The credit card token. This argument is nil if the request fails.
 *  @param error     The detailed error if the request fails, nil otherwise.
 */
typedef void (^HPFSecureVaultClientCompletionBlock)(HPFPaymentCardToken * _Nullable cardToken, NSError * _Nullable error);

/**
 *  Secure Vault is the middle component between your application and the HiPay Fullservice Secure Vault.
 *  Use its method to perform actions such as tokenizing a card, getting information about a credit card token, etc.
 */
@interface HPFSecureVaultClient : HPFAbstractClient

/**
 *  Creates and returns the only instance of the Secure Vault client class that you need to use.
 *
 *  @return The shared Secure Vault client.
 */
+ (instancetype _Nonnull)sharedClient;

/**
 *  Allows you to perform a credit card tokenization. Sends the sensitive card data in the HiPay Fullservice Secure Vault and returns a token allowing you to charge the card.
 *
 *  @param cardNumber      The card number. The length is from 12 to 19 digits.
 *  @param cardExpiryMonth The card expiry month. Expressed with two digits (e.g., 01).
 *  @param cardExpiryYear  The card expiry year. Expressed with four digits (e.g., 2014).
 *  @param cardHolder      The cardholder name as it appears on the card (up to 25 chars).
 *  @param securityCode    The 3 or 4 digit security code (called CVC2, CVV2 or CID depending on the card brand) that appears on the credit card.
 *  @param multiUse        Indicates if the token should be generated either for a single-use or a multi-use.
 *  @param completionBlock The HPFSecureVaultClientCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFSecureVaultClientCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)generateTokenWithCardNumber:(NSString * _Nonnull)cardNumber cardExpiryMonth:(NSString * _Nonnull)cardExpiryMonth cardExpiryYear:(NSString * _Nonnull)cardExpiryYear cardHolder:(NSString * _Nonnull)cardHolder securityCode:(NSString * _Nullable)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

/**
 *  Allows you to lookup the details of a credit card that you have tokenized.
 *
 *  @param token           The token to look for
 *  @param requestID       The request ID linked to the token.
 *  @param completionBlock The HPFSecureVaultClientCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFSecureVaultClientCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)lookupPaymentCardWithToken:(NSString * _Nonnull)token requestID:(NSString * _Nonnull)requestID completionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

/**
 *  Allows you to update the details of a credit card that you have tokenized.
 *
 *  @param token           The token to be updated.
 *  @param requestID       The request ID linked to the card token.
 *  @param cardExpiryMonth The card expiry month. Expressed with two digits (e.g., 01).
 *  @param cardExpiryYear  The card expiry year. Expressed with four digits (e.g., 2014).
 *  @param cardHolder      The cardholder name as it appears on the card (up to 25 chars).
 *  @param completionBlock The HPFSecureVaultClientCompletionBlock block to execute after the request finishes.
 *
 *  @return An object conforming to the HPFRequest protocol, allowing you to cancel the request if need be.
 *
 *  @see HPFSecureVaultClientCompletionBlock
 *  @see HPFRequest
 */
- (id<HPFRequest> _Nonnull)updatePaymentCardWithToken:(NSString * _Nonnull)token requestID:(NSString * _Nonnull)requestID setCardExpiryMonth:(NSString * _Nonnull)cardExpiryMonth cardExpiryYear:(NSString * _Nonnull)cardExpiryYear cardHolder:(NSString * _Nonnull)cardHolder completionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

- (id<HPFRequest> _Nonnull)generateTokenWithApplePayToken:(NSString * _Nonnull)applePayToken privateKeyPass:(NSString * _Nonnull)cardExpiryMonth andCompletionHandler:(HPFSecureVaultClientCompletionBlock _Nullable)completionBlock;

@end
