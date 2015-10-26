//
//  HPTViewController.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/18/2015.
//  Copyright (c) 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTViewController.h"
#import <WebKit/WebKit.h>
#import <HiPayTPP/HiPayTPP.h>
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
//    SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.google.fr"]];

    

    
    
            HPTPaymentPageRequest *order = [[HPTPaymentPageRequest alloc] init];
            order.amount = @(25.50);
            order.currency = @"EUR";
            order.orderId = [NSString stringWithFormat:@"TEST_SDK_IOS_%f", [NSDate date].timeIntervalSince1970];

            order.shortDescription = @"Une paire de chaussures";

            order.customer = [[HPTCustomerInfoRequest alloc] init];
            order.customer.email = [NSString stringWithFormat:@"jtiret+%f@hipay.com", [NSDate date].timeIntervalSince1970];
    

    
    [self presentViewController:[[HPTPaymentScreenViewController alloc] init] animated:YES completion:nil];
    
    
//            [[HPTGatewayClient sharedClient] initializeHostedPaymentPageRequest:order withCompletionHandler:^(HPTHostedPaymentPage *hostedPaymentPage, NSError *error) {
//
//                [self presentViewController:[[SFSafariViewController alloc] initWithURL:hostedPaymentPage.forwardUrl] animated:YES completion:nil];
    
//                
//                WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
//                [webView loadRequest:[NSURLRequest requestWithURL:hostedPaymentPage.forwardUrl]];
//                
//                [self.view addSubview:webView];

                
//            }];
    
}

@end
