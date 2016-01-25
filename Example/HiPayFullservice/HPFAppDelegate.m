//
//  HPFAppDelegate.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 09/18/2015.
//  Copyright (c) 2015 Jonathan TIRET. All rights reserved.
//

#import "HPFAppDelegate.h"
#import <HiPayFullservice/HiPayFullservice.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <HockeySDK/HockeySDK.h>

@implementation HPFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[HPFClientConfig sharedClientConfig] setEnvironment:HPFEnvironmentStage username:@"94654679.api.hipay-tpp.com" password:@"U5hQh4ZT0UyXpYhG8WI4trYQ" appURLscheme:@"hipayexample"];

    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"d09352639450402a83aa07b7b3d3e3fb"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    BOOL isRunningTests = [[injectBundle pathExtension] isEqualToString:@"xctest"];
    
    /*
     All the code below is meant to be deleted.
     */
    
    NSArray *paymentProductsResponse = @[
                                         @{
                                             @"id":@"52DY02WM",
                                             @"code":@"visa",
                                             @"description":@"VISA",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"GUQ4NAIJ",
                                             @"code":@"mastercard",
                                             @"description":@"MasterCard",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"F7PQ8VAI",
                                             @"code":@"cb",
                                             @"description":@"Carte Bancaire",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"MRU9TJFH",
                                             @"code":@"american-express",
                                             @"description":@"American Express",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"JRTEL7NY",
                                             @"code":@"diners",
                                             @"description":@"Diners Club International",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"0J9LFS1O",
                                             @"code":@"bcmc",
                                             @"description":@"Bancontact / Mister Cash",
                                             @"paymentProductCategoryCode":@"debit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"0J9LFS11",
                                             @"code":@"bcmc-mobile",
                                             @"description":@"Bancontact Mobile",
                                             @"paymentProductCategoryCode":@"ewallet",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"339KCZTQ",
                                             @"code":@"maestro",
                                             @"description":@"Maestro",
                                             @"paymentProductCategoryCode":@"debit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"LQ09C87Y",
                                             @"code":@"carte-accord",
                                             @"description":@"Carte Accord",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@YES
                                             },
                                         @{
                                             @"id":@"ICOD9CQU",
                                             @"code":@"sofort-uberweisung",
                                             @"description":@"Sofort Ãœberweisung",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"C6RXY2KR",
                                             @"code":@"ing-homepay",
                                             @"description":@"ING Home'Pay",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"XZWIGL27",
                                             @"code":@"ideal",
                                             @"description":@"iDEAL",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"HY0ORGG3",
                                             @"code":@"paypal",
                                             @"description":@"PayPal",
                                             @"paymentProductCategoryCode":@"ewallet",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"OR39Z05G",
                                             @"code":@"giropay",
                                             @"description":@"Giropay",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"56WDGA6Y",
                                             @"code":@"sdd",
                                             @"description":@"SEPA Direct Debit",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"EM5VTJII",
                                             @"code":@"bank-transfer",
                                             @"description":@"Transfer from bank account to bank account",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"KYYI3FSH",
                                             @"code":@"payulatam",
                                             @"description":@"PayULatam wallet",
                                             @"paymentProductCategoryCode":@"ewallet",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"TTB0Y3DE",
                                             @"code":@"paysafecard",
                                             @"description":@"PaysafeCard",
                                             @"paymentProductCategoryCode":@"prepaid-card",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"FZEWWCY0",
                                             @"code":@"sisal",
                                             @"description":@"Sisal",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"SJEYVCOE",
                                             @"code":@"przelewy24",
                                             @"description":@"Przelewy24",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"RAXLNESP",
                                             @"code":@"qiwi-wallet",
                                             @"description":@"VISA QIWI Wallet",
                                             @"paymentProductCategoryCode":@"ewallet",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"BLMQ0VNG",
                                             @"code":@"3xcb",
                                             @"description":@"3x Carte Bancaire",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"GSI0TKIH",
                                             @"code":@"4xcb-no-fees",
                                             @"description":@"4x Carte Bancaire sans frais",
                                             @"paymentProductCategoryCode":@"credit-card",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"72L8SV1M",
                                             @"code":@"yandex",
                                             @"description":@"Yandex",
                                             @"paymentProductCategoryCode":@"ewallet",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"72L8SV1M",
                                             @"code":@"postfinance",
                                             @"description":@"Postfinance",
                                             @"paymentProductCategoryCode":@"debit-card",
                                             @"tokenizable":@NO
                                             },
                                         @{
                                             @"id":@"LKA7QX4W",
                                             @"code":@"dcb-at-a1",
                                             @"description":@"Dimoco A1",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             },   
                                         @{
                                             @"id":@"LKA7QX4W",
                                             @"code":@"dcb-at-tmobile",
                                             @"description":@"Dimoco TMobile",
                                             @"paymentProductCategoryCode":@"realtime-banking",
                                             @"tokenizable":@NO
                                             }
                                         ];
    
    if (!isRunningTests) {
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.absoluteString containsString:@"payment_products"] && [request.HTTPMethod isEqualToString:@"GET"];
        } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
            
            NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:NO];
            NSMutableArray *currentResponse = [NSMutableArray arrayWithArray:paymentProductsResponse];
            
            for (NSURLQueryItem *item in URLComponents.queryItems) {
                
                // Payment product categories
                if ([item.name isEqual:@"payment_product_category_list"]) {
                    NSArray *productCategories = [item.value componentsSeparatedByString:@","];
                    
                    if (![item.value isEqualToString:@""]) {
                        NSIndexSet *indexes = [currentResponse indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return ![productCategories containsObject:[obj objectForKey:@"paymentProductCategoryCode"]];
                        }];
                        
                        [currentResponse removeObjectsAtIndexes:indexes];
                    }
                }
                
                else if ([item.name isEqual:@"currency"]) {
                    
                    if (![item.value isEqual:@"USD"]) {
                        NSIndexSet *indexes =[currentResponse indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return [[obj objectForKey:@"code"] isEqualToString:@"payulatam"];
                        }];
                        
                        [currentResponse removeObjectsAtIndexes:indexes];
                    }
                    
                    if (![item.value isEqual:@"PLN"]) {
                        NSIndexSet *indexes =[currentResponse indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return [[obj objectForKey:@"code"] isEqualToString:@"przelewy24"];
                        }];
                        
                        [currentResponse removeObjectsAtIndexes:indexes];
                    }
                    
                    if (![item.value isEqual:@"RUB"]) {
                        NSIndexSet *indexes =[currentResponse indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return [[obj objectForKey:@"code"] isEqualToString:@"qiwi-wallet"] || [[obj objectForKey:@"code"] isEqualToString:@"yandex"];
                        }];
                        
                        [currentResponse removeObjectsAtIndexes:indexes];
                    }
                    
                    if (![item.value isEqual:@"EUR"]) {
                        NSIndexSet *indexes =[currentResponse indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return [[obj objectForKey:@"code"] isEqualToString:@"visa"] || [[obj objectForKey:@"code"] isEqualToString:@"mastercard"] || [[obj objectForKey:@"code"] isEqualToString:@"cb"] || [[obj objectForKey:@"code"] isEqualToString:@"american-express"] || [[obj objectForKey:@"code"] isEqualToString:@"diners"] || [[obj objectForKey:@"code"] isEqualToString:@"bcmc"] || [[obj objectForKey:@"code"] isEqualToString:@"bcmc-mobile"] || [[obj objectForKey:@"code"] isEqualToString:@"maestro"] || [[obj objectForKey:@"code"] isEqualToString:@"carte-accord"] || [[obj objectForKey:@"code"] isEqualToString:@"sofort-uberweisung"] || [[obj objectForKey:@"code"] isEqualToString:@"ing-homepay"] || [[obj objectForKey:@"code"] isEqualToString:@"ideal"] || [[obj objectForKey:@"code"] isEqualToString:@"paypal"] || [[obj objectForKey:@"code"] isEqualToString:@"giropay"] || [[obj objectForKey:@"code"] isEqualToString:@"sdd"] || [[obj objectForKey:@"code"] isEqualToString:@"bank-transfer"] || [[obj objectForKey:@"code"] isEqualToString:@"paysafecard"] || [[obj objectForKey:@"code"] isEqualToString:@"sisal"] || [[obj objectForKey:@"code"] isEqualToString:@"3xcb"] || [[obj objectForKey:@"code"] isEqualToString:@"4xcb-no-fees"] || [[obj objectForKey:@"code"] isEqualToString:@"postfinance"] || [[obj objectForKey:@"code"] isEqualToString:@"dcb-at-a1"] || [[obj objectForKey:@"code"] isEqualToString:@"dcb-at-tmobile"] || [[obj objectForKey:@"code"] isEqualToString:@"dcb-at-orange"];
                        }];
                        
                        [currentResponse removeObjectsAtIndexes:indexes];
                    }
                    
                }
 
            }
            
            
            OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithJSONObject:currentResponse statusCode:200 headers:nil];

            response.responseTime = 0.4;
            return response;
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[HPFGatewayClient sharedClient] handleOpenURL:url];
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
