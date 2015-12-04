//
//  HPFClientConfig.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

#define HPFClientConfigCallbackURLHost @"hipay-tpp"

typedef NS_ENUM(NSInteger, HPFEnvironment) {
    
    HPFEnvironmentStage,
    HPFEnvironmentProduction,
    
};

@interface HPFClientConfig : NSObject

@property (nonatomic, readonly) HPFEnvironment environment;
@property (nonatomic, readonly, nullable) NSString *username;
@property (nonatomic, readonly, nullable) NSString *password;
@property (nonatomic, readonly, nullable) NSString *userAgent;
@property (nonatomic, readonly, nullable) NSURL *appRedirectionURL;

+ (instancetype _Nonnull)sharedClientConfig;

- (void)setEnvironment:(HPFEnvironment)environment username:( NSString * _Nonnull )username password:( NSString * _Nonnull )password appURLscheme:(NSString * _Nonnull)appURLscheme;

@end
