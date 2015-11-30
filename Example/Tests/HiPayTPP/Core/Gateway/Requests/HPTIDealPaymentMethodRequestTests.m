//
//  HPTIDealPaymentMethodRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 01/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTIDealPaymentMethodRequestTests : XCTestCase

@end

@implementation HPTIDealPaymentMethodRequestTests

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
    HPTIDealPaymentMethodRequest *object = [[HPTIDealPaymentMethodRequest alloc] init];
    
    object.issuerBankId = @"test1";
    
    XCTAssertEqualObjects([object valueForKey:@"issuerBankId"], @"test1");
}

- (void)testInit
{
    HPTIDealPaymentMethodRequest *result = [HPTIDealPaymentMethodRequest iDealPaymentMethodRequestWithIssuerBankId:@"AAAAAA"];
    
    XCTAssertEqualObjects(result.issuerBankId, @"AAAAAA");
}

@end
