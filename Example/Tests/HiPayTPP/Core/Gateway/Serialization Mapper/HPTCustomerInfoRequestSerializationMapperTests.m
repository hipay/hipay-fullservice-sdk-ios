//
//  HPTCustomerInfoRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTCustomerInfoRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTCustomerInfoRequestSerializationMapper_Private.h>

@interface HPTCustomerInfoRequestSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    HPTCustomerInfoRequest *request;
    OCMockObject *mockedMapper;
    HPTCustomerInfoRequestSerializationMapper *mapper;
}

@end

@implementation HPTCustomerInfoRequestSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject partialMockForObject:[[HPTCustomerInfoRequest alloc] init]];
    request = (HPTCustomerInfoRequest *)mockedRequest;
    mockedMapper = [OCMockObject partialMockForObject:[[HPTCustomerInfoRequestSerializationMapper alloc] initWithRequest:request]];
    mapper = (HPTCustomerInfoRequestSerializationMapper *)mockedMapper;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBirthDate1
{
    [[[mockedRequest expect] andReturn:@(1)] valueForKey:@"birthDateDay"];
    [[[mockedRequest expect] andReturn:@(8)] valueForKey:@"birthDateMonth"];
    [[[mockedRequest expect] andReturn:@(1981)] valueForKey:@"birthDateYear"];
    
    XCTAssertEqualObjects([mapper getBirthDate], @"19810801");
    
    [mockedMapper verify];
}

- (void)testBirthDate2
{
    [[[mockedRequest expect] andReturn:@(10)] valueForKey:@"birthDateDay"];
    [[[mockedRequest expect] andReturn:@(12)] valueForKey:@"birthDateMonth"];
    [[[mockedRequest expect] andReturn:@(1988)] valueForKey:@"birthDateYear"];
    
    XCTAssertEqualObjects([mapper getBirthDate], @"19881210");
    
    [mockedMapper verify];
}

- (void)testBirthDate3
{
    [[[mockedRequest expect] andReturn:@(10)] valueForKey:@"birthDateDay"];
    [[[mockedRequest expect] andReturn:@(12)] valueForKey:@"birthDateMonth"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"birthDateYear"];
    
    XCTAssertNil([mapper getBirthDate]);
    
    [mockedMapper verify];
}

- (void)testBirthDate4
{
    [[[mockedRequest expect] andReturn:@(10)] valueForKey:@"birthDateDay"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"birthDateMonth"];
    [[[mockedRequest expect] andReturn:@(1988)] valueForKey:@"birthDateYear"];
    
    XCTAssertNil([mapper getBirthDate]);
    
    [mockedMapper verify];
}

- (void)testBirthDate5
{
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"birthDateDay"];
    [[[mockedRequest expect] andReturn:@(12)] valueForKey:@"birthDateMonth"];
    [[[mockedRequest expect] andReturn:@(1988)] valueForKey:@"birthDateYear"];
    
    XCTAssertNil([mapper getBirthDate]);
    
    [mockedMapper verify];
}

- (void)testSerialization
{
    [[[mockedMapper expect] andReturn:@"test1"] getStringForKey:@"email"];
    [[[mockedMapper expect] andReturn:@"test2"] getStringForKey:@"phone"];
    [[[mockedMapper expect] andReturn:@"M"] getCharEnumValueForKey:@"gender"];
    [[[mockedMapper expect] andReturn:@"19880506"] getBirthDate];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"email"], @"test1");
    XCTAssertEqualObjects([result objectForKey:@"phone"], @"test2");
    XCTAssertEqualObjects([result objectForKey:@"birthdate"], @"19880506");
    XCTAssertEqualObjects([result objectForKey:@"gender"], @"M");
    
    [mockedMapper verify];
}

@end
