//
//  HPTErrors.m
//  Pods
//
//  Created by Jonathan TIRET on 29/09/2015.
//
//

#import <Foundation/Foundation.h>

#import "HPTErrors.h"

NSString * const HPTHiPayTPPErrorDomain = @"HPTHiPayTPPErrorDomain";

NSString * const HPTErrorCodeHTTPOtherDescription = @"An unknown error occurred while attempting to make the HTTP request.";
NSString * const HPTErrorCodeHTTPNetworkUnavailableDescription = @"The network is unavailable.";
NSString * const HPTErrorCodeHTTPConfigDescription = @"There's a remote/local configuration error.";
NSString * const HPTErrorCodeHTTPConnectionFailedDescription = @"The request has been interrupted. The server may have received the request.";
NSString * const HPTErrorCodeHTTPClientDescription = @"Wrong parameters have been sent to the server.";
NSString * const HPTErrorCodeHTTPServerDescription = @"There's a server side error.";

NSString * const HPTErrorCodeHTTPPlainResponseKey = @"HPTErrorCodeHTTPPlainResponseKey";
NSString * const HPTErrorCodeHTTPParsedResponseKey = @"HPTErrorCodeHTTPParsedResponseKey";
NSString * const HPTErrorCodeHTTPStatusCodeKey = @"HPTErrorCodeHTTPStatusCodeKey";

NSString * const HPTErrorCodeAPIDescriptionKey = @"HPTErrorCodeAPIDescriptionKey";
NSString * const HPTErrorCodeAPIMessageKey = @"HPTErrorCodeAPIMessageKey";
NSString * const HPTErrorCodeAPICodeKey = @"HPTErrorCodeAPICodeKey";
