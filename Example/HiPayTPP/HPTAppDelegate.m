//
//  HPTAppDelegate.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/18/2015.
//  Copyright (c) 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTAppDelegate.h"
#import <HiPayTPP/HiPayTPP.h>
#import "HPTHTTPClient+Testing.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@implementation HPTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[HPTClientConfig sharedClientConfig] setEnvironment:HPTEnvironmentStage username:@"94654727.api.hipay-tpp.com" password:@"3g4zRCgG2EY9RJHFsQ4cIqAI"];

    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    BOOL isRunningTests = [[injectBundle pathExtension] isEqualToString:@"xctest"];
    
    
    if (!isRunningTests) {
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.absoluteString containsString:@"payment_products"] && [request.HTTPMethod isEqualToString:@"GET"];
        } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
            NSString *fixture = OHPathForFile(@"payment_products.json", self.class);
            OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            response.responseTime = 10.4;
            return response;
        }];
    }

    
//
//
//    HPTPaymentPageRequest *request = [[HPTPaymentPageRequest alloc] init];
//    request.amount = @(25.50);
//    request.currency = @"EUR";
//    request.orderId = @"SDK_IOS_TEST_ORDER_1234";
//    request.shortDescription = @"Une paire de chaussures";
//    request.paymentProductCategoryList = @[@"credit-card", @"debit-card", @"realtime-banking", @"ewallet"];
//    request.customer = [[HPTCustomerInfoRequest alloc] init];
//    request.customer.email = [NSString stringWithFormat:@"jtiret+%f@hipay.com", [NSDate date].timeIntervalSince1970];
//    
//    
//    [[HPTGatewayClient sharedClient] getPaymentProductsForRequest:request withCompletionHandler:^(NSArray *paymentProducts, NSError *error) {
//       
//        
//        
//        
//        
//    }];
//    
    
    
    //    [[HPTGatewayClient sharedClient] getTransactionsWithOrderId:@"SDK_TEST_MULTIPLE_TRANSAC" withCompletionHandler:^(NSArray *transactions, NSError *error) {
//       
//        
//        
//        
//        
//        
//    }];
//    
    
    
    
//    [[HPTSecureVaultClient sharedClient] generateTokenWithCardNumber:@"4111113333333333" cardExpiryMonth:@"12" cardExpiryYear:@"2018" cardHolder:@"John Simpson" securityCode:@"458" multiUse:YES andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
//       
//        
//        
//        HPTOrderRequest *order = [[HPTOrderRequest alloc] init];
//        order.amount = @(25.50);
//        order.currency = @"EUR";
////        order.orderId = [NSString stringWithFormat:@"TEST_SDK_IOS_%f", [NSDate date].timeIntervalSince1970];
//        order.orderId = @"SDK_TEST_MULTIPLE_TRANSAC";
//        order.shortDescription = @"Une paire de chaussures";
//        order.paymentProduct = @"cb";
//        order.customer = [[HPTCustomerInfoRequest alloc] init];
//        order.customer.email = [NSString stringWithFormat:@"jtiret+%f@hipay.com", [NSDate date].timeIntervalSince1970];
//        
//        order.paymentMethod = [HPTCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:cardToken.token eci:HPTECISecureECommerce authenticationIndicator:HPTAuthenticationIndicatorIfAvailable];
//        
//        [[HPTGatewayClient sharedClient] requestNewOrder:order withCompletionHandler:^(HPTTransaction *transaction, NSError *error) {
//            
//            
//            
//        }];
//        
//    }];
    
    
//    HPTHTTPClient *client = [[HPTHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/venues/search"] login:@"" password:@""];
//    
//    [client performRequestWithMethod:HPTHTTPMethodGet path:@"" parameters:nil completionHandler:^(HPTHTTPResponse *response, NSError *error) {
//        
//    }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
