//
//  HPTQiwiWalletPaymentMethodRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 29/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTQiwiWalletPaymentMethodRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTQiwiWalletPaymentMethodRequest.h>

@interface HPTQiwiWalletPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPTQiwiWalletPaymentMethodRequestSerializationMapperTests

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
    HPTQiwiWalletPaymentMethodRequest *request = [[HPTQiwiWalletPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTQiwiWalletPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPTQiwiWalletPaymentMethodRequestSerializationMapper *mapper = (HPTQiwiWalletPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"+1234455553"] getStringForKey:@"username"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"qiwiuser"], @"+1234455553");
    
    [mockedMapper verify];
}

@end
