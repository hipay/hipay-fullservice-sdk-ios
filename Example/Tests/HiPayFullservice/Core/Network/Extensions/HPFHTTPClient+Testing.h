//
//  HPFHTTPClient+Testing.h
//  HiPayFullservice
//
//  Created by HiPay on 25/09/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

@interface HPFHTTPClient (Testing)

- (NSURLRequest *)createURLRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 isApplePay:(BOOL)isApplePay path:(NSString *)path parameters:(NSDictionary *)parameters;

- (NSString *)queryStringForDictionary:(NSDictionary *)dictionary;

- (NSString *)createAuthHeaderWithSignature:(NSString *)signature;

- (NSError *)errorFromURLConnectionError:(NSError *)error;

- (NSString *)URLEncodeString:(NSString *)string usingEncoding:(NSStringEncoding)encoding;

@end
