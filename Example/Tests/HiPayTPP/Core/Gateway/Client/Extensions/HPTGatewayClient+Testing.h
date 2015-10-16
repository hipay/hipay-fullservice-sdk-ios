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

@end
