//
//  HPTPaymentProductTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTPaymentProductTests : XCTestCase

@end

@implementation HPTPaymentProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSecurityCodeTypeForPaymentProductCode
{
    // BCMC is often a Maestro card
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeBCMC], HPTSecurityCodeTypeNone);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeCB], HPTSecurityCodeTypeNotApplicable);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeCarteAccord], HPTSecurityCodeTypeNotApplicable);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeAmericanExpress], HPTSecurityCodeTypeCID);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeVisa], HPTSecurityCodeTypeCVV);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeMasterCard], HPTSecurityCodeTypeCVV);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeMaestro], HPTSecurityCodeTypeNone);
    XCTAssertEqual([HPTPaymentProduct securityCodeTypeForPaymentProductCode:HPTPaymentProductCodeDiners], HPTSecurityCodeTypeCVV);
}

@end
