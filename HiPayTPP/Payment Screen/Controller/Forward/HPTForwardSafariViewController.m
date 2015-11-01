//
//  HPTForwardSafariViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTForwardSafariViewController.h"
#import "HPTGatewayClient.h"

@interface HPTForwardSafariViewController ()

@end

@implementation HPTForwardSafariViewController

- (instancetype)initWithTransaction:(HPTTransaction *)transaction
{
    self = [super initWithTransaction:transaction];
    if (self) {
        safariViewController = [[SFSafariViewController alloc] initWithURL:transaction.forwardUrl];
        safariViewController.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:safariViewController];
    [self.view addSubview:safariViewController.view];
    
    safariViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:safariViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:safariViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:safariViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:safariViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    spinner.color = [UIColor darkGrayColor];
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:spinner];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    [self.delegate forwardViewControllerDidCancel:self];
}

- (void)appDidBecomeActive:(NSNotification *)notification
{
    [UIView animateWithDuration:0.1 animations:^{
        safariViewController.view.alpha = 0.7;
    }];
    
    safariViewController.view.userInteractionEnabled = NO;
    
    [spinner startAnimating];
    
    [[HPTGatewayClient sharedClient] getTransactionWithReference:self.transaction.transactionReference withCompletionHandler:^(HPTTransaction *transaction, NSError *error) {
       
        safariViewController.view.userInteractionEnabled = YES;

        [UIView animateWithDuration:0.1 animations:^{
            safariViewController.view.alpha = 1.0;
        }];
        
        [spinner stopAnimating];
       
        if (transaction != nil) {
            if (transaction.state != HPTTransactionStateForwarding) {
                [self.delegate forwardViewController:self didEndWithTransaction:transaction];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            [self.delegate forwardViewController:self didFailWithError:error];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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