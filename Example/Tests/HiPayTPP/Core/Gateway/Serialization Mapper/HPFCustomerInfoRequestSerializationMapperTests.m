//
//  HPFCustomerInfoRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPFCustomerInfoRequestSerializationMapper.h>
#import <HiPayTPP/HPFAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPFCustomerInfoRequestSerializationMapper_Private.h>
#import <HiPayTPP/HPFPersonalInfoRequestSerializationMapper_Protected.h>

@interface HPFCustomerInfoRequestSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    HPFCustomerInfoRequest *request;
    OCMockObject *mockedMapper;
    HPFCustomerInfoRequestSerializationMapper *mapper;
}

@end

@implementation HPFCustomerInfoRequestSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject partialMockForObject:[[HPFCustomerInfoRequest alloc] init]];
    request = (HPFCustomerInfoRequest *)mockedRequest;
    mockedMapper = [OCMockObject partialMockForObject:[[HPFCustomerInfoRequestSerializationMapper alloc] initWithRequest:request]];
    mapper = (HPFCustomerInfoRequestSerializationMapper *)mockedMapper;
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
    
    NSMutableDictionary *initialValues = [NSMutableDictionary dictionaryWithObject:@"value1" forKey:@"param1"];
    
    [[[mockedMapper expect] andReturn:initialValues] personalInformationSerializedRequest];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqualObjects([result objectForKey:@"email"], @"test1");
    XCTAssertEqualObjects([result objectForKey:@"phone"], @"test2");
    XCTAssertEqualObjects([result objectForKey:@"birthdate"], @"19880506");
    XCTAssertEqualObjects([result objectForKey:@"gender"], @"M");
    XCTAssertEqualObjects([result objectForKey:@"param1"], @"value1");
    
    [mockedMapper verify];
}

@end
