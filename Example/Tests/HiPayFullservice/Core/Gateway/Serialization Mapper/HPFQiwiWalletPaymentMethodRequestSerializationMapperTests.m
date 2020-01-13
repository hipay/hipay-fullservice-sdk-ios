//
//  HPFQiwiWalletPaymentMethodRequestSerializationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 29/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFQiwiWalletPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>
#import <HiPayFullservice/HPFQiwiWalletPaymentMethodRequest.h>

@interface HPFQiwiWalletPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPFQiwiWalletPaymentMethodRequestSerializationMapperTests

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
    HPFQiwiWalletPaymentMethodRequest *request = [[HPFQiwiWalletPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFQiwiWalletPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPFQiwiWalletPaymentMethodRequestSerializationMapper *mapper = (HPFQiwiWalletPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"+1234455553"] getStringForKey:@"username"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"qiwiuser"], @"+1234455553");
    
    [mockedMapper verify];
}

@end
