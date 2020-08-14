//
//  HPFGatewayClient+Testing.h
//  Pods
//
//  Created by HiPay on 13/10/2015.
//
//

@interface HPFGatewayClient (Testing)

+ (HPFHTTPClient *)createClient;

- (instancetype)initWithHTTPClient:(HPFHTTPClient *)theHTTPClient clientConfig:(HPFClientConfig *)theClientConfig;

- (id<HPFRequest>)handleRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock;
- (id<HPFRequest>)handleRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 isApplePay:(BOOL)isApplePay path:(NSString *)path parameters:(NSDictionary *)parameters responseMapperClass:(Class)responseMapperClass isArray:(BOOL)isArray completionHandler:(void (^)(id result, NSError *error))completionBlock;

- (NSString *)operationValueForOperationType:(HPFOperationType)operationType;

- (BOOL)isRedirectURLComponentsPathValid:(NSArray *)pathComponents;

@end
