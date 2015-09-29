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

- (NSString *)queryStringForDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (id key in [dictionary allKeys]) {

        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        
        [parameters addObject: part];
    }
    
    return [parameters componentsJoinedByString: @"&"];
}

- (NSString *)createAuthHeader
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", login, password];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return authHeaderValue;
}

- (NSURLRequest *)createURLRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] init];
    NSString *baseURLAndPath = [NSString stringWithFormat:@"%@%@", self.baseURL, path];
    
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [URLRequest setValue:[self createAuthHeader] forHTTPHeaderField:@"Authorization"];
    
    switch (method) {
        case HPTHTTPMethodGet:
            URLRequest.HTTPMethod = @"GET";
            
            if (parameters != nil) {
                NSString *URL = [NSString stringWithFormat:@"%@?%@", baseURLAndPath, [self queryStringForDictionary:parameters]];
                
                URLRequest.URL = [NSURL URLWithString:URL];
            } else {
                URLRequest.URL = [NSURL URLWithString:baseURLAndPath];
            }
            
            break;
            
        case HPTHTTPMethodPost:
            URLRequest.HTTPMethod = @"POST";
            URLRequest.URL = [NSURL URLWithString:baseURLAndPath];
            
            URLRequest.HTTPBody = [[self queryStringForDictionary:parameters] dataUsingEncoding:NSUTF8StringEncoding];
            
            break;
    }
    
    return URLRequest;
}

- (void)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPTHTTPClientCompletionBlock)completionBlock
{
    
    NSURLRequest *request = [self createURLRequestWithMethod:method path:path parameters:parameters];
    
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            HPTHTTPResponse *clientResponse = [[HPTHTTPResponse alloc] initWithStatusCode:[(NSHTTPURLResponse *)response statusCode] body:body];
            
            completionBlock(clientResponse, nil);
        }
        
    }];
    
    [sessionDataTask resume];
}

@end
