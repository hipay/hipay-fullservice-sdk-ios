//
//  HPFSepaDirectDebitPaymentMethodRequestSerializationMapperTests.m
//  HiPayFullservice_Tests
//
//  Created by HiPay on 26/12/2018.
//  Copyright © 2018 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFSepaDirectDebitPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>
#import <HiPayFullservice/HPFSepaDirectDebitPaymentMethodRequest.h>

@interface HPFSepaDirectDebitPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPFSepaDirectDebitPaymentMethodRequestSerializationMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSerialization
{
    HPFSepaDirectDebitPaymentMethodRequest *request = [[HPFSepaDirectDebitPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFSepaDirectDebitPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPFSepaDirectDebitPaymentMethodRequestSerializationMapper *mapper = (HPFSepaDirectDebitPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"John"] getStringForKey:@"firstname"];
    [[[mockedMapper expect] andReturn:@"Doe"] getStringForKey:@"lastname"];
    [[[mockedMapper expect] andReturn:@"FR7630006000011234567890189"] getStringForKey:@"iban"];
    [[[mockedMapper expect] andReturn:@"1"] getIntegerForKey:@"recurringPayment"];

    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"firstname"], @"John");
    XCTAssertEqualObjects([result objectForKey:@"lastname"], @"Doe");
    XCTAssertEqualObjects([result objectForKey:@"iban"], @"FR7630006000011234567890189");
    XCTAssertEqualObjects([result objectForKey:@"recurring_payment"], @"1");

    
    [mockedMapper verify];
}

@end
