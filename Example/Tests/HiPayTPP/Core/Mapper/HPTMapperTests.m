//
//  HPTMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 01/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HiPayTPP.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <OCMock/OCMock.h>

@interface HPTMapperTests : XCTestCase

@end

@implementation HPTMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    NSDictionary *rawData = @{@"test": @(123)};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertEqualObjects(mapper.rawData, rawData);
}

- (void)testInitNilData {
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:nil];
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testInitArrayData {
    
    id rawData = @[];
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testInitStringData {
    
    id rawData = @"";
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testShouldSuclass {
    NSDictionary *rawData = @{@"test": @(123)};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertThrows(mapper.mappedObject);
}

- (void)testValues {
    NSDictionary *rawData = @{
                              @"charValue": @"U",
                              @"wrongCharValue": @"UO",
                              @"stringNumber": @"25.89",
                              @"number": @(25.89),
                              @"test": @"Hello World",
                              @"null": [NSNull null]
                              };
    
    HPTAbstractMapper *mapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:rawData]];
    
    [((HPTAbstractMapper *)[[(OCMockObject *)mapper expect] andReturn:rawData]) rawData];
    
    // Strings
    XCTAssertEqualObjects([mapper getObjectForKey:@"test"], @"Hello World");
    XCTAssertEqualObjects([mapper getStringForKey:@"test"], @"Hello World");
    XCTAssertNil([mapper getStringForKey:@"number"]);
    
    // Undefined values
    XCTAssertNil([mapper getObjectForKey:@"null"]);
    XCTAssertNil([mapper getObjectForKey:@"unknwon_value"]);

    // Chars
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"charValue"], @('U'));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"wrongCharValue"], @(' '));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"number"], @(' '));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"test"], @(' '));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"null"], @(' '));
}

- (void)testLowercaseString
{
    NSDictionary *rawData = @{@"test": @"HELLO", @"test2": @"hello", @"test3": @"heLLo"};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertEqualObjects([mapper getLowercaseStringForKey:@"test"], @"hello");
    XCTAssertEqualObjects([mapper getLowercaseStringForKey:@"test2"], @"hello");
    XCTAssertEqualObjects([mapper getLowercaseStringForKey:@"test3"], @"hello");
    
}

- (void)testNumber
{
    NSDictionary *rawData = @{
                              @"test1": @"11.78",
                              @"test2": @(11.78),
                              @"test3": @"118165353.78",
                              @"test4": @(118165353.78),
                              @"test5": @"119",
                              @"test6": @(119),
                              @"test7": @"118165353.78986",
                              @"test8": @(118165353.78986),
                              @"test9": @"10.87hello",
                              @"test10": @"hello",
                              @"test11": @"",
                              };
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertEqualObjects([mapper getNumberForKey:@"test1"], @(11.78));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test2"], @(11.78));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test3"], @(118165353.78));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test4"], @(118165353.78));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test5"], @(119));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test6"], @(119));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test7"], @(118165353.78986));
    XCTAssertEqualObjects([mapper getNumberForKey:@"test8"], @(118165353.78986));
    XCTAssertNil([mapper getNumberForKey:@"test9"]);
    XCTAssertNil([mapper getNumberForKey:@"test10"]);
    XCTAssertNil([mapper getNumberForKey:@"test11"]);
    
}

- (void)testInteger
{
    
    OCMockObject *mapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    
    [[[mapper expect] andReturn:@(11.89)] getNumberForKey:@"test1"];
    [[[mapper expect] andReturn:@(11)] getNumberForKey:@"test2"];
    [[[mapper expect] andReturn:@(1898981)] getNumberForKey:@"test3"];
    [[[mapper expect] andReturn:@(1898981.4789765)] getNumberForKey:@"test4"];
    [[[mapper expect] andReturn:nil] getNumberForKey:@"test5"];
    [[[mapper expect] andReturn:@(0.89989)] getNumberForKey:@"test6"];
    [[[mapper expect] andReturn:@(0.19989)] getNumberForKey:@"test7"];
    [[[mapper expect] andReturn:@(0)] getNumberForKey:@"test8"];

    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test1"], 11);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test2"], 11);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test3"], 1898981);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test4"], 1898981);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test5"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test6"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test7"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerFromKey:@"test8"], 0);
    
    [mapper verify];
}

- (void)testEnumValues
{
    typedef NS_ENUM(NSInteger, HPTTestEnumValue) {
        
        HPTTestEnumValueUnknown,
        HPTTestEnumValueRed,
        HPTTestEnumValueWhite,
        HPTTestEnumValueBlue,
        
    };
    
    NSDictionary *values = @{@"red": @(HPTTestEnumValueRed),
                             @"blue": @(HPTTestEnumValueBlue),
                             @"white": @(HPTTestEnumValueWhite)};
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"white"] getLowercaseStringForKey:@"test1"];
    [[[mockedMapper expect] andReturn:@"blue"] getLowercaseStringForKey:@"test2"];
    [[[mockedMapper expect] andReturn:@"red"] getLowercaseStringForKey:@"test3"];
    [[[mockedMapper expect] andReturn:@"yellow"] getLowercaseStringForKey:@"test4"];
    [[[mockedMapper expect] andReturn:@""] getLowercaseStringForKey:@"test5"];
    [[[mockedMapper expect] andReturn:nil] getLowercaseStringForKey:@"test6"];
    
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test1" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueWhite);
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test2" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueBlue);
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test3" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueRed);
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test4" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueUnknown);
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test5" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueUnknown);
    XCTAssertEqual([mapper getIntegerEnumValueWithKey:@"test6" defaultEnumValue:HPTTestEnumValueUnknown allValues:values], HPTTestEnumValueUnknown);
    
    [mockedMapper verify];
    
}

@end
