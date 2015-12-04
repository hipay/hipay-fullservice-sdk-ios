//
//  HPFHostedPaymentPageRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFPaymentPageRequestTests : XCTestCase

@end

@implementation HPFPaymentPageRequestTests

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
    HPFPaymentPageRequest *object = [[HPFPaymentPageRequest alloc] init];
    
    NSArray *test1 = @[@"test1", @"test2"], *test2 = @[@"cattest1", @"cattest2"];
    
    object.paymentProductList = test1;
    object.paymentProductCategoryList = test2;
    object.eci = HPFECIRecurringMOTO;
    object.authenticationIndicator = HPFAuthenticationIndicatorIfAvailable;
    object.multiUse = YES;
    object.displaySelector = YES;
    object.templateName = HPFPaymentPageRequestTemplateNameFrame;
    object.css = [NSURL URLWithString:@"https://example.com/style.css"];
    
    XCTAssertEqualObjects([object valueForKey:@"paymentProductList"], test1);
    XCTAssertEqualObjects([object valueForKey:@"paymentProductCategoryList"], test2);
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPFECIRecurringMOTO));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPFAuthenticationIndicatorIfAvailable));
    XCTAssertEqualObjects([object valueForKey:@"multiUse"], @YES);
    XCTAssertEqualObjects([object valueForKey:@"displaySelector"], @YES);
    XCTAssertEqualObjects([object valueForKey:@"templateName"], HPFPaymentPageRequestTemplateNameFrame);
    XCTAssertEqualObjects([object valueForKey:@"css"], [NSURL URLWithString:@"https://example.com/style.css"]);
}

- (void)testDefaultValues
{
    HPFPaymentPageRequest *result = [[HPFPaymentPageRequest alloc] init];
    
    NSSet *groupedCardPaymentProductCodes = [NSSet setWithObjects:HPFPaymentProductCodeMasterCard, HPFPaymentProductCodeVisa, HPFPaymentProductCodeCB, HPFPaymentProductCodeMaestro, HPFPaymentProductCodeAmericanExpress, HPFPaymentProductCodeDiners, nil];
    
    XCTAssertEqual(result.eci, HPFECIUndefined);
    XCTAssertEqual(result.authenticationIndicator, HPFAuthenticationIndicatorUndefined);
    XCTAssertEqual(result.multiUse, NO);
    XCTAssertEqual(result.displaySelector, NO);
    
    XCTAssertEqualObjects(result.groupedPaymentCardProductCodes, groupedCardPaymentProductCodes);
    XCTAssertTrue(result.paymentCardGroupingEnabled);
}

@end
