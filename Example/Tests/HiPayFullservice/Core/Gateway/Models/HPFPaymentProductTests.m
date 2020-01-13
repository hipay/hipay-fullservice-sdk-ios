//
//  HPFPaymentProductTests.m
//  HiPayFullservice
//
//  Created by HiPay on 14/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFPaymentProductTests : XCTestCase

@end

@implementation HPFPaymentProductTests

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
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeBCMC], HPFSecurityCodeTypeNone);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeCB], HPFSecurityCodeTypeNotApplicable);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeCarteAccord], HPFSecurityCodeTypeNotApplicable);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeAmericanExpress], HPFSecurityCodeTypeCID);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeVisa], HPFSecurityCodeTypeCVV);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeMasterCard], HPFSecurityCodeTypeCVV);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeMaestro], HPFSecurityCodeTypeNone);
    XCTAssertEqual([HPFPaymentProduct securityCodeTypeForPaymentProductCode:HPFPaymentProductCodeDiners], HPFSecurityCodeTypeCVV);
}

@end
