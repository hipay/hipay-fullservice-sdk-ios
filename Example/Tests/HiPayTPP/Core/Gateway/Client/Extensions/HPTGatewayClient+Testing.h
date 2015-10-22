//
//  HPTGatewayClient+Testing.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

@interface HPTGatewayClient (Testing)

+ (HPTHTTPClient *)createClient;

- (instancetype)initWithHTTPClient:(HPTHTTPClient *)theHTTPClient clientConfig:(HPTClientConfig *)theClientConfig;

- (void)handleRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock;

- (NSString *)operationValueForOperationType:(HPTOperationType)operationType;

@end
