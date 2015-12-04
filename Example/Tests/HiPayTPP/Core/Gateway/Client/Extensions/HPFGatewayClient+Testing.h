//
//  HPFGatewayClient+Testing.h
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

@interface HPFGatewayClient (Testing)

+ (HPFHTTPClient *)createClient;

- (instancetype)initWithHTTPClient:(HPFHTTPClient *)theHTTPClient clientConfig:(HPFClientConfig *)theClientConfig;

- (id<HPFRequest>)handleRequestWithMethod:(HPFHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock;

- (NSString *)operationValueForOperationType:(HPFOperationType)operationType;

@end
