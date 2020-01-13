//
//  HPFCardTokenPaymentMethodRequestTests.m
//  HiPayFullservice
//
//  Created by HiPay on 15/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFCardTokenPaymentMethodRequestTests : XCTestCase

@end

@implementation HPFCardTokenPaymentMethodRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultValues
{
    HPFCardTokenPaymentMethodRequest *object = [[HPFCardTokenPaymentMethodRequest alloc] init];
    
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPFECIDefault));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPFAuthenticationIndicatorDefault));
}

- (void)testKeyPaths
{
    HPFCardTokenPaymentMethodRequest *object = [[HPFCardTokenPaymentMethodRequest alloc] init];
    
    object.cardToken = @"test1";
    object.eci = HPFECIMOTO;
    object.authenticationIndicator = HPFAuthenticationIndicatorIfAvailable;
    
    XCTAssertEqualObjects([object valueForKey:@"cardToken"], @"test1");
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPFECIMOTO));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPFAuthenticationIndicatorIfAvailable));
}

- (void)testInit
{
    HPFCardTokenPaymentMethodRequest *result = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:@"testtoken" eci:HPFECIMOTO authenticationIndicator:HPFAuthenticationIndicatorIfAvailable];
    
    XCTAssertEqualObjects(result.cardToken, @"testtoken");
    XCTAssertEqual(result.eci, HPFECIMOTO);
    XCTAssertEqual(result.authenticationIndicator, HPFAuthenticationIndicatorIfAvailable);
}

@end
