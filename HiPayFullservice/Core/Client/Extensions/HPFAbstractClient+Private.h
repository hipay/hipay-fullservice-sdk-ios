//
//  HPFAbstractClient+Private.h
//  Pods
//
//  Created by Jonathan TIRET on 05/10/2015.
//
//

#import "HPFErrors.h"

@interface HPFAbstractClient (Private)

- (NSError *)errorForResponseBody:(NSDictionary *)body andError:(NSError *)error;

- (HPFErrorCode)errorCodeForNumber:(NSString *)codeNumber;

- (instancetype)initWithHTTPClient:(HPFHTTPClient *)HTTPClient clientConfig:(HPFClientConfig *)theClientConfig;

@end
