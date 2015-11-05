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

- (void)testReachesMaxLengthForPaymentProductCode
{
    [[[mockedFormatter expect] andReturn:@"4111111111111111"] digitsOnlyNumberForPlainTextNumber:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyNumberForPlainTextNumber:@"visa2"];
    
    [[[mockedFormatter expect] andReturn:@"4111111111111111"] digitsOnlyNumberForPlainTextNumber:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyNumberForPlainTextNumber:@"mastercard2"];
    
    [[[mockedFormatter expect] andReturn:@"6703000000000000356"] digitsOnlyNumberForPlainTextNumber:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"67030000000000003"] digitsOnlyNumberForPlainTextNumber:@"maestro2"];
    
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyNumberForPlainTextNumber:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"41111111111111"] digitsOnlyNumberForPlainTextNumber:@"amex2"];
    
    [[[mockedFormatter expect] andReturn:@"305693090259045"] digitsOnlyNumberForPlainTextNumber:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"30569309025904"] digitsOnlyNumberForPlainTextNumber:@"diners2"];
    
    
    XCTAssertTrue([formatter plainTextNumber:@"visa1" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertFalse([formatter plainTextNumber:@"visa2" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard1" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertFalse([formatter plainTextNumber:@"mastercard2" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro1" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertFalse([formatter plainTextNumber:@"maestro2" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"amex1" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertFalse([formatter plainTextNumber:@"amex2" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"diners1" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertFalse([formatter plainTextNumber:@"diners2" reachesMaxLengthForPaymentProductCode:HPTPaymentProductCodeDiners]);

    [mockedFormatter verify];
}

- (void)testIsValidForPaymentProductCode
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

- (void)testLuhnCheck
{
    XCTAssertTrue([formatter luhnCheck:@"4111111111111111"]);
    XCTAssertFalse([formatter luhnCheck:@"4111111111111110"]);
    XCTAssertTrue([formatter luhnCheck:@"378282246310005"]);
    XCTAssertTrue([formatter luhnCheck:@"371449635398431"]);
    XCTAssertTrue([formatter luhnCheck:@"5610591081018250"]);
    XCTAssertTrue([formatter luhnCheck:@"3530111333300000"]);
    XCTAssertTrue([formatter luhnCheck:@"5019717010103742"]);
    XCTAssertTrue([formatter luhnCheck:@"6331101999990016"]);
    XCTAssertFalse([formatter luhnCheck:@"6331101999090016"]);
    XCTAssertFalse([formatter luhnCheck:@"378282246300051"]);
    XCTAssertFalse([formatter luhnCheck:@"378822463100054"]);
}

- (void)testHasValidLengthForPaymentProductCode
{
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndex:16]] cardNumberLengthForPaymentProductCode:@"productCode1"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndex:16]] cardNumberLengthForPaymentProductCode:@"productCode1"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndex:16]] cardNumberLengthForPaymentProductCode:@"productCode1"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(15, 3)]] cardNumberLengthForPaymentProductCode:@"productCode2"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(15, 3)]] cardNumberLengthForPaymentProductCode:@"productCode2"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(15, 3)]] cardNumberLengthForPaymentProductCode:@"productCode2"];
    [[[mockedFormatter expect] andReturn:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(15, 3)]] cardNumberLengthForPaymentProductCode:@"productCode2"];

    XCTAssertTrue([formatter plainTextNumber:@"4111111111111111" hasValidLengthForPaymentProductCode:@"productCode1"]);
    XCTAssertFalse([formatter plainTextNumber:@"41111111111111111" hasValidLengthForPaymentProductCode:@"productCode1"]);
    XCTAssertFalse([formatter plainTextNumber:@"411111111111111" hasValidLengthForPaymentProductCode:@"productCode1"]);

    XCTAssertTrue([formatter plainTextNumber:@"411111111111111" hasValidLengthForPaymentProductCode:@"productCode2"]);
    XCTAssertTrue([formatter plainTextNumber:@"4111111111111111" hasValidLengthForPaymentProductCode:@"productCode2"]);
    XCTAssertTrue([formatter plainTextNumber:@"41111111111111111" hasValidLengthForPaymentProductCode:@"productCode2"]);
    XCTAssertFalse([formatter plainTextNumber:@"411111111111111111" hasValidLengthForPaymentProductCode:@"productCode2"]);

    
    [mockedFormatter verify];
}

@end
