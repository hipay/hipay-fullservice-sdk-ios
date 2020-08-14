//
//  HPFHTTP.h
//  Pods
//
//  Created by HiPay on 21/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFHTTPResponse.h"
#import "HPFRequest.h"

typedef void (^HPFHTTPClientCompletionBlock)( HPFHTTPResponse  * _Nullable response, NSError *_Nullable error);

extern NSString * _Nonnull const HPFGatewayClientSignature;

typedef NS_ENUM(NSInteger, HPFHTTPMethod) {
    HPFHTTPMethodGet,
    HPFHTTPMethodPost
};

@interface HPFHTTPClientRequest : NSObject <HPFRequest>

@property (nonatomic, readonly) NSURLSessionTask  * _Nonnull URLSessionTask;

- (instancetype _Nonnull)initWithURLSessionTask:(NSURLSessionTask * _Nonnull )URLSessionTask;

@end

@interface HPFHTTPClient : NSObject
{
    @private
    NSString *username;
    NSString *password;
    NSString *usernameApplePay;
}

@property (nonatomic) NSURL  * _Nonnull baseURL;
@property (nonatomic) NSURL  * _Nonnull baseURLv2;

- (instancetype _Nonnull)initWithBaseURL:( NSURL * _Nonnull )URL username:(NSString * _Nonnull)theUsername password:(NSString * _Nonnull)thePassword;
- (instancetype _Nonnull)initWithBaseURL:(NSURL * _Nonnull)URL newBaseURL:(NSURL * _Nonnull)newURL username:(NSString * _Nonnull)theUsername password:(NSString * _Nonnull)thePassword;
- (instancetype _Nonnull)initWithBaseURL:(NSURL * _Nonnull)URL newBaseURL:(NSURL * _Nonnull)newURL username:(NSString * _Nonnull)theUsername password:(NSString * _Nonnull)thePassword usernameApplePay:(NSString * _Nullable)theUsernameApplePay;

- (HPFHTTPClientRequest  * _Nonnull )performRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 path:(NSString * _Nonnull)path parameters:(NSDictionary * _Nonnull)parameters completionHandler:(HPFHTTPClientCompletionBlock _Nonnull)completionBlock;
- (HPFHTTPClientRequest  * _Nonnull )performRequestWithMethod:(HPFHTTPMethod)method v2:(BOOL)isV2 isApplePay:(BOOL)isApplePay path:(NSString * _Nonnull)path parameters:(NSDictionary * _Nonnull)parameters completionHandler:(HPFHTTPClientCompletionBlock _Nonnull)completionBlock;

@end
