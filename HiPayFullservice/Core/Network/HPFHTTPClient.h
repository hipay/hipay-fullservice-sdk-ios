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
@property (nonatomic) NSURL *baseURLv2;

- (instancetype)initWithBaseURL:(NSURL *)URL username:(NSString *)theUsername password:(NSString *)thePassword;
- (instancetype)initWithBaseURL:(NSURL *)URL newBaseURL:(NSURL *)newURL username:(NSString *)theUsername password:(NSString *)thePassword;

- (HPFHTTPClientRequest *)performRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 path:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HPFHTTPClientCompletionBlock)completionBlock;

@end
