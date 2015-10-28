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
                              @"code": @(1597561245),
                              @"test": @"Hello World",
                              @"null": [NSNull null]
                              };
    
    HPTAbstractMapper *mapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:rawData]];
    
    [((HPTAbstractMapper *)[[(OCMockObject *)mapper expect] andReturn:rawData]) rawData];
    
    // Strings
    XCTAssertEqualObjects([mapper getObjectForKey:@"test"], @"Hello World");
    XCTAssertEqualObjects([mapper getStringForKey:@"test"], @"Hello World");
    XCTAssertEqualObjects([mapper getStringForKey:@"code"], @"1597561245");
    XCTAssertEqualObjects([mapper getStringForKey:@"number"], @"25.89");
    
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

    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test1"], 11);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test2"], 11);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test3"], 1898981);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test4"], 1898981);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test5"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test6"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test7"], 0);
    XCTAssertEqual([((HPTAbstractMapper *) mapper) getIntegerForKey:@"test8"], 0);
    
    [mapper verify];
}

- (void)testDateISO8601
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"2015-10-08T08:49:31+0000"] getStringForKey:@"test1"];
    [[[mockedMapper expect] andReturn:@"2015-10-08T08:16:20+0200"] getStringForKey:@"test2"];
    [[[mockedMapper expect] andReturn:nil] getStringForKey:@"test3"];
    [[[mockedMapper expect] andReturn:@"201a5-1-8T08:6:20+0200"] getStringForKey:@"test4"];
    [[[mockedMapper expect] andReturn:@"15-10-08T:16:20+02000"] getStringForKey:@"test5"];
    [[[mockedMapper expect] andReturn:@"whatevr"] getStringForKey:@"test6"];
    [[[mockedMapper expect] andReturn:@"2015-10-08T08:49:31-0400"] getStringForKey:@"test7"];
    [[[mockedMapper expect] andReturn:@"2015-12-31T08:49:31+0000"] getStringForKey:@"test8"];
    
    XCTAssertEqualObjects([mapper getDateISO8601ForKey:@"test1"], [NSDate dateWithTimeIntervalSince1970:1444294171]);
    XCTAssertEqualObjects([mapper getDateISO8601ForKey:@"test2"], [NSDate dateWithTimeIntervalSince1970:1444284980]);
    XCTAssertNil([mapper getDateISO8601ForKey:@"test3"]);
    XCTAssertNil([mapper getDateISO8601ForKey:@"test4"]);
    XCTAssertNil([mapper getDateISO8601ForKey:@"test5"]);
    XCTAssertNil([mapper getDateISO8601ForKey:@"test6"]);
    XCTAssertEqualObjects([mapper getDateISO8601ForKey:@"test7"], [NSDate dateWithTimeIntervalSince1970:1444308571]);
    XCTAssertEqualObjects([mapper getDateISO8601ForKey:@"test8"], [NSDate dateWithTimeIntervalSince1970:1451551771]);

    [mockedMapper verify];
}

- (void)testDateBasic
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"2015-10-08 10:49:43+02"] getStringForKey:@"test1"];
    [[[mockedMapper expect] andReturn:@"2015-10-08 10:49:20+00"] getStringForKey:@"test2"];
    [[[mockedMapper expect] andReturn:@"2015-10-08 10:49:43-02"] getStringForKey:@"test3"];
    [[[mockedMapper expect] andReturn:@"2015-12-31 10:49:20+02"] getStringForKey:@"test4"];
    
    XCTAssertEqualObjects([mapper getDateBasicForKey:@"test1"], [NSDate dateWithTimeIntervalSince1970:1444294183]);
    XCTAssertEqualObjects([mapper getDateBasicForKey:@"test2"], [NSDate dateWithTimeIntervalSince1970:1444301360]);
    XCTAssertEqualObjects([mapper getDateBasicForKey:@"test3"], [NSDate dateWithTimeIntervalSince1970:1444308583]);
    XCTAssertEqualObjects([mapper getDateBasicForKey:@"test4"], [NSDate dateWithTimeIntervalSince1970:1451551760]);

    [mockedMapper verify];
}

- (void)testDate
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    NSDate *test1 = [NSDate dateWithTimeIntervalSince1970:1444301360];
    NSDate *test2 = [NSDate dateWithTimeIntervalSince1970:1444301361];
    
    [[[mockedMapper expect] andReturn:test1] getDateBasicForKey:@"test1"];
    
    [[[mockedMapper expect] andReturn:nil] getDateBasicForKey:@"test2"];
    [[[mockedMapper expect] andReturn:test2] getDateISO8601ForKey:@"test2"];

    [[[mockedMapper expect] andReturn:nil] getDateBasicForKey:@"test3"];
    [[[mockedMapper expect] andReturn:nil] getDateISO8601ForKey:@"test3"];
    
    
    XCTAssertEqualObjects([mapper getDateForKey:@"test1"], test1);
    XCTAssertEqualObjects([mapper getDateForKey:@"test2"], test2);
    XCTAssertNil([mapper getDateForKey:@"test3"]);
    
    [mockedMapper verify];
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

- (void)testBoolNumberValues
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    
    [[[mockedMapper expect] andReturn:@"true"] getObjectForKey:@"string_test1"];
    [[[mockedMapper expect] andReturn:@"false"] getObjectForKey:@"string_test2"];
    [[[mockedMapper expect] andReturn:@"whatever"] getObjectForKey:@"string_test3"];
    
    [[[mockedMapper expect] andReturn:@(YES)] getObjectForKey:@"string_number1"];
    [[[mockedMapper expect] andReturn:@(NO)] getObjectForKey:@"string_number2"];
    [[[mockedMapper expect] andReturn:@(1)] getObjectForKey:@"string_number3"];
    [[[mockedMapper expect] andReturn:@(2)] getObjectForKey:@"string_number4"];
    [[[mockedMapper expect] andReturn:@(-1)] getObjectForKey:@"string_number5"];
    [[[mockedMapper expect] andReturn:@(0)] getObjectForKey:@"string_number6"];
    
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_test1"], @(YES));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_test2"], @(NO));
    XCTAssertNil([mapper getBoolNumberForKey:@"string_test3"]);
    
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number1"], @(YES));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number2"], @(NO));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number3"], @(YES));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number4"], @(YES));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number5"], @(YES));
    XCTAssertEqualObjects([mapper getBoolNumberForKey:@"string_number6"], @(NO));
    
    
    [mockedMapper verify];
}

- (void)testBoolValues
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@(YES)] getBoolNumberForKey:@"test1"];
    [[[mockedMapper expect] andReturn:@(NO)] getObjectForKey:@"test2"];
    [[[mockedMapper expect] andReturn:nil] getObjectForKey:@"test3"];
    
    XCTAssertEqual([mapper getBoolForKey:@"test1"], YES);
    XCTAssertEqual([mapper getBoolForKey:@"test2"], NO);
    XCTAssertEqual([mapper getBoolForKey:@"test3"], NO);

    
    [mockedMapper verify];
}

- (void)testDictionaryValues
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    NSDictionary *dict = @{@"key1": @"val1", @"param": @{@"key2": @"val2"}};
    NSDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:@{@"key1": @"val1", @"param": @{@"key2": @"val2"}}];
    
    [[[mockedMapper expect] andReturn:dict] getObjectForKey:@"test1"];
    [[[mockedMapper expect] andReturn:dict2] getObjectForKey:@"test2"];
    [[[mockedMapper expect] andReturn:@[@(4), @"hello"]] getObjectForKey:@"test3"];
    [[[mockedMapper expect] andReturn:@"hello"] getObjectForKey:@"test4"];
    
    XCTAssertEqual([mapper getDictionaryForKey:@"test1"], dict);
    XCTAssertEqual([mapper getDictionaryForKey:@"test2"], dict2);
    XCTAssertNil([mapper getDictionaryForKey:@"test3"]);
    XCTAssertNil([mapper getDictionaryForKey:@"test4"]);
    
    [mockedMapper verify];
}

- (void)testURLValues
{
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:@{}]];
    HPTAbstractMapper *mapper = (HPTAbstractMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@"http://www.example.com/page/to/redirect"] getStringForKey:@"test1"];
    [[[mockedMapper expect] andReturn:@"https://www.example2.com/page/to/redirect.php"] getStringForKey:@"test2"];
    [[[mockedMapper expect] andReturn:nil] getStringForKey:@"test3"];
    [[[mockedMapper expect] andReturn:@"invalid URL"] getStringForKey:@"test4"];
    [[[mockedMapper expect] andReturn:@""] getStringForKey:@"test5"];
    
    XCTAssertEqualObjects([mapper getURLForKey:@"test1"], [NSURL URLWithString:@"http://www.example.com/page/to/redirect"]);
    XCTAssertEqualObjects([mapper getURLForKey:@"test2"], [NSURL URLWithString:@"https://www.example2.com/page/to/redirect.php"]);
    XCTAssertNil([mapper getURLForKey:@"test3"]);
    XCTAssertNil([mapper getURLForKey:@"test4"]);
    XCTAssertNil([mapper getURLForKey:@"test5"]);
    
    [mockedMapper verify];
}

- (void)testObjectsArrayValues
{
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:@{}];

    NSArray *test1 = @[@{@"state": @"completed"}, @{@"state": @"pending"}];
    NSDictionary *test2 = @{@"0": @{@"state": @"completed"}, @"1": @{@"state": @"pending"}};

    XCTAssertEqualObjects([mapper getObjectsArrayForObject:test1], test1);
    XCTAssertEqualObjects([mapper getObjectsArrayForObject:test2], test1);
    XCTAssertNil([mapper getObjectsArrayForObject:nil]);
    XCTAssertNil([mapper getObjectsArrayForObject:@"test"]);
    
}

@end
