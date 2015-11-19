//
//  HPTWebViewForwardViewController.h
//  Pods
//
//  Created by Jonathan Tiret on 18/11/2015.
//
//

#import "HPTForwardViewController.h"
#import <WebKit/WebKit.h>

@interface HPTForwardWebViewViewController : HPTForwardViewController <WKNavigationDelegate>
{
    WKWebView *webView;
    UIActivityIndicatorView *spinner;
    
    UIViewController *webViewController;
    UINavigationController *navigationViewController;
}

@end
