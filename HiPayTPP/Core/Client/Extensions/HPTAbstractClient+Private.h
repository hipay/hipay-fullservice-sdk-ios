//
//  HPTAbstractClient+Private.h
//  Pods
//
//  Created by Jonathan TIRET on 05/10/2015.
//
//

#import "HPTErrors.h"

@interface HPTAbstractClient (Private)

- (NSError *)errorForResponseBody:(NSDictionary *)body andError:(NSError *)error;

- (HPTErrorCode)errorCodeForNumber:(NSString *)codeNumber;

- (void)manageRequestWithHTTPResponse:(HPTHTTPResponse *)response error:(NSError *)error andCompletionHandler:(HPTSecureVaultClientCompletionBlock)completionBlock;

- (instancetype)initWithHTTPClient:(HPTHTTPClient *)HTTPClient clientConfig:(HPTClientConfig *)theClientConfig;

@end
