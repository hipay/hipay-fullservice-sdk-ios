//
//  HPFIDealPaymentMethodRequestSerializationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 01/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>
#import <HiPayFullservice/HPFIDealPaymentMethodRequestSerializationMapper.h>

@interface HPFIDealPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPFIDealPaymentMethodRequestSerializationMapperTests

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
    HPFIDealPaymentMethodRequest *request = [[HPFIDealPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFIDealPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPFIDealPaymentMethodRequestSerializationMapper *mapper = (HPFIDealPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"AAAAAA"] getStringForKey:@"issuerBankId"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"issuer_bank_id"], @"AAAAAA");
    
    [mockedMapper verify];
}

@end
