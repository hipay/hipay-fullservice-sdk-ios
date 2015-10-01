//
//  HPTClientConfig.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTClientConfig.h"

HPTClientConfig *HPTClientConfigSharedInstace = nil;

@implementation HPTClientConfig

+ (instancetype _Nonnull)sharedClientConfig
{
    if (HPTClientConfigSharedInstace == nil) {
        HPTClientConfigSharedInstace = [[self alloc] init];
    }
    
    return HPTClientConfigSharedInstace;
}

- (void)setEnvironment:(HPTEnvironment)environment username:(NSString *)username password:(NSString *)password
{
    _environment = environment;
    _username = username;
    _password = password;
}

@end
