//
//  HPTErrors.h
//  Pods
//
//  Created by Jonathan TIRET on 29/09/2015.
//
//

#ifndef HPTErrors_h
#define HPTErrors_h

NSString * const HPTHiPayTPPErrorDomain;
NSString * const HPTHTTPErrorOtherDescription;
NSString * const HPTHTTPErrorNetworkUnavailableDescription;
NSString * const HPTHTTPErrorConfigDescription;
NSString * const HPTHTTPErrorConnectionFailedDescription;
NSString * const HPTHTTPErrorClientDescription;
NSString * const HPTHTTPErrorServerDescription;

typedef NS_ENUM(NSInteger, HPTErrorCode) {

    // Unknown network/HTTP error
    HPTHTTPErrorOther,
    
    // Network is unavailable, the request did not reach the server
    HPTHTTPErrorNetworkUnavailable,
    
    // Config error (such as SSL, bad URL, etc.)
    HPTHTTPErrorConfig,
    
    // The connection has been interupted, the data possibly reached the server
    HPTHTTPErrorConnectionFailed,
    
    // HTTP client error (400)
    HPTHTTPErrorClient,

    // HTTP client error (typically a 500 error)
    HPTHTTPErrorServer,
    
};


#endif /* HPTErrors_h */
