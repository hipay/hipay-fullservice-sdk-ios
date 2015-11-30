//
//  HPTClientConfig.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPTClientConfig.h"

HPTClientConfig *HPTClientConfigSharedInstance = nil;

@implementation HPTClientConfig

+ (instancetype _Nonnull)sharedClientConfig
{
    if (HPTClientConfigSharedInstance == nil) {
        HPTClientConfigSharedInstance = [[self alloc] init];
    }
    
    return HPTClientConfigSharedInstance;
}

- (void)setAppURLscheme:(NSString *)appURLscheme
{
    if (appURLscheme == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The URL scheme must not be nil." userInfo:nil];
    }
    
    NSCharacterSet* nonAlphaSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSRange range = [appURLscheme rangeOfCharacterFromSet:nonAlphaSet];
    
    if (range.location != NSNotFound) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The URL scheme should only contain letters. Argument passed: %@", appURLscheme] userInfo:nil];
    }

    _appRedirectionURL = [NSURL URLWithString:[[appURLscheme stringByAppendingString:@"://"] stringByAppendingString:HPTClientConfigCallbackURLHost]];
}

- (void)setEnvironment:(HPTEnvironment)environment username:(NSString *)username password:(NSString *)password appURLscheme:(NSString *)appURLscheme
{
    _environment = environment;
    _username = username;
    _password = password;
    
    [self setAppURLscheme:appURLscheme];
}

@end
