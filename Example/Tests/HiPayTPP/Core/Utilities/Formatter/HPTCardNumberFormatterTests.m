//
//  HPTCardNumberFormatterTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 05/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTCardNumberFormatter.h>
#import <HiPayTPP/HPTCardNumberFormatter_Private.h>

@interface HPTCardNumberFormatterTests : XCTestCase
{
    OCMockObject *mockedFormatter;
    HPTCardNumberFormatter *formatter;
}

@end

@implementation HPTCardNumberFormatterTests

- (void)setUp {
    [super setUp];

    mockedFormatter = [OCMockObject partialMockForObject:[[HPTCardNumberFormatter alloc] init]];
    formatter = (HPTCardNumberFormatter *)mockedFormatter;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDigitsOnlyNumberForPlainTextNumber
{
    XCTAssertEqualObjects([formatter digitsOnlyNumberForPlainTextNumber:@"4111 1111 1111 1111"], @"4111111111111111");
    XCTAssertEqualObjects([formatter digitsOnlyNumberForPlainTextNumber:@"4111"], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyNumberForPlainTextNumber:@" 4111 "], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyNumberForPlainTextNumber:@" 41 11 "], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyNumberForPlainTextNumber:@" 41a11 "], @"4111");
}

- (void)testPaymentProductCodeForPlainTextNumber
{
    [[[mockedFormatter expect] andReturn:@"411111111111"] digitsOnlyNumberForPlainTextNumber:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"400000000000"] digitsOnlyNumberForPlainTextNumber:@"visa2"];
    [[[mockedFormatter expect] andReturn:@"4111113333333"] digitsOnlyNumberForPlainTextNumber:@"visa3"];
    [[[mockedFormatter expect] andReturn:@"53999999999999"] digitsOnlyNumberForPlainTextNumber:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"5105105105105"] digitsOnlyNumberForPlainTextNumber:@"mastercard2"];
    [[[mockedFormatter expect] andReturn:@"51051051051051"] digitsOnlyNumberForPlainTextNumber:@"mastercard3"];
    [[[mockedFormatter expect] andReturn:@"675941110000"] digitsOnlyNumberForPlainTextNumber:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"670300000000"] digitsOnlyNumberForPlainTextNumber:@"maestro2"];
    [[[mockedFormatter expect] andReturn:@"378282246310"] digitsOnlyNumberForPlainTextNumber:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"371449635398"] digitsOnlyNumberForPlainTextNumber:@"amex2"];
    [[[mockedFormatter expect] andReturn:@"3056930902"] digitsOnlyNumberForPlainTextNumber:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"385200000"] digitsOnlyNumberForPlainTextNumber:@"diners2"];
    
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"visa1"], HPTPaymentProductCodeVisa);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"visa2"], HPTPaymentProductCodeVisa);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"visa3"], HPTPaymentProductCodeVisa);
    
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"mastercard1"], HPTPaymentProductCodeMasterCard);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"mastercard2"], HPTPaymentProductCodeMasterCard);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"mastercard3"], HPTPaymentProductCodeMasterCard);
    
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"maestro1"], HPTPaymentProductCodeMaestro);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"maestro2"], HPTPaymentProductCodeMaestro);
    
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"amex1"], HPTPaymentProductCodeAmericanExpress);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"amex2"], HPTPaymentProductCodeAmericanExpress);
    
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"diners1"], HPTPaymentProductCodeDiners);
    XCTAssertEqual([formatter paymentProductCodeForPlainTextNumber:@"diners2"], HPTPaymentProductCodeDiners);
    
    [mockedFormatter verify];
}

@end
