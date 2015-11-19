//
//  HPTWebViewForwardViewController.m
//  Pods
//
//  Created by Jonathan Tiret on 18/11/2015.
//
//

#import "HPTForwardWebViewViewController.h"
#import "HPTForwardViewController_Protected.h"

@implementation HPTForwardWebViewViewController

- (instancetype)initWithTransaction:(HPTTransaction *)transaction
{
    self = [super initWithTransaction:transaction];
    if (self) {
        [self initializeComponentsWithURL:transaction.forwardUrl];
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPTHostedPaymentPage *)hostedPaymentPage
{
    self = [super initWithHostedPaymentPage:hostedPaymentPage];
    if (self) {
        [self initializeComponentsWithURL:hostedPaymentPage.forwardUrl];
    }
    return self;
}

- (void)initializeComponentsWithURL:(NSURL *)URL
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    webView.navigationDelegate = self;
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:URL]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    webViewController = [[UIViewController alloc] init];
    [webViewController.view addSubview:webView];
    webViewController.title = @"Redirection";
    
    navigationViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    
    [self addChildViewController:navigationViewController];
    [self.view addSubview:navigationViewController.view];
    
    webViewController.view.backgroundColor = [UIColor yellowColor];
    
    [navigationViewController didMoveToParentViewController:self];
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    
    webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:webViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];

    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:webViewController.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:webViewController.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:webViewController.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [spinner stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [spinner stopAnimating];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [spinner startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [spinner stopAnimating];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    
}

//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
//{
//    [self cancelBackgroundTransactionLoading];
//    [self.delegate forwardViewControllerDidCancel:self];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
