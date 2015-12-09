//
//  HPFClientConfig.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPFClientConfig.h"
#import "DevicePrint.h"

HPFClientConfig *HPFClientConfigSharedInstance = nil;

@implementation HPFClientConfig

+ (instancetype _Nonnull)sharedClientConfig
{
    if (HPFClientConfigSharedInstance == nil) {
        HPFClientConfigSharedInstance = [[self alloc] init];
    }
    
    return HPFClientConfigSharedInstance;
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

    _appRedirectionURL = [NSURL URLWithString:[[appURLscheme stringByAppendingString:@"://"] stringByAppendingString:HPFClientConfigCallbackURLHost]];
}

- (void)setEnvironment:(HPFEnvironment)environment username:(NSString *)username password:(NSString *)password appURLscheme:(NSString *)appURLscheme
{
    _environment = environment;
    _username = username;
    _password = password;
    
    [self setAppURLscheme:appURLscheme];
    
    id devicePrintClass = NSClassFromString(@"DevicePrint");
    
    if ([devicePrintClass respondsToSelector:@selector(start)]) {
        [(Class)devicePrintClass start];
    }
    
    [self performSelectorOnMainThread:@selector(determineUserAgent) withObject:nil waitUntilDone:YES];
}

- (void)determineUserAgent
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

@end
