//
//  HPTHTTP.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPTHTTPClient.h"

@implementation HPTHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)URL login:(NSString *)theLogin password:(NSString *)thePassword
{
    self = [super init];
    if (self) {
        _baseURL = URL;
        login = theLogin;
        password = thePassword;
    }
    return self;
}

- (NSURLRequest *)createURLRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPTHTTPClientCompletionBlock)completionBlock
{
    
}

- (void)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters
{

}

@end
