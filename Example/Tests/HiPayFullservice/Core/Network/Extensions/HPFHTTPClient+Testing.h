//
//  HPFHTTPClient+Testing.h
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 25/09/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

@interface HPFHTTPClient (Testing)

- (NSURLRequest *)createURLRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 path:(NSString *)path parameters:(NSDictionary *)parameters;

- (NSString *)queryStringForDictionary:(NSDictionary *)dictionary;

- (NSString *)createAuthHeaderWithSignature:(NSString *)signature;

- (NSError *)errorFromURLConnectionError:(NSError *)error;

- (NSString *)URLEncodeString:(NSString *)string usingEncoding:(NSStringEncoding)encoding;

@end
