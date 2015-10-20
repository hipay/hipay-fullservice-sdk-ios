//
//  HPTAbstractSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>

@interface HPTAbstractSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    OCMockObject *mockedMapper;
    HPTAbstractSerializationMapper *mapper;
}

@end

@implementation HPTAbstractSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject mockForClass:[NSObject class]];
    mockedMapper = [OCMockObject partialMockForObject:[HPTAbstractSerializationMapper mapperWithRequest:mockedRequest]];
    mapper = (HPTAbstractSerializationMapper *)mockedMapper;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    XCTAssertEqual(mapper.request, mockedRequest);
}

- (void)testInitNil {
    XCTAssertNil([HPTAbstractSerializationMapper mapperWithRequest:nil]);
}

- (void)testShouldSuclass {
    XCTAssertThrows(mapper.serializedRequest);
}

- (void)testResponseDictionaryCreation
{
    XCTAssertTrue([[mapper createResponseDictionary] isKindOfClass:[NSMutableDictionary class]]);
}

- (void)testImmutableDictionaryCreation
{
    NSMutableDictionary *initialDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"key": @"val", @"key2": @"val2"}];
    NSDictionary *result = [mapper createImmutableDictionary:initialDictionary];
    
    XCTAssertEqualObjects(result, initialDictionary);
    XCTAssertFalse([result isKindOfClass:[NSMutableDictionary class]]);
}

- (void)testGetURLValues
{
    [[[mockedRequest expect] andReturn:[NSURL URLWithString:@"http://www.example.com/forward/ok"]] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test3"];
    
    XCTAssertEqualObjects([mapper getURLForKey:@"test1"], @"http://www.example.com/forward/ok");
    XCTAssertNil([mapper getURLForKey:@"test2"]);
    XCTAssertNil([mapper getURLForKey:@"test3"]);
    
    [mockedRequest verify];
}

- (void)testIntegerValues
{
    [[[mockedRequest expect] andReturn:@(45)] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@(45.125457)] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@(45.125457)] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test5"];
    
    XCTAssertEqualObjects([mapper getIntegerForKey:@"test1"], @"45");
    XCTAssertEqualObjects([mapper getIntegerForKey:@"test2"], @"45");
    XCTAssertEqualObjects([mapper getIntegerForKey:@"test3"], @"45");
    XCTAssertNil([mapper getIntegerForKey:@"test4"]);
    XCTAssertNil([mapper getIntegerForKey:@"test5"]);

    [mockedRequest verify];
}

- (void)testFloatValues
{
    [[[mockedRequest expect] andReturn:@45] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test3"];
    
    id classMock = OCMClassMock([HPTAbstractSerializationMapper class]);
    OCMStub([classMock formatAmountNumber:@45]).andReturn(@"45.00");
    
    XCTAssertEqualObjects([mapper getFloatForKey:@"test1"], @"45.00");
    XCTAssertNil([mapper getFloatForKey:@"test2"]);
    XCTAssertNil([mapper getFloatForKey:@"test3"]);

    OCMVerify([classMock formatAmountNumber:@45]);
    [mockedRequest verify];
}

- (void)testAmountNumberFormat
{
    XCTAssertEqualObjects([HPTAbstractSerializationMapper formatAmountNumber:@45], @"45.00");
    XCTAssertEqualObjects([HPTAbstractSerializationMapper formatAmountNumber:@45.12], @"45.12");
    XCTAssertEqualObjects([HPTAbstractSerializationMapper formatAmountNumber:@45.125457], @"45.1254");
}

- (void)testDateValues
{
    [[[mockedRequest expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1451551771]] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1423440000]] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test4"];
    
    XCTAssertEqualObjects([mapper getDateForKey:@"test1" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]], @"2015-12-31");
    XCTAssertEqualObjects([mapper getDateForKey:@"test2" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]], @"2015-02-09");
    XCTAssertNil([mapper getDateForKey:@"test3" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]]);
    XCTAssertNil([mapper getDateForKey:@"test4" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]]);
    
    NSString *result = @"2015-11-12";
    
    [[[mockedMapper expect] andReturn:result] getDateForKey:@"test_final" timeZone:[NSTimeZone systemTimeZone]];
    
    XCTAssertEqual([mapper getDateForKey:@"test_final"], result);
    
    [mockedMapper verify];
    [mockedRequest verify];
}

- (void)testStringValuesList
{
    [[[mockedRequest expect] andReturn:@[@"hello", @"world", @"ok"]] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@[@"hello"]] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@[]] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test5"];
    
    XCTAssertEqualObjects([mapper getStringValuesListForKey:@"test1"], @"hello,world,ok");
    XCTAssertEqualObjects([mapper getStringValuesListForKey:@"test2"], @"hello");
    XCTAssertEqualObjects([mapper getStringValuesListForKey:@"test3"], @"");
    XCTAssertNil([mapper getStringValuesListForKey:@"test4"]);
    XCTAssertNil([mapper getStringValuesListForKey:@"test5"]);
    
    [mockedRequest verify];
}

- (void)testStringValues
{
    [[[mockedRequest expect] andReturn:@"Hello"] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@(2)] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test3"];
    
    XCTAssertEqualObjects([mapper getStringForKey:@"test1"], @"Hello");
    XCTAssertNil([mapper getStringForKey:@"test2"]);
    XCTAssertNil([mapper getStringForKey:@"test3"]);

    [mockedRequest verify];
}

- (void)testCharEnumValues
{
    [[[mockedRequest expect] andReturn:@('A')] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@('H')] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@('Z')] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@(' ')] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test5"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test6"];
    
    XCTAssertEqualObjects([mapper getCharEnumValueForKey:@"test1"], @"A");
    XCTAssertEqualObjects([mapper getCharEnumValueForKey:@"test2"], @"H");
    XCTAssertEqualObjects([mapper getCharEnumValueForKey:@"test3"], @"Z");
    XCTAssertNil([mapper getCharEnumValueForKey:@"test4"]);
    XCTAssertNil([mapper getCharEnumValueForKey:@"test5"]);
    XCTAssertNil([mapper getCharEnumValueForKey:@"test6"]);
    
    [mockedRequest verify];
}

- (void)testIntegerEnumValues
{
    [[[mockedRequest expect] andReturn:@(12)] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@(0)] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@(546445)] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@(NSIntegerMax)] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test5"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test6"];
    
    XCTAssertEqualObjects([mapper getIntegerEnumValueForKey:@"test1"], @"12");
    XCTAssertEqualObjects([mapper getIntegerEnumValueForKey:@"test2"], @"0");
    XCTAssertEqualObjects([mapper getIntegerEnumValueForKey:@"test3"], @"546445");
    XCTAssertNil([mapper getIntegerEnumValueForKey:@"test4"]);
    XCTAssertNil([mapper getIntegerEnumValueForKey:@"test5"]);
    XCTAssertNil([mapper getIntegerEnumValueForKey:@"test6"]);
    
    [mockedRequest verify];
}

@end
