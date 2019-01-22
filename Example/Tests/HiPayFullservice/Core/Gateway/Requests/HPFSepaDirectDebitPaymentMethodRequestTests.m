//
//  HPFSepaDirectDebitPaymentMethodRequestTests.m
//  HiPayFullservice_Tests
//
//  Created by Morgan BAUMARD on 26/12/2018.
//  Copyright © 2018 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFSepaDirectDebitPaymentMethodRequestTests : XCTestCase

@end

@implementation HPFSepaDirectDebitPaymentMethodRequestTests

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
    HPFSepaDirectDebitPaymentMethodRequest *object = [[HPFSepaDirectDebitPaymentMethodRequest alloc] init];
    
    object.firstname = @"John";
    object.lastname = @"Doe";
    object.gender = @"H";
    object.iban = @"FR7630006000011234567890189";
    object.bankName = @"bank";
    object.issuerBankId = @"BICXXXXZZZ";
    object.recurringPayment = 1;
    object.debitAgreementId = 12000;

    XCTAssertEqualObjects([object valueForKey:@"firstname"], @"John");
    XCTAssertEqualObjects([object valueForKey:@"lastname"], @"Doe");
    XCTAssertEqualObjects([object valueForKey:@"gender"], @"H");
    XCTAssertEqualObjects([object valueForKey:@"iban"], @"FR7630006000011234567890189");
    XCTAssertEqualObjects([object valueForKey:@"bankName"], @"bank");
    XCTAssertEqualObjects([object valueForKey:@"issuerBankId"], @"BICXXXXZZZ");
    XCTAssertEqualObjects([object valueForKey:@"recurringPayment"], @(1));
    XCTAssertEqualObjects([object valueForKey:@"debitAgreementId"], @(12000));
}

- (void)testInit
{
    HPFSepaDirectDebitPaymentMethodRequest *result = [HPFSepaDirectDebitPaymentMethodRequest sepaDirectDebitPaymentMethodRequestWithfirstname:@"John" lastname:@"Doe" iban:@"FR7630006000011234567890189" recurringPayment:1];
    
    XCTAssertEqualObjects(result.firstname, @"John");
    XCTAssertEqualObjects(result.lastname, @"Doe");
    XCTAssertEqualObjects(result.iban, @"FR7630006000011234567890189");
    XCTAssertEqualObjects(@(result.recurringPayment), @(1));
}

@end
