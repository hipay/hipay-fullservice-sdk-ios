//
//  HPFErrors.m
//  Pods
//
//  Created by Jonathan TIRET on 29/09/2015.
//
//

#import <Foundation/Foundation.h>

#import "HPFErrors.h"

NSString * const HPFHiPayTPPErrorDomain = @"HPFHiPayTPPErrorDomain";

NSString * const HPFErrorCodeHTTPOtherDescription = @"An unknown error occurred while attempting to make the HTTP request.";
NSString * const HPFErrorCodeHTTPNetworkUnavailableDescription = @"The network is unavailable.";
NSString * const HPFErrorCodeHTTPConfigDescription = @"There's a remote/local configuration error.";
NSString * const HPFErrorCodeHTTPConnectionFailedDescription = @"The request has been interrupted. The server may have received the request.";
NSString * const HPFErrorCodeHTTPClientDescription = @"Wrong parameters have been sent to the server.";
NSString * const HPFErrorCodeHTTPServerDescription = @"There's a server side error.";

NSString * const HPFErrorCodeHTTPPlainResponseKey = @"HPFErrorCodeHTTPPlainResponseKey";
NSString * const HPFErrorCodeHTTPParsedResponseKey = @"HPFErrorCodeHTTPParsedResponseKey";
NSString * const HPFErrorCodeHTTPStatusCodeKey = @"HPFErrorCodeHTTPStatusCodeKey";

NSString * const HPFErrorCodeAPIDescriptionKey = @"HPFErrorCodeAPIDescriptionKey";
NSString * const HPFErrorCodeAPIMessageKey = @"HPFErrorCodeAPIMessageKey";
NSString * const HPFErrorCodeAPICodeKey = @"HPFErrorCodeAPICodeKey";
