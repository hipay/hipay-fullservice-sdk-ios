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

- (void)handleRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock;

- (instancetype)initWithHTTPClient:(HPTHTTPClient *)HTTPClient clientConfig:(HPTClientConfig *)theClientConfig;

@end
