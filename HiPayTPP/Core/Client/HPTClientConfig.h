//
//  HPTClientConfig.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTEnvironment) {
    
    HPTEnvironmentStage,
    HPTEnvironmentProduction,
    
};

@interface HPTClientConfig : NSObject

@property (nonatomic, readonly) HPTEnvironment environment;
@property (nonatomic, readonly, nullable) NSString *username;
@property (nonatomic, readonly, nullable) NSString *password;
@property (nonatomic, readonly, nullable) NSURL *appRedirectionURL;

+ (instancetype _Nonnull)sharedClientConfig;

- (void)setEnvironment:(HPTEnvironment)environment username:( NSString * _Nonnull )username password:( NSString * _Nonnull )password appURLscheme:(NSString * _Nonnull)appURLscheme;

@end
