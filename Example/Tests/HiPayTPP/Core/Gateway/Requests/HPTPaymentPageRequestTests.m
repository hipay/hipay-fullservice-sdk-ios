//
//  HPTHostedPaymentPageRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTPaymentPageRequestTests : XCTestCase

@end

@implementation HPTPaymentPageRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testKeyPaths
{
    HPTPaymentPageRequest *object = [[HPTPaymentPageRequest alloc] init];
    
    NSArray *test1 = @[@"test1", @"test2"], *test2 = @[@"cattest1", @"cattest2"];
    
    object.paymentProductList = test1;
    object.paymentProductCategoryList = test2;
    object.eci = HPTECIRecurringMOTO;
    object.authenticationIndicator = HPTAuthenticationIndicatorIfAvailable;
    object.multiUse = YES;
    
    XCTAssertEqualObjects([object valueForKey:@"paymentProductList"], test1);
    XCTAssertEqualObjects([object valueForKey:@"paymentProductCategoryList"], test2);
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPTECIRecurringMOTO));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPTAuthenticationIndicatorIfAvailable));
    XCTAssertEqualObjects([object valueForKey:@"multiUse"], @YES);
}

- (void)testDefaultValues
{
    HPTPaymentPageRequest *result = [[HPTPaymentPageRequest alloc] init];
    
    XCTAssertEqual(result.eci, HPTECIUndefined);
    XCTAssertEqual(result.authenticationIndicator, HPTAuthenticationIndicatorUndefined);
    XCTAssertEqual(result.multiUse, NO);
}

@end
