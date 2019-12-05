//
//  HPFCardTokenPaymentMethodRequestSerializationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 14/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFCardTokenPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>

@interface HPFCardTokenPaymentMethodRequestSerializationMapperTests : XCTestCase

@end

@implementation HPFCardTokenPaymentMethodRequestSerializationMapperTests

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
    HPFCardTokenPaymentMethodRequest *request = [[HPFCardTokenPaymentMethodRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFCardTokenPaymentMethodRequestSerializationMapper alloc] initWithRequest:request]];
    HPFCardTokenPaymentMethodRequestSerializationMapper *mapper = (HPFCardTokenPaymentMethodRequestSerializationMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"test1"] getStringForKey:@"cardToken"];
    [[[mockedMapper expect] andReturn:@"1"] getIntegerEnumValueForKey:@"eci"];
    [[[mockedMapper expect] andReturn:@"2"] getIntegerEnumValueForKey:@"authenticationIndicator"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"cardtoken"], @"test1");
    XCTAssertEqualObjects([result objectForKey:@"eci"], @"1");
    XCTAssertEqualObjects([result objectForKey:@"authentication_indicator"], @"2");
    
    [mockedMapper verify];
}

@end
