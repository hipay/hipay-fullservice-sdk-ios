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

typedef NS_ENUM(NSInteger, HPTErrorCode) {

    // Unknown network/HTTP error
    HPTHTTPErrorOther,
    
    // Network is unavailable, the request did not reach the server
    HPTHTTPErrorNetworkUnavailable,
    
    // The connection has been interupted, the data possibly reached the server
    HPTHTTPErrorConnectionFailed,
    
    // HTTP client error (400)
    HPTHTTPErrorClient,

    // HTTP client error (500)
    HPTHTTPErrorServer,
};


#endif /* HPTErrors_h */
