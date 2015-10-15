//
//  HPTCardTokenPaymentMethodRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTCardTokenPaymentMethodRequestTests : XCTestCase

@end

@implementation HPTCardTokenPaymentMethodRequestTests

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
    HPTCardTokenPaymentMethodRequest *object = [[HPTCardTokenPaymentMethodRequest alloc] init];
    
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPTECIUndefined));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPTAuthenticationIndicatorUndefined));
}

- (void)testKeyPaths
{
    HPTCardTokenPaymentMethodRequest *object = [[HPTCardTokenPaymentMethodRequest alloc] init];
    
    object.cardToken = @"test1";
    object.eci = HPTECIMOTO;
    object.authenticationIndicator = HPTAuthenticationIndicatorIfAvailable;
    
    XCTAssertEqualObjects([object valueForKey:@"cardToken"], @"test1");
    XCTAssertEqualObjects([object valueForKey:@"eci"], @(HPTECIMOTO));
    XCTAssertEqualObjects([object valueForKey:@"authenticationIndicator"], @(HPTAuthenticationIndicatorIfAvailable));
}

@end
