//
//  HPTIDealPaymentMethodRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 01/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTIDealPaymentMethodRequestSerializationMapper.h>

@interface HPTIDealPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPTIDealPaymentMethodRequestSerializationMapperTests

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
    HPTIDealPaymentMethodRequest *request = [[HPTIDealPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTIDealPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPTIDealPaymentMethodRequestSerializationMapper *mapper = (HPTIDealPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"AAAAAA"] getStringForKey:@"issuerBankId"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"issuer_bank_id"], @"AAAAAA");
    
    [mockedMapper verify];
}

@end
