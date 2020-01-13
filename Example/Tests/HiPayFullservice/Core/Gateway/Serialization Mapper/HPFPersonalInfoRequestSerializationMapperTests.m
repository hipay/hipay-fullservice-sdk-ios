//
//  HPFPersonalInfoRequestSerializationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 14/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFPersonalInfoRequestSerializationMapper.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>

@interface HPFPersonalInfoRequestSerializationMapperTests : XCTestCase

@end

@implementation HPFPersonalInfoRequestSerializationMapperTests

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
    HPFPersonalInfoRequest *personalInfo = [[HPFPersonalInfoRequest alloc] init];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFPersonalInfoRequestSerializationMapper alloc] initWithRequest:personalInfo]];
    HPFPersonalInfoRequestSerializationMapper *mapper = (HPFPersonalInfoRequestSerializationMapper *)mockedMapper;

    [[[mockedMapper expect] andReturn:@"John"] getStringForKey:@"firstname"];
    [[[mockedMapper expect] andReturn:@"Doe"] getStringForKey:@"lastname"];
    [[[mockedMapper expect] andReturn:@"14 Boulevard Arago"] getStringForKey:@"streetAddress"];
    [[[mockedMapper expect] andReturn:@"Bâtiment B"] getStringForKey:@"streetAddress2"];
    [[[mockedMapper expect] andReturn:@"Dr Doe"] getStringForKey:@"recipientInfo"];
    [[[mockedMapper expect] andReturn:@"Paris"] getStringForKey:@"city"];
    [[[mockedMapper expect] andReturn:@"Île-de-France"] getStringForKey:@"state"];
    [[[mockedMapper expect] andReturn:@"75013"] getStringForKey:@"zipCode"];
    [[[mockedMapper expect] andReturn:@"France"] getStringForKey:@"country"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"firstname"], @"John");
    XCTAssertEqualObjects([result objectForKey:@"lastname"], @"Doe");
    XCTAssertEqualObjects([result objectForKey:@"streetaddress"], @"14 Boulevard Arago");
    XCTAssertEqualObjects([result objectForKey:@"streetaddress2"], @"Bâtiment B");
    XCTAssertEqualObjects([result objectForKey:@"recipientinfo"], @"Dr Doe");
    XCTAssertEqualObjects([result objectForKey:@"city"], @"Paris");
    XCTAssertEqualObjects([result objectForKey:@"state"], @"Île-de-France");
    XCTAssertEqualObjects([result objectForKey:@"zipcode"], @"75013");
    XCTAssertEqualObjects([result objectForKey:@"country"], @"France");
    
    [mockedMapper verify];
}

@end
