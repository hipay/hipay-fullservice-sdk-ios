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

- (void)testGetURLValues
{
    [[[mockedRequest expect] andReturn:[NSURL URLWithString:@"http://www.example.com/forward/ok"]] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test3"];
    
    XCTAssertEqualObjects([mapper getURLForKeyPath:@"test1"], @"http://www.example.com/forward/ok");
    XCTAssertNil([mapper getURLForKeyPath:@"test2"]);
    XCTAssertNil([mapper getURLForKeyPath:@"test3"]);
    
    [mockedRequest verify];
}

- (void)testIntegerValues
{
    [[[mockedRequest expect] andReturn:@(45)] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@(45.125457)] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@(45.125457)] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test5"];
    
    XCTAssertEqualObjects([mapper getIntegerForKeyPath:@"test1"], @"45");
    XCTAssertEqualObjects([mapper getIntegerForKeyPath:@"test2"], @"45");
    XCTAssertEqualObjects([mapper getIntegerForKeyPath:@"test3"], @"45");
    XCTAssertNil([mapper getIntegerForKeyPath:@"test4"]);
    XCTAssertNil([mapper getIntegerForKeyPath:@"test5"]);

    [mockedRequest verify];
}

- (void)testFloatValues
{
    [[[mockedRequest expect] andReturn:@(45)] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:@(45.12)] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@(45.125457)] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test4"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test5"];
    
    XCTAssertEqualObjects([mapper getFloatForKeyPath:@"test1"], @"45.00");
    XCTAssertEqualObjects([mapper getFloatForKeyPath:@"test2"], @"45.12");
    XCTAssertEqualObjects([mapper getFloatForKeyPath:@"test3"], @"45.1254");
    XCTAssertNil([mapper getFloatForKeyPath:@"test4"]);
    XCTAssertNil([mapper getFloatForKeyPath:@"test5"]);

    [mockedRequest verify];
}

- (void)testDateValues
{
    [[[mockedRequest expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1451551771]] valueForKey:@"test1"];
    [[[mockedRequest expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1423440000]] valueForKey:@"test2"];
    [[[mockedRequest expect] andReturn:@"hello"] valueForKey:@"test3"];
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"test4"];
    
    XCTAssertEqualObjects([mapper getDateForKeyPath:@"test1" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]], @"2015-12-31");
    XCTAssertEqualObjects([mapper getDateForKeyPath:@"test2" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]], @"2015-02-09");
    XCTAssertNil([mapper getDateForKeyPath:@"test3" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]]);
    XCTAssertNil([mapper getDateForKeyPath:@"test4" timeZone:[NSTimeZone timeZoneWithName:@"GMT"]]);
    
    NSString *result = @"2015-11-12";
    
    [[[mockedMapper expect] andReturn:result] getDateForKeyPath:@"test_final" timeZone:[NSTimeZone systemTimeZone]];
    
    XCTAssertEqual([mapper getDateForKeyPath:@"test_final"], result);
    
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
    
    XCTAssertEqualObjects([mapper getStringValuesListForKeyPath:@"test1"], @"hello,world,ok");
    XCTAssertEqualObjects([mapper getStringValuesListForKeyPath:@"test2"], @"hello");
    XCTAssertEqualObjects([mapper getStringValuesListForKeyPath:@"test3"], @"");
    XCTAssertNil([mapper getStringValuesListForKeyPath:@"test4"]);
    XCTAssertNil([mapper getStringValuesListForKeyPath:@"test5"]);
    
    [mockedRequest verify];
}

@end
