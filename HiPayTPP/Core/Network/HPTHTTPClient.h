//
//  HPTHTTP.h
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTHTTPResponse.h"
#import "HPTRequest.h"

typedef void (^HPTHTTPClientCompletionBlock)(HPTHTTPResponse *response, NSError *error);

typedef NS_ENUM(NSInteger, HPTHTTPMethod) {
    HPTHTTPMethodGet,
    HPTHTTPMethodPost
};

@interface HPTHTTPClientRequest : NSObject <HPTRequest>

@property (nonatomic, readonly) NSURLSessionTask *URLSessionTask;

- (instancetype)initWithURLSessionTask:(NSURLSessionTask *)URLSessionTask;

@end

@interface HPTHTTPClient : NSObject
{
    @private
    NSString *username;
    NSString *password;
}

@property (nonatomic) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)URL username:(NSString *)theUsername password:(NSString *)password;
- (HPTHTTPClientRequest *)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPTHTTPClientCompletionBlock)completionBlock;

@end
