//
//  HPFErrors.m
//  Pods
//
//  Created by Jonathan TIRET on 29/09/2015.
//
//

#import <Foundation/Foundation.h>

#import "HPFErrors.h"

NSString * _Nonnull const HPFHiPayFullserviceErrorDomain = @"HPFHiPayFullserviceErrorDomain";

NSString * _Nonnull const HPFErrorCodeHTTPOtherDescription = @"An unknown error occurred while attempting to make the HTTP request.";
NSString * _Nonnull const HPFErrorCodeHTTPNetworkUnavailableDescription = @"The network is unavailable.";
NSString * _Nonnull const HPFErrorCodeHTTPConfigDescription = @"There's a remote/local configuration error.";
NSString * _Nonnull const HPFErrorCodeHTTPConnectionFailedDescription = @"The request has been interrupted. The server may have received the request.";
NSString * _Nonnull const HPFErrorCodeHTTPClientDescription = @"Wrong parameters have been sent to the server.";
NSString * _Nonnull const HPFErrorCodeHTTPServerDescription = @"There's a server side error.";

NSString * _Nonnull const HPFErrorCodeHTTPPlainResponseKey = @"HPFErrorCodeHTTPPlainResponseKey";
NSString * _Nonnull const HPFErrorCodeHTTPParsedResponseKey = @"HPFErrorCodeHTTPParsedResponseKey";
NSString * _Nonnull const HPFErrorCodeHTTPStatusCodeKey = @"HPFErrorCodeHTTPStatusCodeKey";

NSString * _Nonnull const HPFErrorCodeAPIDescriptionKey = @"HPFErrorCodeAPIDescriptionKey";
NSString * _Nonnull const HPFErrorCodeAPIMessageKey = @"HPFErrorCodeAPIMessageKey";
NSString * _Nonnull const HPFErrorCodeAPICodeKey = @"HPFErrorCodeAPICodeKey";
