//
//  HPFWebViewForwardViewController.m
//  Pods
//
//  Created by Jonathan Tiret on 18/11/2015.
//
//

#import "HPFForwardWebViewViewController.h"
#import "HPFForwardViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFForwardWebViewViewController

#pragma mark - Init

- (instancetype)initWithTransaction:(HPFTransaction *)transaction
{
    self = [super initWithTransaction:transaction];
    if (self) {
        [self initializeComponentsWithURL:transaction.forwardUrl];
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPFHostedPaymentPage *)hostedPaymentPage
{
    self = [super initWithHostedPaymentPage:hostedPaymentPage];
    if (self) {
        [self initializeComponentsWithURL:hostedPaymentPage.forwardUrl];
    }
    return self;
}

- (void)initializeComponentsWithURL:(NSURL *)URL
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowOrChangedFrame:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidlHide) name:UIKeyboardDidHideNotification object:nil];
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
  
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:URL]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webViewController = [[UIViewController alloc] init];
    [webViewController.view addSubview:webView];
    webViewController.title = HPFLocalizedString(@"PAYMENT_SCREEN_TITLE");
    
    navigationViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    navigationViewController.delegate = self;
    
    [self addChildViewController:navigationViewController];
    [self.view addSubview:navigationViewController.view];
    
    [navigationViewController didMoveToParentViewController:self];
    
    webView.backgroundColor = [UIColor whiteColor];
    
    webViewController.automaticallyAdjustsScrollViewInsets = NO;
    
    [self defineConstraints];
    
    [self createNavigationButton];

    [self defineScrollViewIndicatorInsets];
}


- (void)defineConstraints
{
    webView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navigationViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:webViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:webViewController.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:webViewController.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [webViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:webViewController.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

}

- (void)createNavigationButton
{
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    
    webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doneButtonTouched:)];
    
    navigationViewController.toolbarHidden = NO;
    
    backButton = [[UIBarButtonItem alloc] initWithTitle:HPFLocalizedString(@"FORWARD_VIEW_BACK") style:UIBarButtonItemStylePlain target:self action:@selector(webViewBack)];
    backButton.enabled = NO;
    
    forwardButton = [[UIBarButtonItem alloc] initWithTitle:HPFLocalizedString(@"FORWARD_VIEW_FORWARD") style:UIBarButtonItemStylePlain target:self action:@selector(webViewForward)];
    forwardButton.enabled = NO;
    
    webViewController.toolbarItems = @[
                                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(webViewRefresh)],
                                       
                                       
                                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                       
                                       backButton,
                                       
                                       forwardButton,
                                       ];
}

#pragma mark - Content insets

- (void)keyboardDidShowOrChangedFrame:(NSNotification *)notification
{
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    keyboardShown = YES;
    [self defineScrollViewIndicatorInsets];
}

- (void)keyboardDidlHide
{
    keyboardShown = NO;
    [self defineScrollViewIndicatorInsets];
}

- (void)defineScrollViewIndicatorInsets
{
    CGFloat bottomInset = webViewController.bottomLayoutGuide.length;

    if (keyboardShown) {
        bottomInset = keyboardHeight;
    }
    
    webView.scrollView.contentInset = UIEdgeInsetsMake(webViewController.topLayoutGuide.length, 0.0, bottomInset, 0.0);
    webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self defineScrollViewIndicatorInsets];
}

#pragma mark - Controls

- (void)webViewBack
{
    [webView goBack];
}

- (void)webViewForward
{
    [webView goForward];
}

- (void)webViewRefresh
{
    [webView reload];
}

- (void)doneButtonTouched:(id)sender
{
    [self cancelBackgroundTransactionLoading];
    [self.delegate forwardViewControllerDidCancel:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureButtons
{
    backButton.enabled = webView.canGoBack;
    forwardButton.enabled = webView.canGoForward;
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [spinner startAnimating];
    [self configureButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [spinner stopAnimating];
    [self configureButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [spinner stopAnimating];
    [self configureButtons];
}

@end
