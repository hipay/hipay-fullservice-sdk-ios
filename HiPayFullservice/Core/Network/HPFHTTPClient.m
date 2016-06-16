//
//  HPFHTTP.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPFHTTPClient.h"
#import "HPFErrors.h"
#import "HPFLogger.h"

@implementation HPFHTTPClientRequest

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

@implementation HPFHTTPClient

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

- (NSURLRequest *)createURLRequestWithMethod:(HPFHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] init];
    NSString *baseURLAndPath = [NSString stringWithFormat:@"%@%@", self.baseURL, path];
    
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [URLRequest setValue:[self createAuthHeader] forHTTPHeaderField:@"Authorization"];
    
    switch (method) {
        case HPFHTTPMethodGet:
            URLRequest.HTTPMethod = @"GET";
            
            if (parameters != nil) {
                NSString *URL = [NSString stringWithFormat:@"%@?%@", baseURLAndPath, [self queryStringForDictionary:parameters]];
                
                URLRequest.URL = [NSURL URLWithString:URL];
            } else {
                URLRequest.URL = [NSURL URLWithString:baseURLAndPath];
            }
            
            break;
            
        case HPFHTTPMethodPost:
            URLRequest.HTTPMethod = @"POST";
            URLRequest.URL = [NSURL URLWithString:baseURLAndPath];
            
            URLRequest.HTTPBody = [[self queryStringForDictionary:parameters] dataUsingEncoding:NSUTF8StringEncoding];
            
            break;
    }
    
    return URLRequest;
}

- (HPFHTTPClientRequest *)performRequestWithMethod:(HPFHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPFHTTPClientCompletionBlock)completionBlock
{
    static dispatch_once_t onceBlock;
    static NSMutableArray *requests;

    dispatch_once (&onceBlock, ^{
        requests = [NSMutableArray array];
    });
    
    NSURLRequest *request = [self createURLRequestWithMethod:method path:path parameters:parameters];
    
    [requests addObject:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[HPFLogger sharedLogger] debug:@"<HTTP>: Performs %@ %@", request.HTTPMethod, path];
    
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
        // Network activity
        [requests removeObject:request];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = (requests.count > 0);
        
        // Request cancelled, no callback
        if ((error == nil) || ![error.domain isEqualToString:NSURLErrorDomain] || (error.code != NSURLErrorCancelled)) {
            
            // Connection error
            if (error != nil) {
                completionBlock(nil, [self errorFromURLConnectionError:error]);
            }
            
            else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                
                NSError *JSONError = nil;
                
                id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
                
                if (JSONError == nil) {
                    HPFHTTPResponse *clientResponse = [[HPFHTTPResponse alloc] initWithStatusCode:[(NSHTTPURLResponse *)response statusCode] body:body];
                    
                    NSError *responseError = nil;
                    
                    if (NSLocationInRange(clientResponse.statusCode, (NSRange){400, 100})) {
                        responseError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{NSLocalizedDescriptionKey: HPFErrorCodeHTTPClientDescription, HPFErrorCodeHTTPStatusCodeKey: @(clientResponse.statusCode)}];
                    }
                    
                    else if (NSLocationInRange(clientResponse.statusCode, (NSRange){500, 100})) {
                        responseError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPServer userInfo:@{NSLocalizedDescriptionKey: HPFErrorCodeHTTPServerDescription, HPFErrorCodeHTTPStatusCodeKey: @(clientResponse.statusCode)}];
                    }
                    
                    completionBlock(clientResponse, responseError);
                }
                
                // Content not parsable, server error
                else {
                    completionBlock(nil, [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPServer userInfo:@{NSUnderlyingErrorKey: JSONError, NSLocalizedDescriptionKey: HPFErrorCodeHTTPServerDescription, HPFErrorCodeHTTPPlainResponseKey: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], HPFErrorCodeHTTPStatusCodeKey: @([(NSHTTPURLResponse *)response statusCode])}]);
                }
            }
            
            else {
                completionBlock(nil, [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPOther userInfo:@{NSLocalizedDescriptionKey: HPFErrorCodeHTTPOtherDescription}]);
            }
        }
        
    }];
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] initWithURLSessionTask:sessionDataTask];
    
    [sessionDataTask resume];
    
    return clientRequest;
}

- (NSError *)errorFromURLConnectionError:(NSError *)error
{
    NSInteger code = HPFErrorCodeHTTPOther;
    NSString *description = HPFErrorCodeHTTPOtherDescription;
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorInternationalRoamingOff:
            case NSURLErrorCallIsActive:
            case NSURLErrorDataNotAllowed:
                code = HPFErrorCodeHTTPNetworkUnavailable;
                description = HPFErrorCodeHTTPNetworkUnavailableDescription;
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
                code = HPFErrorCodeHTTPConnectionFailed;
                description = HPFErrorCodeHTTPConnectionFailedDescription;
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
                code = HPFErrorCodeHTTPConfig;
                description = HPFErrorCodeHTTPConfigDescription;
                break;
        }
    }
    
    NSDictionary *userInfo = @{NSUnderlyingErrorKey: error, NSLocalizedDescriptionKey: description};
    
    return [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:code userInfo:userInfo];
}

@end
