//
//  HPTExpiryDateFormatterTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTExpiryDateFormatter.h>
#import <HiPayTPP/HPTFormatter_Private.h>

@interface HPTExpiryDateFormatterTests : XCTestCase
{
    OCMockObject *mockedFormatter;
    HPTExpiryDateFormatter *formatter;
}

@end

@implementation HPTExpiryDateFormatterTests

- (void)setUp {
    [super setUp];
    
    mockedFormatter = [OCMockObject partialMockForObject:[[HPTExpiryDateFormatter alloc] init]];
    formatter = (HPTExpiryDateFormatter *)mockedFormatter;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFormatDateWithPlainText
{
    [[[mockedFormatter expect] andReturn:@""] digitsOnlyFromPlainText:@"test1"];
    [[[mockedFormatter expect] andReturn:@"1"] digitsOnlyFromPlainText:@"test2"];
    [[[mockedFormatter expect] andReturn:@"11"] digitsOnlyFromPlainText:@"11"];
    [[[mockedFormatter expect] andReturn:@"11"] digitsOnlyFromPlainText:@"11 /"];
    [[[mockedFormatter expect] andReturn:@"111"] digitsOnlyFromPlainText:@"test4"];
    [[[mockedFormatter expect] andReturn:@"1116"] digitsOnlyFromPlainText:@"test5"];
    [[[mockedFormatter expect] andReturn:@"6"] digitsOnlyFromPlainText:@"test6"];
    
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"test1"], @"");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"test2"], @"1");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"11"], @"11 / ");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"11 /"], @"1");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"test4"], @"11 / 1");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"test5"], @"11 / 16");
    XCTAssertEqualObjects([formatter formattedDateWithPlainText:@"test6"], @"06 / ");
    
    [mockedFormatter verify];
}

- (void)testDateIsCompleteForPlainText
{
    [[[mockedFormatter expect] andReturn:@""] digitsOnlyFromPlainText:@"test1"];
    [[[mockedFormatter expect] andReturn:@"1"] digitsOnlyFromPlainText:@"test2"];
    [[[mockedFormatter expect] andReturn:@"11"] digitsOnlyFromPlainText:@"test3"];
    [[[mockedFormatter expect] andReturn:@"111"] digitsOnlyFromPlainText:@"test4"];
    [[[mockedFormatter expect] andReturn:@"1116"] digitsOnlyFromPlainText:@"test5"];
    [[[mockedFormatter expect] andReturn:@"11167"] digitsOnlyFromPlainText:@"test6"];
    
    XCTAssertFalse([formatter dateIsCompleteForPlainText:@"test1"]);
    XCTAssertFalse([formatter dateIsCompleteForPlainText:@"test2"]);
    XCTAssertFalse([formatter dateIsCompleteForPlainText:@"test3"]);
    XCTAssertFalse([formatter dateIsCompleteForPlainText:@"test4"]);
    XCTAssertTrue([formatter dateIsCompleteForPlainText:@"test5"]);
    XCTAssertTrue([formatter dateIsCompleteForPlainText:@"test6"]);
    
    [mockedFormatter verify];
}

- (void)testDateComponentsForPlainText
{
    [[[mockedFormatter expect] andReturn:@"1216"] digitsOnlyFromPlainText:@"test1"];
    [[[mockedFormatter expect] andReturn:@"1210"] digitsOnlyFromPlainText:@"test2"];
    [[[mockedFormatter expect] andReturn:@"0600"] digitsOnlyFromPlainText:@"test3"];
    [[[mockedFormatter expect] andReturn:@"0680"] digitsOnlyFromPlainText:@"test4"];
    [[[mockedFormatter expect] andReturn:@"1066"] digitsOnlyFromPlainText:@"test5"];
    [[[mockedFormatter expect] andReturn:@"1065"] digitsOnlyFromPlainText:@"test6"];
    [[[mockedFormatter expect] andReturn:@"0940"] digitsOnlyFromPlainText:@"test7"];
    [[[mockedFormatter expect] andReturn:@"6010"] digitsOnlyFromPlainText:@"test8"];
    
    NSDateComponents *test1 = [[NSDateComponents alloc] init];
    test1.month = 12;
    test1.year = 2016;
    
    NSDateComponents *test2 = [[NSDateComponents alloc] init];
    test2.month = 12;
    test2.year = 2010;
    
    NSDateComponents *test3 = [[NSDateComponents alloc] init];
    test3.month = 6;
    test3.year = 2000;
    
    NSDateComponents *test4 = [[NSDateComponents alloc] init];
    test4.month = 6;
    test4.year = 1980;
    
    NSDateComponents *test5 = [[NSDateComponents alloc] init];
    test5.month = 10;
    test5.year = 1966;
    
    NSDateComponents *test6 = [[NSDateComponents alloc] init];
    test6.month = 10;
    test6.year = 1965;
    
    NSDateComponents *test7 = [[NSDateComponents alloc] init];
    test7.month = 9;
    test7.year = 2040;
    
    id classMock = OCMClassMock([NSDate class]);
    OCMStub([classMock date]).andReturn([NSDate dateWithTimeIntervalSince1970:1447091435]);
    
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test1"], test1);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test2"], test2);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test3"], test3);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test4"], test4);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test5"], test5);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test6"], test6);
    XCTAssertEqualObjects([formatter dateComponentsForPlainText:@"test7"], test7);
    
    XCTAssertNil([formatter dateComponentsForPlainText:@"test8"]);
    
    OCMVerify([classMock date]);
    [mockedFormatter verify];
}

@end
