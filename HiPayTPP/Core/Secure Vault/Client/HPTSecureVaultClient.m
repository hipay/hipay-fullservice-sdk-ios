//
//  SecureVaultClient.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTSecureVaultClient.h"
#import "HPTAbstractClient+Private.h"

HPTSecureVaultClient *HPTSecureVaultClientSharedInstance = nil;

@implementation HPTSecureVaultClient

+ (instancetype)sharedClient
{
    if (HPTSecureVaultClientSharedInstance == nil) {
        HPTSecureVaultClientSharedInstance = [[HPTSecureVaultClient alloc] init];
    }
    
    return HPTSecureVaultClientSharedInstance;
}

- (instancetype)initWithHTTPClient:(HPTHTTPClient *)theHTTPClient clientConfig:(HPTClientConfig *)theClientConfig
{
    self = [super init];
    if (self) {
        HTTPClient = theHTTPClient;
        clientConfig = theClientConfig;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        HTTPClient = [HPTSecureVaultClient createClient];
        clientConfig = [HPTClientConfig sharedClientConfig];
    }
    return self;
}

+ (HPTHTTPClient *)createClient
{
    NSString *baseURL;
    
    switch ([HPTClientConfig sharedClientConfig].environment) {
        case HPTEnvironmentProduction:
            baseURL = HPTSecureVaultClientBaseURLProduction;
            break;
            
        case HPTEnvironmentStage:
            baseURL = HPTSecureVaultClientBaseURLStage;
            break;
    }
    
    return [[HPTHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL] username:[HPTClientConfig sharedClientConfig].username password:[HPTClientConfig sharedClientConfig].password];
    
}

- (HPTPaymentCardToken *)paymentCardTokenWithData:(NSDictionary *)rawData
{
    return [[HPTPaymentCardTokenMapper alloc] initWithRawData:rawData].mappedObject;
}

- (void)generateTokenWithCardNumber:(NSString *)cardNumber cardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder securityCode:(NSString *)securityCode multiUse:(BOOL)multiUse andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock
{
    if (securityCode == nil) {
        securityCode = @"";
    }
    
    NSDictionary *parameters = @{
                                 @"card_number": cardNumber,
                                 @"card_expiry_month": cardExpiryMonth,
                                 @"card_expiry_year": cardExpiryYear,
                                 @"card_holder": cardHolder,
                                 @"cvc": securityCode,
                                 @"multi_use": @(multiUse).stringValue,
                                 };
    
    [HTTPClient performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        [self manageRequestWithHTTPResponse:response error:error andCompletionHandler:completionBlock];
        
    }];
}

- (void)updatePaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID setCardExpiryMonth:(NSString *)cardExpiryMonth cardExpiryYear:(NSString *)cardExpiryYear cardHolder:(NSString *)cardHolder completionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock
{
    NSDictionary *parameters = @{
                                 @"request_id": requestID,
                                 @"token": token,
                                 @"card_expiry_month": cardExpiryMonth,
                                 @"card_expiry_year": cardExpiryYear,
                                 @"card_holder": cardHolder,
                                 };
    
    [HTTPClient performRequestWithMethod:HPTHTTPMethodPost path:@"token/update" parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        [self manageRequestWithHTTPResponse:response error:error andCompletionHandler:completionBlock];
        
    }];
}

- (void)lookupPaymentCardWithToken:(NSString *)token requestID:(NSString *)requestID andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock
{
    NSDictionary *parameters = @{@"request_id": requestID};
    
    [HTTPClient performRequestWithMethod:HPTHTTPMethodGet path:[@"token/" stringByAppendingString:token] parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        [self manageRequestWithHTTPResponse:response error:error andCompletionHandler:completionBlock];
        
    }];
}

- (void)manageRequestWithHTTPResponse:(HPTHTTPResponse *)response error:(NSError *)error andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock
{
    if (completionBlock != nil) {
        
        NSError *resultError = nil;
        HPTPaymentCardToken *resultObject = nil;
        
        if (error == nil) {
            HPTPaymentCardToken *newToken = [self paymentCardTokenWithData:response.body];
            
            if (newToken != nil) {
                resultObject = newToken;
            } else {
                resultError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeAPIOther userInfo:@{NSLocalizedFailureReasonErrorKey: @"Malformed server response"}];
            }
        } else {
            resultError = [self errorForResponseBody:response.body andError:error];
        }
        
        if ([NSThread isMainThread]) {
            completionBlock(resultObject, resultError);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(resultObject, resultError);
            });
        }
    }
}

@end
