//
//  HPTHTTP.h
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTHTTPMethod) {
    HPTHTTPMethodGet,
    HPTHTTPMethodPost,
    HPTHTTPMethodPut,
    HPTHTTPMethodDelete
};

@interface HPTHTTP : NSObject
{
    @private
    NSString *login;
    NSString *password;
}

@property (nonatomic) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)URL login:(NSString *)login password:(NSString *)password;

- (void)performRequestWithMethod:(HPTHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters;

@end
