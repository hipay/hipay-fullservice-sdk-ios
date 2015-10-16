//
//  HPTOrderRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTOrderRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTOrderRelatedRequestSerializationMapper_Private.h>
#import <HiPayTPP/NSMutableDictionary+Serialization.h>
#import <HiPayTPP/HPTOrderRequestSerializationMapper_Private.h>
#import <HiPayTPP/HPTCardTokenPaymentMethodRequest.h>
#import <HiPayTPP/HPTCardTokenPaymentMethodRequestSerializationMapper.h>

@interface HPTOrderRequestSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    HPTOrderRequest *request;
    
    OCMockObject *mockedMapper;
    HPTOrderRequestSerializationMapper *mapper;

    OCMockObject *mockedInitialSerializedRequest;
    NSMutableDictionary *initialSerializedRequest;

}

@end

@implementation HPTOrderRequestSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject partialMockForObject:[[HPTOrderRequest alloc] init]];
    request = (HPTOrderRequest *)mockedRequest;
    
    mockedMapper = [OCMockObject partialMockForObject:[[HPTOrderRequestSerializationMapper alloc] initWithRequest:request]];
    mapper = (HPTOrderRequestSerializationMapper *)mockedMapper;

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
    OCMockObject *mockedPaymentMethodRequest = [OCMockObject partialMockForObject:[[HPTCardTokenPaymentMethodRequest alloc] init]];
    
    NSDictionary *paymentMethodSerializedRequest = @{};
    OCMockObject *paymentMethodMockedMapper = [OCMockObject mockForClass:[HPTCardTokenPaymentMethodRequestSerializationMapper class]];
    [[[paymentMethodMockedMapper expect] andReturn:paymentMethodSerializedRequest] serializedRequest];
    
    id paymentMethodMapperClassMock = OCMClassMock([HPTCardTokenPaymentMethodRequestSerializationMapper class]);
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
    
    [[[mockedMapper expect] andReturn:@"cb"] getStringForKey:@"paymentProduct"];
    
    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"cb"] forKey:@"payment_product"];

    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqual(result, initialSerializedRequest);
    
    [mockedMapper verify];
    [mockedInitialSerializedRequest verify];
}

@end
