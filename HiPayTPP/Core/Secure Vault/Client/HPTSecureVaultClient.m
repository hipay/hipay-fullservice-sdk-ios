//
//  SecureVaultClient.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTSecureVaultClient.h"
#import "HPTAbstractClient+Private.h"

@implementation HPTSecureVaultClient

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
    return [self initWithHTTPClient:[HPTSecureVaultClient createClient] clientConfig:[HPTClientConfig sharedClientConfig]];
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
    NSDictionary *parameters = @{
                                 @"card_number": cardNumber,
                                 @"card_expiry_month": cardExpiryMonth,
                                 @"card_expiry_year": cardExpiryYear,
                                 @"card_holder": cardHolder,
                                 @"cvc": securityCode,
                                 @"multi_use": @(multiUse).stringValue,
                                 };
    
    [HTTPClient performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
        if (error == nil) {
            HPTPaymentCardToken *newToken = [self paymentCardTokenWithData:response.body];
            
            if (newToken != nil) {
                completionBlock(newToken, nil);
            } else {
                completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeAPIOther userInfo:@{NSLocalizedFailureReasonErrorKey: @"Malformed server response"}]);
            }
        } else {
            completionBlock(nil, [self errorForResponseBody:response.body andError:error]);
        }
        
    }];
}

@end
