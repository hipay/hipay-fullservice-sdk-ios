//
//  HPFTransactionMapperTests.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>
#import <HiPayFullservice/HPFTransactionRelatedItemMapper+Private.h>

@interface HPFTransactionMapperTests : XCTestCase
{
    NSDictionary *threeDSecurePayload;
    HPFThreeDSecure *threeDSecure;
    NSDictionary *fraudScreeningPayload;
    HPFFraudScreening *fraudScreening;
    NSDictionary *orderPayload;
    HPFOrder *order;
    NSDictionary *paymentMethodPayload;
    HPFPaymentCardToken *paymentMethod;
    
    id threeDSecureClassMock;
    id fraudScreeningClassMock;
    id orderClassMock;
    id paymentMethodClassMock;
}

@end

@implementation HPFTransactionMapperTests

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
    
    XCTAssertNil([[HPFTransactionMapper alloc] initWithRawData:rawData]);
    
}

- (void)testTransactionStateMapping
{
    NSDictionary *mapping = @{@"completed": @(HPFTransactionStateCompleted),
                              @"forwarding": @(HPFTransactionStateForwarding),
                              @"pending": @(HPFTransactionStatePending),
                              @"declined": @(HPFTransactionStateDeclined),
                              @"error": @(HPFTransactionStateError)};
    
    XCTAssertEqualObjects([HPFTransactionMapper transactionStateMapping], mapping);
}

- (void)mock3DSecure
{
    threeDSecurePayload = @{};
    threeDSecure = [[HPFThreeDSecure alloc] init];
    
    OCMockObject *threeDSecureMockedMapper = [OCMockObject mockForClass:[HPFThreeDSecureMapper class]];
    [[[threeDSecureMockedMapper expect] andReturn:threeDSecure] mappedObject];
    
    threeDSecureClassMock = OCMClassMock([HPFThreeDSecureMapper class]);
    OCMStub([threeDSecureClassMock mapperWithRawData:threeDSecurePayload]).andReturn(threeDSecureMockedMapper);
}

- (void)mockFraudScreening
{
    fraudScreeningPayload = @{};
    fraudScreening = [[HPFFraudScreening alloc] init];
    
    OCMockObject *fraudScreeningMockedMapper = [OCMockObject mockForClass:[HPFFraudScreeningMapper class]];
    [[[fraudScreeningMockedMapper expect] andReturn:fraudScreening] mappedObject];
    
    fraudScreeningClassMock = OCMClassMock([HPFFraudScreeningMapper class]);
    OCMStub([fraudScreeningClassMock mapperWithRawData:fraudScreeningPayload]).andReturn(fraudScreeningMockedMapper);
}

- (void)mockOrder
{
    orderPayload = @{};
    order = [[HPFOrder alloc] init];
    
    OCMockObject *orderMockedMapper = [OCMockObject mockForClass:[HPFOrderMapper class]];
    [[[orderMockedMapper expect] andReturn:order] mappedObject];
    
    orderClassMock = OCMClassMock([HPFOrderMapper class]);
    OCMStub([orderClassMock mapperWithRawData:orderPayload]).andReturn(orderMockedMapper);
}

- (void)mockPaymentMethod
{
    paymentMethodPayload = @{};
    paymentMethod = [[HPFPaymentCardToken alloc] init];
    
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPFPaymentCardTokenMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethod] mappedObject];
    
    paymentMethodClassMock = OCMClassMock([HPFPaymentCardTokenMapper class]);
    OCMStub([paymentMethodClassMock mapperWithRawData:paymentMethodPayload]).andReturn(paymentMethodMockedMapper);
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"transactionReference": @"446780277416",
                              @"state": @"completed",
                              };
    
    // Class mock
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFTransactionMapper alloc] initWithRawData:rawData]];
    HPFTransactionMapper *mapper = (HPFTransactionMapper *)mockedMapper;
    
    // 3-D Secure mock
    [self mock3DSecure];
    [[[mockedMapper expect] andReturn:threeDSecurePayload] getDictionaryForKey:@"threeDSecure"];

    // Fraud screening mock
    [self mockFraudScreening];
    [[[mockedMapper expect] andReturn:fraudScreeningPayload] getDictionaryForKey:@"fraudScreening"];

    // Order mock
    [self mockOrder];
    [[[mockedMapper expect] andReturn:orderPayload] getDictionaryForKey:@"order"];
    
    // Payment method mock
    [self mockPaymentMethod];
    [[[mockedMapper expect] andReturn:paymentMethodPayload] getDictionaryForKey:@"paymentMethod"];
    
    // Tests
    HPFTransaction *object = [[HPFTransaction alloc] init];
    
    [[[mockedMapper expect] andReturn:object] mappedObjectWithTransactionRelatedItem:[OCMArg isKindOfClass:[HPFTransaction class]]];
    [[[mockedMapper expect] andReturnValue:@(HPFTransactionStateCompleted)] getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPFTransactionStateError allValues:[HPFTransactionMapper transactionStateMapping]];
    
    [[[mockedMapper expect] andReturn:@"cdata1 example"] getStringForKey:@"cdata1"];
    [[[mockedMapper expect] andReturn:@"cdata2 example"] getStringForKey:@"cdata2"];
    [[[mockedMapper expect] andReturn:@"cdata3 example"] getStringForKey:@"cdata3"];
    [[[mockedMapper expect] andReturn:@"cdata4 example"] getStringForKey:@"cdata4"];
    [[[mockedMapper expect] andReturn:@"cdata5 example"] getStringForKey:@"cdata5"];
    [[[mockedMapper expect] andReturn:@"cdata6 example"] getStringForKey:@"cdata6"];
    [[[mockedMapper expect] andReturn:@"cdata7 example"] getStringForKey:@"cdata7"];
    [[[mockedMapper expect] andReturn:@"cdata8 example"] getStringForKey:@"cdata8"];
    [[[mockedMapper expect] andReturn:@"cdata9 example"] getStringForKey:@"cdata9"];
    [[[mockedMapper expect] andReturn:@"cdata10 example"] getStringForKey:@"cdata10"];
    
    [[[mockedMapper expect] andReturn:@"reason test"] getStringForKey:@"reason"];
    [[[mockedMapper expect] andReturn:@"4"] getStringForKey:@"attemptId"];
    [[[mockedMapper expect] andReturn:@"597845645"] getStringForKey:@"referenceToPay"];
    [[[mockedMapper expect] andReturn:@"194.154.41.52"] getStringForKey:@"ipAddress"];
    [[[mockedMapper expect] andReturn:@"194.154.41.53"] getStringForKey:@"ipCountry"];
    [[[mockedMapper expect] andReturn:@"498745654785"] getStringForKey:@"deviceId"];
    [[[mockedMapper expect] andReturn:@"visa"] getStringForKey:@"paymentProduct"];
    
    [[[mockedMapper expect] andReturn:[NSURL URLWithString:@"https://www.example.com/forward"]] getURLForKey:@"forwardUrl"];
    
    [[[mockedMapper expect] andReturn:@(HPFAVSResultAddressMatch)] getEnumCharForKey:@"avsResult"];
    [[[mockedMapper expect] andReturn:@(HPFCVCResultMatch)] getEnumCharForKey:@"cvcResult"];
    [[[mockedMapper expect] andReturnValue:@(HPFECIMOTO)] getIntegerForKey:@"eci"];
    
    XCTAssertEqualObjects(mapper.mappedObject, object);
    XCTAssertEqualObjects(object.threeDSecure, threeDSecure);
    XCTAssertEqualObjects(object.fraudScreening, fraudScreening);
    XCTAssertEqualObjects(object.order, order);
    XCTAssertEqualObjects(object.paymentMethod, paymentMethod);
    XCTAssertEqual(object.state, HPFTransactionStateCompleted);
    
    XCTAssertEqualObjects(object.cdata1, @"cdata1 example");
    XCTAssertEqualObjects(object.cdata2, @"cdata2 example");
    XCTAssertEqualObjects(object.cdata3, @"cdata3 example");
    XCTAssertEqualObjects(object.cdata4, @"cdata4 example");
    XCTAssertEqualObjects(object.cdata5, @"cdata5 example");
    XCTAssertEqualObjects(object.cdata6, @"cdata6 example");
    XCTAssertEqualObjects(object.cdata7, @"cdata7 example");
    XCTAssertEqualObjects(object.cdata8, @"cdata8 example");
    XCTAssertEqualObjects(object.cdata9, @"cdata9 example");
    XCTAssertEqualObjects(object.cdata10, @"cdata10 example");
    
    XCTAssertEqualObjects(object.reason, @"reason test");
    XCTAssertEqualObjects(object.attemptId, @"4");
    XCTAssertEqualObjects(object.referenceToPay, @"597845645");
    XCTAssertEqualObjects(object.ipAddress, @"194.154.41.52");
    XCTAssertEqualObjects(object.ipCountry, @"194.154.41.53");
    XCTAssertEqualObjects(object.deviceId, @"498745654785");
    XCTAssertEqualObjects(object.paymentProduct, @"visa");
    
    XCTAssertEqualObjects(object.forwardUrl, [NSURL URLWithString:@"https://www.example.com/forward"]);

    XCTAssertEqual(object.avsResult, HPFAVSResultAddressMatch);
    XCTAssertEqual(object.cvcResult, HPFCVCResultMatch);
    XCTAssertEqual(object.eci, HPFECIMOTO);
    
    [mockedMapper verify];
    OCMVerify([threeDSecureClassMock mapperWithRawData:threeDSecurePayload]);
    OCMVerify([fraudScreeningClassMock mapperWithRawData:fraudScreeningPayload]);
    OCMVerify([orderClassMock mapperWithRawData:orderPayload]);
    OCMVerify([paymentMethodClassMock mapperWithRawData:paymentMethodPayload]);
}

@end
