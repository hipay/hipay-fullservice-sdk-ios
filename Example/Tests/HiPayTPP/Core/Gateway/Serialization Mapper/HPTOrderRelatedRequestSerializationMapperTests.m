//
//  HPTOrderRelatedRequestSerializationMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 14/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTOrderRelatedRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper+Encode.h>
#import <HiPayTPP/HPTOrderRelatedRequestSerializationMapper_Private.h>
#import <HiPayTPP/HPTCustomerInfoRequestSerializationMapper.h>
#import <HiPayTPP/HPTAbstractSerializationMapper.h>
#import <HiPayTPP/NSMutableDictionary+Serialization.h>

@interface HPTOrderRelatedRequestSerializationMapperTests : XCTestCase
{
    OCMockObject *mockedRequest;
    HPTOrderRelatedRequest *request;
    OCMockObject *mockedMapper;
    HPTOrderRelatedRequestSerializationMapper *mapper;
    OCMockObject *mockedSerializedRequest;
    NSMutableDictionary *serializedRequest;
}

@end

@implementation HPTOrderRelatedRequestSerializationMapperTests

- (void)setUp {
    [super setUp];

    mockedRequest = [OCMockObject partialMockForObject:[[HPTOrderRelatedRequest alloc] init]];
    request = (HPTOrderRelatedRequest *)mockedRequest;
    
    mockedMapper = [OCMockObject partialMockForObject:[[HPTOrderRelatedRequestSerializationMapper alloc] initWithRequest:request]];
    mapper = (HPTOrderRelatedRequestSerializationMapper *)mockedMapper;
    
    mockedSerializedRequest = [OCMockObject partialMockForObject:[NSMutableDictionary dictionary]];
    serializedRequest = (NSMutableDictionary *)mockedSerializedRequest;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOperation
{
    [[[mockedRequest expect] andReturn:@(HPTOrderRequestOperationSale)] valueForKey:@"operation"];
    XCTAssertEqualObjects([mapper getOperation], @"Sale");
    [mockedMapper verify];
    
    [[[mockedRequest expect] andReturn:@(HPTOrderRequestOperationAuthorization)] valueForKey:@"operation"];
    XCTAssertEqualObjects([mapper getOperation], @"Authorization");
    [mockedMapper verify];
    
    [[[mockedRequest expect] andReturn:@(HPTOrderRequestOperationUndefined)] valueForKey:@"operation"];
    XCTAssertNil([mapper getOperation]);
    [mockedMapper verify];
    
    [[[mockedRequest expect] andReturn:@(999)] valueForKey:@"operation"];
    XCTAssertNil([mapper getOperation]);
    [mockedMapper verify];
}

- (void)testSerializationImmutable
{
    [[[mockedMapper expect] andReturn:serializedRequest] orderRelatedSerializedRequest];
    [[[mockedMapper expect] andReturn:serializedRequest] createImmutableDictionary:serializedRequest];

    XCTAssertEqual(mapper.serializedRequest, serializedRequest);
    
    [mockedMapper verify];

}

- (void)testSerialization
{
    [[[mockedMapper expect] andReturn:serializedRequest] createResponseDictionary];

    [[[mockedMapper expect] andReturn:@"test1"] getStringForKey:@"orderId"];
    [[[mockedMapper expect] andReturn:@"test2"] getStringForKey:@"shortDescription"];
    [[[mockedMapper expect] andReturn:@"test3"] getStringForKey:@"longDescription"];
    [[[mockedMapper expect] andReturn:@"test4"] getStringForKey:@"currency"];
    [[[mockedMapper expect] andReturn:@"test5"] getStringForKey:@"HTTPAccept"];
    [[[mockedMapper expect] andReturn:@"test6"] getStringForKey:@"HTTPUserAgent"];
    [[[mockedMapper expect] andReturn:@"test7"] getStringForKey:@"deviceFingerprint"];
    [[[mockedMapper expect] andReturn:@"test8"] getStringForKey:@"language"];
    [[[mockedMapper expect] andReturn:@"test9"] getStringForKey:@"clientId"];
    [[[mockedMapper expect] andReturn:@"test10"] getStringForKey:@"ipAddress"];

    [[[mockedMapper expect] andReturn:@"125.56"] getFloatForKey:@"amount"];
    [[[mockedMapper expect] andReturn:@"10.55"] getFloatForKey:@"shipping"];
    [[[mockedMapper expect] andReturn:@"32"] getFloatForKey:@"tax"];
    
    [[[mockedMapper expect] andReturn:@"http://www.example.com/redirect/test1"] getURLForKey:@"acceptURL"];
    [[[mockedMapper expect] andReturn:@"http://www.example.com/redirect/test2"] getURLForKey:@"declineURL"];
    [[[mockedMapper expect] andReturn:@"http://www.example.com/redirect/test3"] getURLForKey:@"pendingURL"];
    [[[mockedMapper expect] andReturn:@"http://www.example.com/redirect/test4"] getURLForKey:@"exceptionURL"];
    [[[mockedMapper expect] andReturn:@"http://www.example.com/redirect/test5"] getURLForKey:@"cancelURL"];
   
    [[[mockedMapper expect] andReturn:@"ctest1"] getStringForKey:@"cdata1"];
    [[[mockedMapper expect] andReturn:@"ctest2"] getStringForKey:@"cdata2"];
    [[[mockedMapper expect] andReturn:@"ctest3"] getStringForKey:@"cdata3"];
    [[[mockedMapper expect] andReturn:@"ctest4"] getStringForKey:@"cdata4"];
    [[[mockedMapper expect] andReturn:@"ctest5"] getStringForKey:@"cdata5"];
    [[[mockedMapper expect] andReturn:@"ctest6"] getStringForKey:@"cdata6"];
    [[[mockedMapper expect] andReturn:@"ctest7"] getStringForKey:@"cdata7"];
    [[[mockedMapper expect] andReturn:@"ctest8"] getStringForKey:@"cdata8"];
    [[[mockedMapper expect] andReturn:@"ctest9"] getStringForKey:@"cdata9"];
    [[[mockedMapper expect] andReturn:@"ctest10"] getStringForKey:@"cdata10"];
    
    [[[mockedMapper expect] andReturn:@"Sale"] getOperation];
    
    
    // Customer Info
    OCMockObject *mockedCustomerRequest = [OCMockObject partialMockForObject:[[HPTCustomerInfoRequest alloc] init]];
    HPTCustomerInfoRequest *customerRequest = (HPTCustomerInfoRequest *)mockedCustomerRequest;
    
    NSDictionary *customerSerializedRequest = @{};
    OCMockObject *customerMockedMapper = [OCMockObject mockForClass:[HPTCustomerInfoRequestSerializationMapper class]];
    [[[customerMockedMapper expect] andReturn:customerSerializedRequest] serializedRequest];
    
    id customerClassMock = OCMClassMock([HPTCustomerInfoRequestSerializationMapper class]);
    OCMStub([customerClassMock mapperWithRequest:customerRequest]).andReturn(customerMockedMapper);
    
    [[[mockedRequest expect] andReturn:customerRequest] valueForKey:@"customer"];
    
    [[mockedSerializedRequest expect] mergeDictionary:customerSerializedRequest withPrefix:nil];
    
    // Shipping Address
    OCMockObject *mockedAddressRequest = [OCMockObject partialMockForObject:[[HPTPersonalInfoRequest alloc] init]];
    HPTPersonalInfoRequest *addressRequest = (HPTPersonalInfoRequest *)mockedAddressRequest;
    
    NSDictionary *addressSerializedRequest = @{};
    OCMockObject *addressMockedMapper = [OCMockObject mockForClass:[HPTPersonalInfoRequestSerializationMapper class]];
    [[[addressMockedMapper expect] andReturn:addressSerializedRequest] serializedRequest];
    
    id addressClassMock = OCMClassMock([HPTPersonalInfoRequestSerializationMapper class]);
    OCMStub([addressClassMock mapperWithRequest:addressRequest]).andReturn(addressMockedMapper);
    
    [[[mockedRequest expect] andReturn:addressRequest] valueForKey:@"shippingAddress"];
    
    [[mockedSerializedRequest expect] mergeDictionary:addressSerializedRequest withPrefix:@"shipto_"];
    

    NSDictionary *result = [mapper orderRelatedSerializedRequest];
    
    XCTAssertEqualObjects([result objectForKey:@"orderid"], @"test1");
    XCTAssertEqualObjects([result objectForKey:@"operation"], @"Sale");
    XCTAssertEqualObjects([result objectForKey:@"description"], @"test2");
    XCTAssertEqualObjects([result objectForKey:@"long_description"], @"test3");
    XCTAssertEqualObjects([result objectForKey:@"currency"], @"test4");
    XCTAssertEqualObjects([result objectForKey:@"amount"], @"125.56");
    XCTAssertEqualObjects([result objectForKey:@"shipping"], @"10.55");
    XCTAssertEqualObjects([result objectForKey:@"tax"], @"32");
    XCTAssertEqualObjects([result objectForKey:@"cid"], @"test9");
    XCTAssertEqualObjects([result objectForKey:@"ipaddr"], @"test10");
    
    XCTAssertEqualObjects([result objectForKey:@"accept_url"], @"http://www.example.com/redirect/test1");
    XCTAssertEqualObjects([result objectForKey:@"decline_url"], @"http://www.example.com/redirect/test2");
    XCTAssertEqualObjects([result objectForKey:@"pending_url"], @"http://www.example.com/redirect/test3");
    XCTAssertEqualObjects([result objectForKey:@"exception_url"], @"http://www.example.com/redirect/test4");
    XCTAssertEqualObjects([result objectForKey:@"cancel_url"], @"http://www.example.com/redirect/test5");
    
    XCTAssertEqualObjects([result objectForKey:@"http_accept"], @"test5");
    XCTAssertEqualObjects([result objectForKey:@"http_user_agent"], @"test6");
    XCTAssertEqualObjects([result objectForKey:@"device_fingerprint"], @"test7");
    XCTAssertEqualObjects([result objectForKey:@"language"], @"test8");
    
    XCTAssertEqualObjects([result objectForKey:@"cdata1"], @"ctest1");
    XCTAssertEqualObjects([result objectForKey:@"cdata2"], @"ctest2");
    XCTAssertEqualObjects([result objectForKey:@"cdata3"], @"ctest3");
    XCTAssertEqualObjects([result objectForKey:@"cdata4"], @"ctest4");
    XCTAssertEqualObjects([result objectForKey:@"cdata5"], @"ctest5");
    XCTAssertEqualObjects([result objectForKey:@"cdata6"], @"ctest6");
    XCTAssertEqualObjects([result objectForKey:@"cdata7"], @"ctest7");
    XCTAssertEqualObjects([result objectForKey:@"cdata8"], @"ctest8");
    XCTAssertEqualObjects([result objectForKey:@"cdata9"], @"ctest9");
    XCTAssertEqualObjects([result objectForKey:@"cdata10"], @"ctest10");
    
    XCTAssertEqual(result, serializedRequest);
    
    OCMVerify([customerClassMock mapperWithRequest:customerRequest]);
    OCMVerify([addressClassMock mapperWithRequest:addressRequest]);
    
    [mockedMapper verify];
    [mockedSerializedRequest verify];
    [mockedAddressRequest verify];
    [mockedCustomerRequest verify];
    [mockedRequest verify];
}

@end
