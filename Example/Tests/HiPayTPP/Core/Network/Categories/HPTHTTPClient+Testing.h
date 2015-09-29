//
//  HPTHTTPClient+Testing.h
//  HiPayTPP
//
//  Created by Jonathan TIRET on 25/09/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

@interface HPTHTTPClient (Testing)

- (void)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPTHTTPClientCompletionBlock)completionBlock;

- (NSURLRequest *)createURLRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters;

- (NSString *)queryStringForDictionary:(NSDictionary *)dictionary;

- (NSString *)createAuthHeader;

//- (NSDictionary *)parsedData:(NSString *)

@end
