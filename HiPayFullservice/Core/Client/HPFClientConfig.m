//
//  HPFClientConfig.m
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import "HPFClientConfig.h"
#import "DevicePrint.h"

@implementation HPFClientConfig

+ (instancetype)sharedClientConfig
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.paymentCardStorageEnabled = YES;
    }
    return self;
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

    BOOL foundURLScheme = NO;
    NSArray *types = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    
    if (types.count > 0) {
        for (NSDictionary *type in types) {
            foundURLScheme = [type[@"CFBundleURLSchemes"] containsObject:appURLscheme];
        }
    }
    
    // Raises an exception because the developer needs to know very early in the development cycle that there's an error.
    
    if (!foundURLScheme) {
        NSString *exceptionMessage = [NSString stringWithFormat:@"The URL scheme \"%@\" seems not to exist. Check your configuration in your project settings > Info > URL Types and provide the HiPay Fullservice SDK with a valid URL scheme.", appURLscheme];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:exceptionMessage userInfo:nil];
    }
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
