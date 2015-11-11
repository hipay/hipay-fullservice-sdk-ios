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

- (void)testReachesMaxLengthForPaymentProductCode
{
    [[[mockedFormatter expect] andReturn:@"4111111111111111"] digitsOnlyFromPlainText:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyFromPlainText:@"visa2"];
    
    [[[mockedFormatter expect] andReturn:@"4111111111111111"] digitsOnlyFromPlainText:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyFromPlainText:@"mastercard2"];
    
    [[[mockedFormatter expect] andReturn:@"6703000000000000356"] digitsOnlyFromPlainText:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"67030000000000003"] digitsOnlyFromPlainText:@"maestro2"];
    
    [[[mockedFormatter expect] andReturn:@"411111111111111"] digitsOnlyFromPlainText:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"41111111111111"] digitsOnlyFromPlainText:@"amex2"];
    
    [[[mockedFormatter expect] andReturn:@"305693090259045"] digitsOnlyFromPlainText:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"30569309025904"] digitsOnlyFromPlainText:@"diners2"];
    
    
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
    [[[mockedFormatter expect] andReturn:@"411111111111"] digitsOnlyFromPlainText:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"400000000000"] digitsOnlyFromPlainText:@"visa2"];
    [[[mockedFormatter expect] andReturn:@"4111113333333"] digitsOnlyFromPlainText:@"visa3"];
    
    [[[mockedFormatter expect] andReturn:@"53999999999999"] digitsOnlyFromPlainText:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"5105105105105"] digitsOnlyFromPlainText:@"mastercard2"];
    [[[mockedFormatter expect] andReturn:@"51051051051051"] digitsOnlyFromPlainText:@"mastercard3"];
    
    [[[mockedFormatter expect] andReturn:@"675941110000"] digitsOnlyFromPlainText:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"670300000000"] digitsOnlyFromPlainText:@"maestro2"];
    
    [[[mockedFormatter expect] andReturn:@"378282246310"] digitsOnlyFromPlainText:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"371449635398"] digitsOnlyFromPlainText:@"amex2"];
    
    [[[mockedFormatter expect] andReturn:@"3056930902"] digitsOnlyFromPlainText:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"385200000"] digitsOnlyFromPlainText:@"diners2"];
    
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"dinersOrAmex"];
    
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
    XCTAssertTrue([formatter plainTextNumber:@"4111111111111111" hasValidLengthForPaymentProductCode:@"visa"]);
    XCTAssertFalse([formatter plainTextNumber:@"41111111111111111" hasValidLengthForPaymentProductCode:@"visa"]);
    XCTAssertFalse([formatter plainTextNumber:@"411111111111111" hasValidLengthForPaymentProductCode:@"visa"]);

    XCTAssertTrue([formatter plainTextNumber:@"411111111111111" hasValidLengthForPaymentProductCode:@"maestro"]);
    XCTAssertTrue([formatter plainTextNumber:@"4111111111111111" hasValidLengthForPaymentProductCode:@"maestro"]);
    XCTAssertTrue([formatter plainTextNumber:@"41111111111111111" hasValidLengthForPaymentProductCode:@"maestro"]);
    XCTAssertFalse([formatter plainTextNumber:@"41111111111111111111" hasValidLengthForPaymentProductCode:@"maestro"]);
    
    [mockedFormatter verify];
}

- (void)testIsValidForPaymentProductCode
{
    NSString *digits = @"54645";
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertTrue([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];


    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeMasterCard]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];

    
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@NO] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPTPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@NO] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:@[HPTPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPTPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
}

- (void)testFormatPlainTextNumber
{
    NSAttributedString *result;
    
    // MasterCard
    
    XCTAssertEqualObjects([[NSAttributedString alloc] initWithString:@"539"], [formatter formatPlainTextNumber:@"539" forPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"5392" forPaymentProductCode:HPTPaymentProductCodeMasterCard] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"5125654789874565" forPaymentProductCode:HPTPaymentProductCodeMasterCard];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    
    // Visa
    
    XCTAssertEqualObjects([[NSAttributedString alloc] initWithString:@"539"], [formatter formatPlainTextNumber:@"539" forPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"5392" forPaymentProductCode:HPTPaymentProductCodeVisa] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"5125654789874565" forPaymentProductCode:HPTPaymentProductCodeVisa];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    
    // American Express
    
    XCTAssertEqualObjects([[NSAttributedString alloc] initWithString:@"375"], [formatter formatPlainTextNumber:@"375" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"3756" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"378282246310005" forPaymentProductCode:HPTPaymentProductCodeAmericanExpress];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:9 effectiveRange:nil].allKeys.firstObject);
    
    // Maestro
    
    XCTAssertEqualObjects([[NSAttributedString alloc] initWithString:@"670"], [formatter formatPlainTextNumber:@"670" forPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"6703" forPaymentProductCode:HPTPaymentProductCodeMaestro] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"67030000000000003" forPaymentProductCode:HPTPaymentProductCodeMaestro];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:15 effectiveRange:nil].allKeys.firstObject);
    
    // Diners
    
    XCTAssertEqualObjects([[NSAttributedString alloc] initWithString:@"305"], [formatter formatPlainTextNumber:@"305" forPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"3056" forPaymentProductCode:HPTPaymentProductCodeDiners] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"305693090259045" forPaymentProductCode:HPTPaymentProductCodeDiners];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:9 effectiveRange:nil].allKeys.firstObject);

}

- (void)testIsInRangeForPaymentProductCode
{
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"37"] digitsOnlyFromPlainText:@"amex2"];
    [[[mockedFormatter expect] andReturn:@"370"] digitsOnlyFromPlainText:@"amex3"];
    XCTAssertFalse([formatter plainTextNumber:@"amex1" isInRangeForPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"amex2" isInRangeForPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"amex3" isInRangeForPaymentProductCode:HPTPaymentProductCodeAmericanExpress]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"5"] digitsOnlyFromPlainText:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"51"] digitsOnlyFromPlainText:@"mastercard2"];
    [[[mockedFormatter expect] andReturn:@"516"] digitsOnlyFromPlainText:@"mastercard3"];
    XCTAssertFalse([formatter plainTextNumber:@"mastercard1" isInRangeForPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard2" isInRangeForPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard3" isInRangeForPaymentProductCode:HPTPaymentProductCodeMasterCard]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@""] digitsOnlyFromPlainText:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"4"] digitsOnlyFromPlainText:@"visa2"];
    [[[mockedFormatter expect] andReturn:@"411111"] digitsOnlyFromPlainText:@"visa3"];
    XCTAssertFalse([formatter plainTextNumber:@"visa1" isInRangeForPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"visa2" isInRangeForPaymentProductCode:HPTPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"visa3" isInRangeForPaymentProductCode:HPTPaymentProductCodeVisa]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"5"] digitsOnlyFromPlainText:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"59"] digitsOnlyFromPlainText:@"maestro2"];
    [[[mockedFormatter expect] andReturn:@"596865"] digitsOnlyFromPlainText:@"maestro3"];
    XCTAssertFalse([formatter plainTextNumber:@"maestro1" isInRangeForPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro2" isInRangeForPaymentProductCode:HPTPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro3" isInRangeForPaymentProductCode:HPTPaymentProductCodeMaestro]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"38"] digitsOnlyFromPlainText:@"diners2"];
    [[[mockedFormatter expect] andReturn:@"398776"] digitsOnlyFromPlainText:@"diners3"];
    XCTAssertFalse([formatter plainTextNumber:@"diners1" isInRangeForPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertTrue([formatter plainTextNumber:@"diners2" isInRangeForPaymentProductCode:HPTPaymentProductCodeDiners]);
    XCTAssertTrue([formatter plainTextNumber:@"diners3" isInRangeForPaymentProductCode:HPTPaymentProductCodeDiners]);
    [mockedFormatter verify];
}

@end
