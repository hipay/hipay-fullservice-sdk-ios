//
//  HPFOrderRequestSerializationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 14/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFOrderRequestSerializationMapper.h>
#import <HiPayFullservice/HPFAbstractSerializationMapper+Encode.h>
#import <HiPayFullservice/HPFOrderRelatedRequestSerializationMapper_Private.h>
#import <HiPayFullservice/NSMutableDictionary+Serialization.h>
#import <HiPayFullservice/HPFOrderRequestSerializationMapper_Private.h>
#import <HiPayFullservice/HPFCardTokenPaymentMethodRequest.h>
#import <HiPayFullservice/HPFCardTokenPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFQiwiWalletPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFIDealPaymentMethodRequestSerializationMapper.h>
#import <HiPayFullservice/HPFSepaDirectDebitPaymentMethodRequestSerializationMapper.h>

@interface HPFOrderRequestSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    HPFOrderRequest *request;
    
    OCMockObject *mockedMapper;
    HPFOrderRequestSerializationMapper *mapper;

    OCMockObject *mockedInitialSerializedRequest;
    NSMutableDictionary *initialSerializedRequest;

}

@end

@implementation HPFOrderRequestSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject partialMockForObject:[[HPFOrderRequest alloc] init]];
    request = (HPFOrderRequest *)mockedRequest;
    
    mockedMapper = [OCMockObject partialMockForObject:[[HPFOrderRequestSerializationMapper alloc] initWithRequest:request]];
    mapper = (HPFOrderRequestSerializationMapper *)mockedMapper;

    mockedInitialSerializedRequest = [OCMockObject partialMockForObject:[NSMutableDictionary dictionary]];
    initialSerializedRequest = (NSMutableDictionary *)mockedInitialSerializedRequest;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPaymentMethodSerializedRequestNil
{
    [[[mockedRequest expect] andReturn:nil] valueForKey:@"paymentMethod"];
    XCTAssertNil(mapper.paymentMethodSerializedRequest);
    [mockedRequest verify];
}

- (void)testPaymentMethodSerializedRequestCardTokenPaymentMethod
{
    OCMockObject *mockedPaymentMethodRequest = [OCMockObject partialMockForObject:[[HPFCardTokenPaymentMethodRequest alloc] init]];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPFCardTokenPaymentMethodRequestSerializationMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethodSerializedRequest] serializedRequest];
    
    id paymentMethodMapperClassMock = OCMClassMock([HPFCardTokenPaymentMethodRequestSerializationMapper class]);
    OCMStub([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]).andReturn(paymentMethodMockedMapper);
    
    [[[mockedRequest expect] andReturn:mockedPaymentMethodRequest] valueForKey:@"paymentMethod"];
    
    
    XCTAssertEqual([mapper paymentMethodSerializedRequest], paymentMethodSerializedRequest);
    
    
    OCMVerify([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]);
    [mockedRequest verify];
    [paymentMethodMockedMapper verify];
}

- (void)testPaymentMethodSerializedRequestQiwiWalletPaymentMethod
{
    OCMockObject *mockedPaymentMethodRequest = [OCMockObject partialMockForObject:[[HPFQiwiWalletPaymentMethodRequest alloc] init]];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPFQiwiWalletPaymentMethodRequestSerializationMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethodSerializedRequest] serializedRequest];
    
    id paymentMethodMapperClassMock = OCMClassMock([HPFQiwiWalletPaymentMethodRequestSerializationMapper class]);
    OCMStub([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]).andReturn(paymentMethodMockedMapper);
    
    [[[mockedRequest expect] andReturn:mockedPaymentMethodRequest] valueForKey:@"paymentMethod"];
    
    XCTAssertEqual([mapper paymentMethodSerializedRequest], paymentMethodSerializedRequest);
    
    OCMVerify([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]);
    [mockedRequest verify];
    [paymentMethodMockedMapper verify];
}

- (void)testPaymentMethodSerializedRequestIDealPaymentMethod
{
    OCMockObject *mockedPaymentMethodRequest = [OCMockObject partialMockForObject:[[HPFIDealPaymentMethodRequest alloc] init]];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPFIDealPaymentMethodRequestSerializationMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethodSerializedRequest] serializedRequest];
    
    id paymentMethodMapperClassMock = OCMClassMock([HPFIDealPaymentMethodRequestSerializationMapper class]);
    OCMStub([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]).andReturn(paymentMethodMockedMapper);
    
    [[[mockedRequest expect] andReturn:mockedPaymentMethodRequest] valueForKey:@"paymentMethod"];
    
    XCTAssertEqual([mapper paymentMethodSerializedRequest], paymentMethodSerializedRequest);
    
    OCMVerify([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]);
    [mockedRequest verify];
    [paymentMethodMockedMapper verify];
}

- (void)testPaymentMethodSerializedRequestSEPADirectDebitPaymentMethod
{
    OCMockObject *mockedPaymentMethodRequest = [OCMockObject partialMockForObject:[[HPFSepaDirectDebitPaymentMethodRequest alloc] init]];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPFSepaDirectDebitPaymentMethodRequestSerializationMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethodSerializedRequest] serializedRequest];
    
    id paymentMethodMapperClassMock = OCMClassMock([HPFSepaDirectDebitPaymentMethodRequestSerializationMapper class]);
    OCMStub([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]).andReturn(paymentMethodMockedMapper);
    
    [[[mockedRequest expect] andReturn:mockedPaymentMethodRequest] valueForKey:@"paymentMethod"];
    
    XCTAssertEqual([mapper paymentMethodSerializedRequest], paymentMethodSerializedRequest);
    
    OCMVerify([paymentMethodMapperClassMock mapperWithRequest:mockedPaymentMethodRequest]);
    [mockedRequest verify];
    [paymentMethodMockedMapper verify];
}

- (void)testSerialization
{
    [[[mockedMapper expect] andReturn:initialSerializedRequest] orderRelatedSerializedRequest];
    [[[mockedMapper expect] andReturn:initialSerializedRequest] createImmutableDictionary:initialSerializedRequest];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    [[[mockedMapper expect] andReturn:paymentMethodSerializedRequest] paymentMethodSerializedRequest];
    
    [[mockedInitialSerializedRequest expect] mergeDictionary:paymentMethodSerializedRequest withPrefix:nil];
    
    [[[mockedMapper expect] andReturn:@"cb"] getStringForKey:@"paymentProductCode"];
    
    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"cb"] forKey:@"payment_product"];

    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqual(result, initialSerializedRequest);
    
    [mockedMapper verify];
    [mockedInitialSerializedRequest verify];
}

@end
