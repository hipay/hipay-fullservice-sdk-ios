//
//  HPTPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPTPaymentScreenViewController.h"
#import "HPTPaymentScreenMainViewController.h"

@interface HPTPaymentScreenViewController ()

@end

@implementation HPTPaymentScreenViewController

- (void)loadPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest
{
    _paymentPageRequest = paymentPageRequest;
    
    HPTPaymentScreenMainViewController *mainViewController = self.viewControllers.firstObject;
    
    mainViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPayment)];
    
    [[HPTGatewayClient sharedClient] getPaymentProductsForRequest:paymentPageRequest withCompletionHandler:^(NSArray *paymentProducts, NSError *error) {
        
        mainViewController.paymentPageRequest = paymentPageRequest;
        mainViewController.paymentProducts = paymentProducts;
        
    }];
}

- (void)cancelPayment
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
