//
//  HPFHTTP.h
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFHTTPResponse.h"
#import "HPFRequest.h"

typedef void (^HPFHTTPClientCompletionBlock)(HPFHTTPResponse *response, NSError *error);

typedef NS_ENUM(NSInteger, HPFHTTPMethod) {
    HPFHTTPMethodGet,
    HPFHTTPMethodPost
};

@interface HPFHTTPClientRequest : NSObject <HPFRequest>

@property (nonatomic, readonly) NSURLSessionTask *URLSessionTask;

- (instancetype)initWithURLSessionTask:(NSURLSessionTask *)URLSessionTask;

@end

@interface HPFHTTPClient : NSObject
{
    @private
    NSString *username;
    NSString *password;
}

@property (nonatomic) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)URL username:(NSString *)theUsername password:(NSString *)password;

- (HPFHTTPClientRequest *)performRequestWithMethod:(HPFHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPFHTTPClientCompletionBlock)completionBlock;

@end
