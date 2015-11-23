//
//  HPTHTTP.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPTHTTPClient.h"
#import "HPTErrors.h"

@implementation HPTHTTPClientRequest

- (instancetype)initWithURLSessionTask:(NSURLSessionTask *)URLSessionTask
{
    self = [super init];
    if (self) {
        _URLSessionTask = URLSessionTask;
    }
    return self;
}

- (void)cancel
{
    [_URLSessionTask cancel];
}

@end

@implementation HPTHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)URL username:(NSString *)theUsername password:(NSString *)thePassword
{
    self = [super init];
    if (self) {
        _baseURL = URL;
        username = theUsername;
        password = thePassword;
    }
    return self;
}

- (NSString *)URLEncodeString:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)queryStringForDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (id key in [dictionary allKeys]) {

        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *encodedValue = [self URLEncodeString:[dictionary objectForKey:key] usingEncoding:NSUTF8StringEncoding];

        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        
        [parameters addObject: part];
    }
    
    return [parameters componentsJoinedByString: @"&"];
}

- (NSString *)createAuthHeader
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
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

- (HPTHTTPClientRequest *)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPTHTTPClientCompletionBlock)completionBlock
{
    static dispatch_once_t onceBlock;
    static NSMutableArray *requests;

    dispatch_once (&onceBlock, ^{
        requests = [NSMutableArray array];
    });
    
    NSURLRequest *request = [self createURLRequestWithMethod:method path:path parameters:parameters];
    
    [requests addObject:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Network activity
        [requests removeObject:request];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = (requests.count > 0);
        
        // Cancelled by user, no callback
        if ((error == nil) || ![error.domain isEqualToString:NSURLErrorDomain] || (error.code != NSURLErrorCancelled)) {
            
            // Connection error
            if (error != nil) {
                completionBlock(nil, [self errorFromURLConnectionError:error]);
            }
            
            else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSError *JSONError = nil;
                
                id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
                
                if (JSONError == nil) {
                    HPTHTTPResponse *clientResponse = [[HPTHTTPResponse alloc] initWithStatusCode:[(NSHTTPURLResponse *)response statusCode] body:body];
                    
                    NSError *responseError = nil;
                    
                    if (NSLocationInRange(clientResponse.statusCode, (NSRange){400, 499})) {
                        responseError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{NSLocalizedDescriptionKey: HPTErrorCodeHTTPClientDescription, HPTErrorCodeHTTPStatusCodeKey: @(clientResponse.statusCode)}];
                    }
                    
                    else if (NSLocationInRange(clientResponse.statusCode, (NSRange){500, 599})) {
                        responseError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPServer userInfo:@{NSLocalizedDescriptionKey: HPTErrorCodeHTTPServerDescription, HPTErrorCodeHTTPStatusCodeKey: @(clientResponse.statusCode)}];
                    }
                    
                    completionBlock(clientResponse, responseError);
                }
                
                // Content not parsable, server error
                else {
                    completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPServer userInfo:@{NSUnderlyingErrorKey: JSONError, NSLocalizedDescriptionKey: HPTErrorCodeHTTPServerDescription, HPTErrorCodeHTTPPlainResponseKey: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], HPTErrorCodeHTTPStatusCodeKey: @([(NSHTTPURLResponse *)response statusCode])}]);
                }
            }
            
            else {
                completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{NSLocalizedDescriptionKey: HPTErrorCodeHTTPOtherDescription}]);
            }
        }
        
    }];
    
    HPTHTTPClientRequest *clientRequest = [[HPTHTTPClientRequest alloc] initWithURLSessionTask:sessionDataTask];
    
    [sessionDataTask resume];
    
    return clientRequest;
}

- (NSError *)errorFromURLConnectionError:(NSError *)error
{
    NSInteger code = HPTErrorCodeHTTPOther;
    NSString *description = HPTErrorCodeHTTPOtherDescription;
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorInternationalRoamingOff:
            case NSURLErrorCallIsActive:
            case NSURLErrorDataNotAllowed:
                code = HPTErrorCodeHTTPNetworkUnavailable;
                description = HPTErrorCodeHTTPNetworkUnavailableDescription;
                break;
                
            case NSURLErrorTimedOut:
            case NSURLErrorCancelled:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorHTTPTooManyRedirects:
            case NSURLErrorCannotDecodeRawData:
            case NSURLErrorCannotDecodeContentData:
            case NSURLErrorDataLengthExceedsMaximum:
            case NSURLErrorRedirectToNonExistentLocation:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorBadServerResponse:
            case NSURLErrorCannotParseResponse:
            case NSURLErrorResourceUnavailable:
            case NSURLErrorZeroByteResource:
            case NSURLErrorCannotLoadFromNetwork:
                code = HPTErrorCodeHTTPConnectionFailed;
                description = HPTErrorCodeHTTPConnectionFailedDescription;
                break;
                
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorBadURL:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            case NSURLErrorBackgroundSessionRequiresSharedContainer:
                code = HPTErrorCodeHTTPConfig;
                description = HPTErrorCodeHTTPConfigDescription;
                break;
        }
    }
    
    NSDictionary *userInfo = @{NSUnderlyingErrorKey: error, NSLocalizedDescriptionKey: description};
    
    return [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:code userInfo:userInfo];
}

@end
