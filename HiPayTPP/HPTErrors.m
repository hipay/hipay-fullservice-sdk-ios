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

NSString * const HPTHTTPErrorOtherDescription = @"An unknown error occurred while attempting to make the HTTP request.";
NSString * const HPTHTTPErrorNetworkUnavailableDescription = @"The network is unavailable, the request couldn't be sent.";
NSString * const HPTHTTPErrorConfigDescription = @"There's a remote/local configuration error.";
NSString * const HPTHTTPErrorConnectionFailedDescription = @"The request has been interrupted. The server may have received the request.";
NSString * const HPTHTTPErrorClientDescription = @"Wrong parameters have been sent to the server.";
NSString * const HPTHTTPErrorServerDescription = @"There's a server side error.";
