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
    
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyNumberForPlainTextNumber:@"dinersOrAmex"];
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa1"], @[HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa2"], @[HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa3"], @[HPTPaymentProductCodeVisa]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard1"], @[HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard2"], @[HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard3"], @[HPTPaymentProductCodeMasterCard]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"maestro1"], @[HPTPaymentProductCodeMaestro]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"maestro2"], @[HPTPaymentProductCodeMaestro]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"amex1"], @[HPTPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"amex2"], @[HPTPaymentProductCodeAmericanExpress]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"diners1"], @[HPTPaymentProductCodeDiners]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"diners2"], @[HPTPaymentProductCodeDiners]);
    
    NSArray *result = @[HPTPaymentProductCodeDiners, HPTPaymentProductCodeAmericanExpress];
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"dinersOrAmex"], result);
    
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

- (void)testIsValidForPaymentProductCode
{
    NSString *digits = @"54645";
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyNumberForPlainTextNumber:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertTrue([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];


    [[[mockedFormatter expect] andReturn:digits] digitsOnlyNumberForPlainTextNumber:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeMasterCard]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];

    
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyNumberForPlainTextNumber:@"number"];
    [[[mockedFormatter expect] andReturnValue:@NO] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
    
    
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyNumberForPlainTextNumber:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@NO] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
}

- (void)testFormatPlainTextNumber
{
    XCTAssertEqualObjects(@"5", [formatter formatPlainTextNumber:@"5" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"53", [formatter formatPlainTextNumber:@"53" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"539", [formatter formatPlainTextNumber:@"539" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399", [formatter formatPlainTextNumber:@"5399" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9", [formatter formatPlainTextNumber:@"53999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 99", [formatter formatPlainTextNumber:@"5399 99" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 999", [formatter formatPlainTextNumber:@"5399 999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999", [formatter formatPlainTextNumber:@"5399 9999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9", [formatter formatPlainTextNumber:@"5399 99999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 99", [formatter formatPlainTextNumber:@"5399 9999 99" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 999", [formatter formatPlainTextNumber:@"5399 9999 999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9999", [formatter formatPlainTextNumber:@"5399 9999 9999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9999 9", [formatter formatPlainTextNumber:@"5399 9999 99999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9999 99", [formatter formatPlainTextNumber:@"5399 9999 9999 99" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9999 999", [formatter formatPlainTextNumber:@"5399 9999 9999 999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"5399 9999 9999 9999", [formatter formatPlainTextNumber:@"5399 9999 9999 9999" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    
    XCTAssertEqualObjects(@"4111 1111 1111 1111", [formatter formatPlainTextNumber:@"4111111111111111" forPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects(@"411", [formatter formatPlainTextNumber:@"411" forPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects(@"4111 1111 1", [formatter formatPlainTextNumber:@"4111 11111" forPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects(@"4111 1", [formatter formatPlainTextNumber:@"41111" forPaymentProductCode:HPTPaymentProductCodeVisa]);

    XCTAssertEqualObjects(@"4111 1111 1111 1111", [formatter formatPlainTextNumber:@"4111111111111111" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"411", [formatter formatPlainTextNumber:@"411" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"4111 1111 1", [formatter formatPlainTextNumber:@"4111 11111" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"4111 1111 11", [formatter formatPlainTextNumber:@"4111 111111" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(@"4111 1", [formatter formatPlainTextNumber:@"41111" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    
    XCTAssertEqualObjects(@"3782 822463 10005", [formatter formatPlainTextNumber:@"378282246310005" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects(@"3782", [formatter formatPlainTextNumber:@"3782" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects(@"378", [formatter formatPlainTextNumber:@"378" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects(@"3782 8", [formatter formatPlainTextNumber:@"37828" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);

    XCTAssertEqualObjects(@"3056 930902 5904", [formatter formatPlainTextNumber:@"30569309025904" forPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertEqualObjects(@"3056 930902 59045", [formatter formatPlainTextNumber:@"305693090259045" forPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertEqualObjects(@"3056 9", [formatter formatPlainTextNumber:@"30569" forPaymentProductCode:HPTPaymentProductCodeDiners]);
    
    XCTAssertEqualObjects(@"6703 0000 0000 0000 3", [formatter formatPlainTextNumber:@"67030000000000003" forPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertEqualObjects(@"6703 0000 0000 0000", [formatter formatPlainTextNumber:@"6703000000000000" forPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertEqualObjects(@"6703", [formatter formatPlainTextNumber:@"6703" forPaymentProductCode:HPTPaymentProductCodeMaestro]);
    
}

@end
