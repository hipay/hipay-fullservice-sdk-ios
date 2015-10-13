//
//  HPTGatewayClient.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import <HiPayTPP/HiPayTPP.h>
#import "HPTHTTPClient.h"
#import "HPTClientConfig.h"
#import "HPTAbstractClient.h"

#define HPTGatewayClientBaseURLStage        @"https://stage-secure-gateway.hipay-tpp.com/rest/v1/"
#define HPTGatewayClientBaseURLProduction   @"https://secure-gateway.hipay-tpp.com/rest/v1/"

typedef void (^HPTSecureVaultClientCompletionBlock)(HPTPaymentCardToken *cardToken, NSError *error);

@interface HPTGatewayClient : HPTAbstractClient
{
    HPTHTTPClient *HTTPClient;
    HPTClientConfig *clientConfig;
}

@end
