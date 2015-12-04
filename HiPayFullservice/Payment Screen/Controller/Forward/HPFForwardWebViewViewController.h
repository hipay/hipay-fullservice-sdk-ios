//
//  HPFWebViewForwardViewController.h
//  Pods
//
//  Created by Jonathan Tiret on 18/11/2015.
//
//

#import "HPFForwardViewController.h"
#import <WebKit/WebKit.h>

@interface HPFForwardWebViewViewController : HPFForwardViewController <UIWebViewDelegate, UINavigationControllerDelegate>
{
    UIWebView *webView;
    UIActivityIndicatorView *spinner;
    
    UIViewController *webViewController;
    UINavigationController *navigationViewController;
    
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    
    BOOL keyboardShown;
    CGFloat keyboardHeight;
}

@end
