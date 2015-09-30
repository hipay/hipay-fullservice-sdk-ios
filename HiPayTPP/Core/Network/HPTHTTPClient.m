//
//  HPTHTTP.m
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import "HPTHTTPClient.h"
#import "HPTErrors.h"

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
                
                if (clientResponse.statusCode == 400) {
                    responseError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTHTTPErrorClient userInfo:@{NSLocalizedFailureReasonErrorKey: HPTHTTPErrorClientDescription}];
                }
                
                else if (clientResponse.statusCode == 500) {
                    responseError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTHTTPErrorServer userInfo:@{NSLocalizedFailureReasonErrorKey: HPTHTTPErrorServerDescription}];
                }
                
                completionBlock(clientResponse, responseError);
            }
            
            // Content not parsable, server error
            else {
                completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTHTTPErrorServer userInfo:@{NSUnderlyingErrorKey: JSONError, NSLocalizedFailureReasonErrorKey: HPTHTTPErrorServerDescription}]);
            }
        }
        
        else {
            completionBlock(nil, [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTHTTPErrorOther userInfo:@{NSLocalizedFailureReasonErrorKey: HPTHTTPErrorOtherDescription}]);
        }
        
    }];
    
    [sessionDataTask resume];
}

- (NSError *)errorFromURLConnectionError:(NSError *)error
{
    NSInteger code = HPTHTTPErrorOther;
    NSString *description = HPTHTTPErrorOtherDescription;
    
    if (error.domain == NSURLErrorDomain) {
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorInternationalRoamingOff:
            case NSURLErrorCallIsActive:
            case NSURLErrorDataNotAllowed:
                code = HPTHTTPErrorNetworkUnavailable;
                description = HPTHTTPErrorNetworkUnavailableDescription;
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
                code = HPTHTTPErrorConnectionFailed;
                description = HPTHTTPErrorConnectionFailedDescription;
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
                code = HPTHTTPErrorConfig;
                description = HPTHTTPErrorConfigDescription;
                break;
        }
    }
    
    NSDictionary *userInfo = @{NSUnderlyingErrorKey: error, NSLocalizedFailureReasonErrorKey: description};
    
    return [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:code userInfo:userInfo];
}

@end
