//
//  HPFAbstractClient+Private.h
//  Pods
//
//  Created by Jonathan TIRET on 05/10/2015.
//
//

#import "HPFAbstractClient.h"


#import "HPFErrors.h"
#import "HPFHTTPClient.h"
#import "HPFClientConfig.h"


@interface HPFAbstractClient (Private)

- (NSError * _Nonnull)errorForResponseBody:(NSDictionary * _Nonnull)body andError:(NSError * _Nonnull)error;

- (instancetype _Nonnull)initWithHTTPClient:(HPFHTTPClient * _Nonnull)HTTPClient clientConfig:(HPFClientConfig * _Nonnull)theClientConfig;

- (HPFErrorCode)errorCodeForNumber:(NSString * _Nonnull)codeNumber;


@end
