//
//  HPTViewController.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/18/2015.
//  Copyright (c) 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>

@interface HPTViewController ()

@end

@implementation HPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!firstTestDone) {
        [self test];
        firstTestDone = YES;
    }
}

- (void)test
{
    HPTPaymentPageRequest *order = [[HPTPaymentPageRequest alloc] init];
    
    order.amount = @(25.50);
    order.currency = @"EUR";
    order.orderId = [NSString stringWithFormat:@"TEST_SDK_IOS_%f", [NSDate date].timeIntervalSince1970];
    order.shortDescription = @"Une paire de chaussures";
    order.customer = [[HPTCustomerInfoRequest alloc] init];
    order.customer.email = [NSString stringWithFormat:@"jtiret+%f@hipay.com", [NSDate date].timeIntervalSince1970];
    order.customer.country = @"FR";
    
    
    
    NSURL *appURL = [NSURL URLWithString:@"hipaytpp://response"];
    
    order.acceptURL = order.declineURL = order.exceptionURL = order.pendingURL = order.cancelURL = appURL;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"PaymentScreen" bundle:bundle];
    HPTPaymentScreenViewController* vc = (HPTPaymentScreenViewController *)[sb instantiateInitialViewController];
    
    vc.delegate = self;
    
    
    [vc loadPaymentPageRequest:order];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)paymentScreenViewController:(HPTPaymentScreenViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction
{
    NSString *message = nil;
    
    switch (transaction.state) {
        case HPTTransactionStateCompleted:
            message = @"Transaction completed!";
            break;
        case HPTTransactionStatePending:
            message = @"Transaction pending…";
            break;
        case HPTTransactionStateError:
            message = @"Transaction in error";
            break;
        case HPTTransactionStateDeclined:
            message = @"Transaction declined!";
            break;
        case HPTTransactionStateForwarding:
            message = @"Transaction forwarding?!";
            break;
    }
    
    [[[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK, create a new transaction", nil] show];
}

- (void)paymentScreenViewController:(HPTPaymentScreenViewController *)viewController didFailWithError:(NSError *)error
{
    
    NSString *description;
    
    if (error.userInfo[HPTErrorCodeAPIMessageKey]) {
        description = error.userInfo[HPTErrorCodeAPIMessageKey];
    }
    
    else {
        description = error.localizedDescription;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"An error occurred" message:description delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK, create a new transaction", nil] show];
}

- (void)paymentScreenViewControllerDidCancel:(HPTPaymentScreenViewController *)viewController
{
    [[[UIAlertView alloc] initWithTitle:@"Cancel" message:@"User did cancel his transaction…" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK, create a new transaction", nil] show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(test) withObject:nil afterDelay:0.5];
}

@end
