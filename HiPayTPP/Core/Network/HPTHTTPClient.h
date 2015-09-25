//
//  HPTHTTP.h
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTHTTPResponse.h"

typedef void (^HPTHTTPClientCompletionBlock)(HPTHTTPResponse *response, NSError *error);

typedef NS_ENUM(NSInteger, HPTHTTPMethod) {
    HPTHTTPMethodGet,
    HPTHTTPMethodPost,
    HPTHTTPMethodPut,
    HPTHTTPMethodDelete
};

@interface HPTHTTPClient : NSObject
{
    @private
    NSString *login;
    NSString *password;
}

@property (nonatomic) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)URL login:(NSString *)login password:(NSString *)password;

@end
