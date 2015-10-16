//
//  HPTHostedPaymentPageRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTHostedPaymentPageRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTAbstractSerializationMapper.h>
#import <HiPayTPP/NSMutableDictionary+Serialization.h>
#import <HiPayTPP/HPTOrderRelatedRequestSerializationMapper_Private.h>

@interface HPTHostedPaymentPageRequestSerializationMapperTests : XCTestCase

@end

@implementation HPTHostedPaymentPageRequestSerializationMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSerialization
{
    OCMockObject *mockedRequest = [OCMockObject partialMockForObject:[[HPTHostedPaymentPageRequest alloc] init]];
    HPTHostedPaymentPageRequest *request = (HPTHostedPaymentPageRequest *)mockedRequest;
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTHostedPaymentPageRequestSerializationMapper alloc] initWithRequest:request]];
    HPTHostedPaymentPageRequestSerializationMapper *mapper = (HPTHostedPaymentPageRequestSerializationMapper *)mockedMapper;
    
    OCMockObject *mockedInitialSerializedRequest = [OCMockObject partialMockForObject:[NSMutableDictionary dictionary]];
    NSMutableDictionary *initialSerializedRequest = (NSMutableDictionary *)mockedInitialSerializedRequest;
    
    [[[mockedMapper expect] andReturn:initialSerializedRequest] orderRelatedSerializedRequest];
    [[[mockedMapper expect] andReturn:initialSerializedRequest] createImmutableDictionary:initialSerializedRequest];
    
    [[[mockedMapper expect] andReturn:@"hello,ok,test"] getStringValuesListForKey:@"paymentProductList"];
    [[[mockedMapper expect] andReturn:@"hello2,ok2,test2"] getStringValuesListForKey:@"paymentProductCategoryList"];

    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"hello,ok,test"] forKey:@"payment_product_list"];
    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"hello2,ok2,test2"] forKey:@"payment_product_category_list"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqual(result, initialSerializedRequest);
    
    [mockedMapper verify];
    [mockedInitialSerializedRequest verify];
}


@end
