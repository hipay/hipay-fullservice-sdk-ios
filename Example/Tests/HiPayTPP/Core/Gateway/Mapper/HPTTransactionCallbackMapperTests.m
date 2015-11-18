//
//  HPTTransactionCallbackMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 18/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <HiPayTPP/HPTTransactionCallbackMapper.h>

@interface HPTTransactionCallbackMapperTests : XCTestCase

@end

@implementation HPTTransactionCallbackMapperTests

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"reference": @"446780277416",
                              @"state": @"completed",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTTransactionCallbackMapper alloc] initWithRawData:rawData]];
    HPTTransactionCallbackMapper *mapper = (HPTTransactionCallbackMapper *)mockedMapper;


    [[[mockedMapper expect] andReturn:@"reference ex"] getStringForKey:@"reference"];
    [[[mockedMapper expect] andReturnValue:@(HPTTransactionStateCompleted)] getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPTTransactionStateError allValues:[HPTTransactionMapper transactionStateMapping]];
    [[[mockedMapper expect] andReturnValue:@(HPTTransactionStatusAuthenticationRequested)] getIntegerForKey:@"status"];
    [[[mockedMapper expect] andReturnValue:@(YES)] getBoolForKey:@"test"];
    [[[mockedMapper expect] andReturn:@"ip ex"] getStringForKey:@"ip"];
    [[[mockedMapper expect] andReturn:@"country ex"] getStringForKey:@"country"];
    [[[mockedMapper expect] andReturn:@(HPTAVSResultAddressMatch)] getEnumCharForKey:@"avscheck"];
    [[[mockedMapper expect] andReturn:@(HPTCVCResultMissing)] getEnumCharForKey:@"cvccheck"];
    [[[mockedMapper expect] andReturn:@"mastercard"] getStringForKey:@"pp"];
    [[[mockedMapper expect] andReturn:@"cdata1 ex"] getStringForKey:@"cdata1"];
    [[[mockedMapper expect] andReturn:@"cdata2 ex"] getStringForKey:@"cdata2"];
    [[[mockedMapper expect] andReturn:@"cdata3 ex"] getStringForKey:@"cdata3"];
    [[[mockedMapper expect] andReturn:@"cdata4 ex"] getStringForKey:@"cdata4"];
    [[[mockedMapper expect] andReturn:@"cdata5 ex"] getStringForKey:@"cdata5"];
    [[[mockedMapper expect] andReturn:@"cdata6 ex"] getStringForKey:@"cdata6"];
    [[[mockedMapper expect] andReturn:@"cdata7 ex"] getStringForKey:@"cdata7"];
    [[[mockedMapper expect] andReturn:@"cdata8 ex"] getStringForKey:@"cdata8"];
    [[[mockedMapper expect] andReturn:@"cdata9 ex"] getStringForKey:@"cdata9"];
    [[[mockedMapper expect] andReturn:@"cdata10 ex"] getStringForKey:@"cdata10"];
    [[[mockedMapper expect] andReturn:@"orderid ex"] getStringForKey:@"orderid"];
    [[[mockedMapper expect] andReturn:@"lang ex"] getStringForKey:@"lang"];
    [[[mockedMapper expect] andReturn:@"email ex"] getStringForKey:@"email"];
    [[[mockedMapper expect] andReturn:@"cid ex"] getStringForKey:@"cid"];
    [[[mockedMapper expect] andReturnValue:@(100)] getIntegerForKey:@"score"];
    [[[mockedMapper expect] andReturn:@(100)] getObjectForKey:@"score"];
    
    [[[mockedMapper expect] andReturnValue:@(HPTFraudScreeningResultChallenged)] getIntegerEnumValueWithKey:@"fraud" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper resultMapping]];
    [[[mockedMapper expect] andReturnValue:@(HPTFraudScreeningReviewPending)] getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper reviewMapping]];
    
    [[[mockedMapper expect] andReturn:@(HPTThreeDSecureEnrollmentStatusAuthenticationAvailable)] getEnumCharForKey:@"veres"];
    [[[mockedMapper expect] andReturn:@(HPTThreeDSecureAuthenticationStatusSuccessful)] getEnumCharForKey:@"pares"];
    
    [[[mockedMapper expect] andReturn:@"cardtoken ex"] getStringForKey:@"cardtoken"];
    [[[mockedMapper expect] andReturn:@"cardpan ex"] getStringForKey:@"cardpan"];
    [[[mockedMapper expect] andReturn:@"cardbrand ex"] getStringForKey:@"cardbrand"];
    [[[mockedMapper expect] andReturn:@"cardcountry ex"] getStringForKey:@"cardcountry"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2015;
    dateComponents.month = 6;
    
    [[[mockedMapper expect] andReturn:dateComponents] getYearAndMonthForKey:@"cardexpiry"];

    
    HPTTransaction *object = mapper.mappedObject;
    
    XCTAssertEqual(object.state, HPTTransactionStateCompleted);
    
    XCTAssertEqualObjects(object.cdata1, @"cdata1 ex");
    XCTAssertEqualObjects(object.cdata2, @"cdata2 ex");
    XCTAssertEqualObjects(object.cdata3, @"cdata3 ex");
    XCTAssertEqualObjects(object.cdata4, @"cdata4 ex");
    XCTAssertEqualObjects(object.cdata5, @"cdata5 ex");
    XCTAssertEqualObjects(object.cdata6, @"cdata6 ex");
    XCTAssertEqualObjects(object.cdata7, @"cdata7 ex");
    XCTAssertEqualObjects(object.cdata8, @"cdata8 ex");
    XCTAssertEqualObjects(object.cdata9, @"cdata9 ex");
    XCTAssertEqualObjects(object.cdata10, @"cdata10 ex");
    
    XCTAssertEqualObjects(object.transactionReference, @"reference ex");
    XCTAssertEqual(object.status, HPTTransactionStatusAuthenticationRequested);
    XCTAssertEqual(object.test, YES);
    XCTAssertEqualObjects(object.ipAddress, @"ip ex");
    XCTAssertEqualObjects(object.ipCountry, @"country ex");
    XCTAssertEqual(object.avsResult, HPTAVSResultAddressMatch);
    XCTAssertEqual(object.cvcResult, HPTCVCResultMissing);

    
    XCTAssertEqualObjects(object.order.orderId, @"orderid ex");
    XCTAssertEqualObjects(object.order.language, @"lang ex");
    XCTAssertEqualObjects(object.order.email, @"email ex");
    XCTAssertEqualObjects(object.order.customerId, @"cid ex");

    
    XCTAssertEqual(object.fraudScreening.scoring, 100);
    XCTAssertEqual(object.fraudScreening.result, HPTFraudScreeningResultChallenged);
    XCTAssertEqual(object.fraudScreening.review, HPTFraudScreeningReviewPending);
    
    XCTAssertEqual(object.threeDSecure.enrollmentStatus, HPTThreeDSecureEnrollmentStatusAuthenticationAvailable);
    XCTAssertEqual(object.threeDSecure.authenticationStatus, HPTThreeDSecureAuthenticationStatusSuccessful);
    
    XCTAssertTrue([object.paymentMethod isKindOfClass:[HPTPaymentCardToken class]]);
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).token, @"cardtoken ex");
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).pan, @"cardpan ex");
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).brand, @"cardbrand ex");
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).country, @"cardcountry ex");
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).cardExpiryMonth, @(6));
    XCTAssertEqualObjects(((HPTPaymentCardToken *)object.paymentMethod).cardExpiryYear, @(2015));
    

    XCTAssertEqualObjects(object.paymentProduct, @"mastercard");
    
    
    
    [mockedMapper verify];
}


@end
