//
//  HPTTransactionMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <HiPayTPP/HPTTransactionRelatedItemMapper+Private.h>

@interface HPTTransactionMapperTests : XCTestCase

@end

@implementation HPTTransactionMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"transactionReference": @"546748976",
                              };
    
    XCTAssertNil([[HPTTransactionMapper alloc] initWithRawData:rawData]);
    
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"transactionReference": @"446780277416",
                              @"state": @"completed",
                              };
    
    // Class mock
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTTransactionMapper alloc] initWithRawData:rawData]];
    HPTTransactionMapper *mapper = (HPTTransactionMapper *)mockedMapper;
    
    // 3-D Secure mock
    NSDictionary *threeDSecurePayload = @{};
    HPTThreeDSecure *threeDSecure = [[HPTThreeDSecure alloc] init];
    
    OCMockObject *threeDSecureMockedMapper = [OCMockObject mockForClass:[HPTThreeDSecureMapper class]];
    [[[threeDSecureMockedMapper expect] andReturn:threeDSecure] mappedObject];
    
    id threeDSecureClassMock = OCMClassMock([HPTThreeDSecureMapper class]);
    OCMStub([threeDSecureClassMock mapperWithRawData:threeDSecurePayload]).andReturn(threeDSecureMockedMapper);
    [[[mockedMapper expect] andReturn:threeDSecurePayload] getDictionaryForKey:@"threeDSecure"];
    
    // Fraud screening mock
    NSDictionary *fraudScreeningPayload = @{};
    HPTFraudScreening *fraudScreening = [[HPTFraudScreening alloc] init];
    
    OCMockObject *fraudScreeningMockedMapper = [OCMockObject mockForClass:[HPTFraudScreeningMapper class]];
    [[[fraudScreeningMockedMapper expect] andReturn:fraudScreening] mappedObject];
    
    id fraudScreeningClassMock = OCMClassMock([HPTFraudScreeningMapper class]);
    OCMStub([fraudScreeningClassMock mapperWithRawData:fraudScreeningPayload]).andReturn(fraudScreeningMockedMapper);
    [[[mockedMapper expect] andReturn:fraudScreeningPayload] getDictionaryForKey:@"fraudScreening"];
    
    // Order mock
    NSDictionary *orderPayload = @{};
    HPTOrder *order = [[HPTOrder alloc] init];
    
    OCMockObject *orderMockedMapper = [OCMockObject mockForClass:[HPTOrderMapper class]];
    [[[orderMockedMapper expect] andReturn:order] mappedObject];
    
    id orderClassMock = OCMClassMock([HPTOrderMapper class]);
    OCMStub([orderClassMock mapperWithRawData:orderPayload]).andReturn(orderMockedMapper);
    [[[mockedMapper expect] andReturn:orderPayload] getDictionaryForKey:@"order"];
    
    // Payment method mock
    NSDictionary *paymentMethodPayload = @{};
    HPTPaymentCardToken *paymentMethod = [[HPTPaymentCardToken alloc] init];
    
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPTPaymentCardTokenMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethod] mappedObject];
    
    id paymentMethodClassMock = OCMClassMock([HPTPaymentCardTokenMapper class]);
    OCMStub([paymentMethodClassMock mapperWithRawData:paymentMethodPayload]).andReturn(paymentMethodMockedMapper);
    [[[mockedMapper expect] andReturn:paymentMethodPayload] getDictionaryForKey:@"paymentMethod"];
    
    // Tests
    HPTTransaction *object = [[HPTTransaction alloc] init];
    
    [[[mockedMapper expect] andReturn:object] mappedObjectWithTransactionRelatedItem:[OCMArg isKindOfClass:[HPTTransaction class]]];
    

    
    
    XCTAssertEqualObjects(mapper.mappedObject, object);
    XCTAssertEqualObjects(object.threeDSecure, threeDSecure);
    XCTAssertEqualObjects(object.fraudScreening, fraudScreening);
    XCTAssertEqualObjects(object.order, order);
    XCTAssertEqualObjects(object.paymentMethod, paymentMethod);
    
    [mockedMapper verify];
}

@end
