//
//  HPTHostedPaymentPageRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTPaymentPageRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTAbstractSerializationMapper.h>
#import <HiPayTPP/NSMutableDictionary+Serialization.h>
#import <HiPayTPP/HPTOrderRelatedRequestSerializationMapper_Private.h>

@interface HPTPaymentPageRequestSerializationMapperTests : XCTestCase

@end

@implementation HPTPaymentPageRequestSerializationMapperTests

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
    OCMockObject *mockedRequest = [OCMockObject partialMockForObject:[[HPTPaymentPageRequest alloc] init]];
    HPTPaymentPageRequest *request = (HPTPaymentPageRequest *)mockedRequest;
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTPaymentPageRequestSerializationMapper alloc] initWithRequest:request]];
    HPTPaymentPageRequestSerializationMapper *mapper = (HPTPaymentPageRequestSerializationMapper *)mockedMapper;
    
    OCMockObject *mockedInitialSerializedRequest = [OCMockObject partialMockForObject:[NSMutableDictionary dictionary]];
    NSMutableDictionary *initialSerializedRequest = (NSMutableDictionary *)mockedInitialSerializedRequest;
    
    [[[mockedMapper expect] andReturn:initialSerializedRequest] orderRelatedSerializedRequest];
    [[[mockedMapper expect] andReturn:initialSerializedRequest] createImmutableDictionary:initialSerializedRequest];
    
    [[[mockedMapper expect] andReturn:@"hello,ok,test"] getStringValuesListForKey:@"paymentProductList"];
    [[[mockedMapper expect] andReturn:@"hello2,ok2,test2"] getStringValuesListForKey:@"paymentProductCategoryList"];
    [[[mockedMapper expect] andReturn:@"2"] getIntegerEnumValueForKey:@"eci"];
    [[[mockedMapper expect] andReturn:@"1"] getIntegerEnumValueForKey:@"authenticationIndicator"];
    [[[mockedMapper expect] andReturn:@"1"] getIntegerForKey:@"multiUse"];
    [[[mockedMapper expect] andReturn:@"0"] getIntegerForKey:@"displaySelector"];
    [[[mockedMapper expect] andReturn:@"template-name"] getStringForKey:@"templateName"];
    [[[mockedMapper expect] andReturn:@"https://cssfile"] getURLForKey:@"css"];
    
    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"hello,ok,test"] forKey:@"payment_product_list"];
    [[mockedInitialSerializedRequest expect] setNullableObject:[OCMArg isEqual:@"hello2,ok2,test2"] forKey:@"payment_product_category_list"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"2" forKey:@"eci"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"1" forKey:@"authentication_indicator"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"1" forKey:@"multi_use"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"0" forKey:@"display_selector"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"template-name" forKey:@"template"];
    [[mockedInitialSerializedRequest expect] setNullableObject:@"https://cssfile" forKey:@"css"];
    
    NSDictionary *result = mapper.serializedRequest;
    
    XCTAssertEqual(result, initialSerializedRequest);
    
    [mockedMapper verify];
    [mockedInitialSerializedRequest verify];
}


@end
