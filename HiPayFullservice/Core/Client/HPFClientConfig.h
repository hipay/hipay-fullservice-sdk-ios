//
//  HPFClientConfig.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

#define HPFClientConfigCallbackURLHost @"hipay-fullservice"

/**
 *  This enum lists the different HiPay Fullservice environements you can rely on when using this SDK.
 */
typedef NS_ENUM(NSInteger, HPFEnvironment) {

    /**
     *  The Stage environement, when you are testing your integration.
     */
    HPFEnvironmentStage,
    
    /**
     *  The Production environement, for when you have finished testing and want your application to go live.
     */
    HPFEnvironmentProduction,
};

/**
 *  Describes the general configuration to be used be the SDK (username, password, environement, etc.).
 *  The different software components of the SDK that need to perform requests against the HiPay Fullservice platform will rely on this class to get a proper configruation.
 */
@interface HPFClientConfig : NSObject

/**
 *  The environement to be used.
 */
@property (nonatomic, readonly) HPFEnvironment environment;

/**
 * The API username.
 * Your API credentials can be found in the Merchant Interface in the Integration section.
 */
@property (nonatomic, readonly, nullable) NSString *username;

/**
 * The API password.
 * Your API credentials can be found in the Merchant Interface in the Integration section.
 */
@property (nonatomic, readonly, nullable) NSString *password;

/**
 *  The user agent that will be sent alongside HTTP requests.
 */
@property (nonatomic, readonly, nullable) NSString *userAgent;

/**
 *  The full app redirection URL (generated automatically).
 */
@property (nonatomic, readonly, nullable) NSURL *appRedirectionURL;

+ (instancetype _Nonnull)sharedClientConfig;

- (void)setEnvironment:(HPFEnvironment)environment username:( NSString * _Nonnull )username password:( NSString * _Nonnull )password appURLscheme:(NSString * _Nonnull)appURLscheme;

@end
