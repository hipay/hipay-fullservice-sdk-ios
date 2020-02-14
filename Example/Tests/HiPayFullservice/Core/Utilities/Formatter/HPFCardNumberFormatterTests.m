//
//  HPFCardNumberFormatterTests.m
//  HiPayFullservice
//
//  Created by HiPay on 05/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFCardNumberFormatter.h>
#import <HiPayFullservice/HPFCardNumberFormatter_Private.h>

@interface HPFCardNumberFormatterTests : XCTestCase
{
    OCMockObject *mockedFormatter;
    HPFCardNumberFormatter *formatter;
}

@end

@implementation HPFCardNumberFormatterTests

- (void)setUp {
    [super setUp];

    mockedFormatter = [OCMockObject partialMockForObject:[[HPFCardNumberFormatter alloc] init]];
    formatter = (HPFCardNumberFormatter *)mockedFormatter;
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
    
    
    XCTAssertTrue([formatter plainTextNumber:@"visa1" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeVisa]);
    XCTAssertFalse([formatter plainTextNumber:@"visa2" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard1" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeMasterCard]);
    XCTAssertFalse([formatter plainTextNumber:@"mastercard2" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro1" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeMaestro]);
    XCTAssertFalse([formatter plainTextNumber:@"maestro2" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"amex1" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeAmericanExpress]);
    XCTAssertFalse([formatter plainTextNumber:@"amex2" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"diners1" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeDiners]);
    XCTAssertFalse([formatter plainTextNumber:@"diners2" reachesMaxLengthForPaymentProductCode:HPFPaymentProductCodeDiners]);

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
    [[[mockedFormatter expect] andReturn:@"6766000000000"] digitsOnlyFromPlainText:@"maestro2"];
    
    [[[mockedFormatter expect] andReturn:@"67030000000000003"] digitsOnlyFromPlainText:@"bcmc1"];
    
    [[[mockedFormatter expect] andReturn:@"378282246310"] digitsOnlyFromPlainText:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"371449635398"] digitsOnlyFromPlainText:@"amex2"];
    
    [[[mockedFormatter expect] andReturn:@"3056930902"] digitsOnlyFromPlainText:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"385200000"] digitsOnlyFromPlainText:@"diners2"];
    
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"dinersOrAmex"];
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa1"], [NSSet setWithObject:HPFPaymentProductCodeVisa]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa2"], [NSSet setWithObject:HPFPaymentProductCodeVisa]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"visa3"], [NSSet setWithObject:HPFPaymentProductCodeVisa]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard1"], [NSSet setWithObject:HPFPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard2"], [NSSet setWithObject:HPFPaymentProductCodeMasterCard]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"mastercard3"], [NSSet setWithObject:HPFPaymentProductCodeMasterCard]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"maestro1"], [NSSet setWithObject:HPFPaymentProductCodeMaestro]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"maestro2"], [NSSet setWithObject:HPFPaymentProductCodeMaestro]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"bcmc1"], [NSSet setWithObject:HPFPaymentProductCodeBCMC]);

    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"amex1"], [NSSet setWithObject:HPFPaymentProductCodeAmericanExpress]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"amex2"], [NSSet setWithObject:HPFPaymentProductCodeAmericanExpress]);
    
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"diners1"], [NSSet setWithObject:HPFPaymentProductCodeDiners]);
    XCTAssertEqualObjects([formatter paymentProductCodesForPlainTextNumber:@"diners2"], [NSSet setWithObject:HPFPaymentProductCodeDiners]);
    
    NSSet *result = [NSSet setWithObjects:HPFPaymentProductCodeDiners, HPFPaymentProductCodeAmericanExpress, nil];
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
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPFPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:[NSSet setWithObject:HPFPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertTrue([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPFPaymentProductCodeVisa]);
    
    [mockedFormatter verify];


    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPFPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:[NSSet setWithObject:HPFPaymentProductCodeMasterCard]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPFPaymentProductCodeVisa]);
    
    [mockedFormatter verify];

    
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@NO] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPFPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@YES] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:[NSSet setWithObject:HPFPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPFPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:digits] digitsOnlyFromPlainText:@"number"];
    [[[mockedFormatter expect] andReturnValue:@YES] plainTextNumber:@"number" hasValidLengthForPaymentProductCode:HPFPaymentProductCodeVisa];
    [[[mockedFormatter expect] andReturnValue:@NO] luhnCheck:digits];
    [[[mockedFormatter expect] andReturn:[NSSet setWithObject:HPFPaymentProductCodeVisa]] paymentProductCodesForPlainTextNumber:@"number"];
    
    XCTAssertFalse([formatter plainTextNumber:@"number" isValidForPaymentProductCode:HPFPaymentProductCodeVisa]);
    
    [mockedFormatter verify];
}

- (void)testFormatPlainTextNumber
{
    NSAttributedString *result;
    
    // MasterCard
    
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"5392" forPaymentProductCode:HPFPaymentProductCodeMasterCard] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"5125654789874565" forPaymentProductCode:HPFPaymentProductCodeMasterCard];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    
    // Visa
    
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"5392" forPaymentProductCode:HPFPaymentProductCodeVisa] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"5125654789874565" forPaymentProductCode:HPFPaymentProductCodeVisa];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    
    // American Express
    
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"3756" forPaymentProductCode:HPFPaymentProductCodeAmericanExpress] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"378282246310005" forPaymentProductCode:HPFPaymentProductCodeAmericanExpress];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:9 effectiveRange:nil].allKeys.firstObject);
    
    // Maestro
    
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"6703" forPaymentProductCode:HPFPaymentProductCodeMaestro] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"67030000000000003" forPaymentProductCode:HPFPaymentProductCodeMaestro];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:7 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:11 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:15 effectiveRange:nil].allKeys.firstObject);
    
    // Diners
    
    XCTAssertEqualObjects(NSKernAttributeName, [[formatter formatPlainTextNumber:@"3056" forPaymentProductCode:HPFPaymentProductCodeDiners] attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    
    result = [formatter formatPlainTextNumber:@"305693090259045" forPaymentProductCode:HPFPaymentProductCodeDiners];
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:3 effectiveRange:nil].allKeys.firstObject);
    XCTAssertEqualObjects(NSKernAttributeName, [result attributesAtIndex:9 effectiveRange:nil].allKeys.firstObject);

}

- (void)testIsInRangeForPaymentProductCode
{
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"amex1"];
    [[[mockedFormatter expect] andReturn:@"37"] digitsOnlyFromPlainText:@"amex2"];
    [[[mockedFormatter expect] andReturn:@"370"] digitsOnlyFromPlainText:@"amex3"];
    XCTAssertFalse([formatter plainTextNumber:@"amex1" isInRangeForPaymentProductCode:HPFPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"amex2" isInRangeForPaymentProductCode:HPFPaymentProductCodeAmericanExpress]);
    XCTAssertTrue([formatter plainTextNumber:@"amex3" isInRangeForPaymentProductCode:HPFPaymentProductCodeAmericanExpress]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"5"] digitsOnlyFromPlainText:@"mastercard1"];
    [[[mockedFormatter expect] andReturn:@"51"] digitsOnlyFromPlainText:@"mastercard2"];
    [[[mockedFormatter expect] andReturn:@"516"] digitsOnlyFromPlainText:@"mastercard3"];
    XCTAssertFalse([formatter plainTextNumber:@"mastercard1" isInRangeForPaymentProductCode:HPFPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard2" isInRangeForPaymentProductCode:HPFPaymentProductCodeMasterCard]);
    XCTAssertTrue([formatter plainTextNumber:@"mastercard3" isInRangeForPaymentProductCode:HPFPaymentProductCodeMasterCard]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@""] digitsOnlyFromPlainText:@"visa1"];
    [[[mockedFormatter expect] andReturn:@"4"] digitsOnlyFromPlainText:@"visa2"];
    [[[mockedFormatter expect] andReturn:@"411111"] digitsOnlyFromPlainText:@"visa3"];
    XCTAssertFalse([formatter plainTextNumber:@"visa1" isInRangeForPaymentProductCode:HPFPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"visa2" isInRangeForPaymentProductCode:HPFPaymentProductCodeVisa]);
    XCTAssertTrue([formatter plainTextNumber:@"visa3" isInRangeForPaymentProductCode:HPFPaymentProductCodeVisa]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"5"] digitsOnlyFromPlainText:@"maestro1"];
    [[[mockedFormatter expect] andReturn:@"639"] digitsOnlyFromPlainText:@"maestro2"];
    [[[mockedFormatter expect] andReturn:@"679"] digitsOnlyFromPlainText:@"maestro3"];
    XCTAssertFalse([formatter plainTextNumber:@"maestro1" isInRangeForPaymentProductCode:HPFPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro2" isInRangeForPaymentProductCode:HPFPaymentProductCodeMaestro]);
    XCTAssertTrue([formatter plainTextNumber:@"maestro3" isInRangeForPaymentProductCode:HPFPaymentProductCodeMaestro]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"4"] digitsOnlyFromPlainText:@"bcmc1"];
    [[[mockedFormatter expect] andReturn:@"561400"] digitsOnlyFromPlainText:@"bcmc2"];
    [[[mockedFormatter expect] andReturn:@"479658"] digitsOnlyFromPlainText:@"bcmc3"];
    XCTAssertFalse([formatter plainTextNumber:@"bcmc1" isInRangeForPaymentProductCode:HPFPaymentProductCodeBCMC]);
    XCTAssertTrue([formatter plainTextNumber:@"bcmc2" isInRangeForPaymentProductCode:HPFPaymentProductCodeBCMC]);
    XCTAssertTrue([formatter plainTextNumber:@"bcmc3" isInRangeForPaymentProductCode:HPFPaymentProductCodeBCMC]);
    [mockedFormatter verify];
    
    [[[mockedFormatter expect] andReturn:@"3"] digitsOnlyFromPlainText:@"diners1"];
    [[[mockedFormatter expect] andReturn:@"38"] digitsOnlyFromPlainText:@"diners2"];
    [[[mockedFormatter expect] andReturn:@"398776"] digitsOnlyFromPlainText:@"diners3"];
    XCTAssertFalse([formatter plainTextNumber:@"diners1" isInRangeForPaymentProductCode:HPFPaymentProductCodeDiners]);
    XCTAssertTrue([formatter plainTextNumber:@"diners2" isInRangeForPaymentProductCode:HPFPaymentProductCodeDiners]);
    XCTAssertTrue([formatter plainTextNumber:@"diners3" isInRangeForPaymentProductCode:HPFPaymentProductCodeDiners]);
    [mockedFormatter verify];
}

@end
