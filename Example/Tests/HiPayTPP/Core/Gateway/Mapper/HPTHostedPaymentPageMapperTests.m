//
//  HPTHostedPaymentPageMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 13/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTHostedPaymentPageMapperTests : XCTestCase
{
    NSDictionary *orderPayload;
    HPTOrder *order;
}

@end

@implementation HPTHostedPaymentPageMapperTests

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
                              @"anything": @"whatever",
                              };
    
    XCTAssertNil([[HPTHostedPaymentPageMapper alloc] initWithRawData:rawData]);
}

- (void)mockOrder
{
    orderPayload = @{};
    order = [[HPTOrder alloc] init];
    
    OCMockObject *orderMockedMapper = [OCMockObject mockForClass:[HPTOrderMapper class]];
    [[[orderMockedMapper expect] andReturn:order] mappedObject];
    
    id orderClassMock = OCMClassMock([HPTOrderMapper class]);
    OCMStub([orderClassMock mapperWithRawData:orderPayload]).andReturn(orderMockedMapper);
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"forwardUrl": @"https://secure-gateway.hipay-tpp.com/payment/web/pay/a7d9e4bb-c499-4e11-8a7c-08facfe80e11",
                              };
    
    // Class mock
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTHostedPaymentPageMapper alloc] initWithRawData:rawData]];
    HPTHostedPaymentPageMapper *mapper = (HPTHostedPaymentPageMapper *)mockedMapper;

    // Order mock
    [self mockOrder];
    [[[mockedMapper expect] andReturn:orderPayload] getDictionaryForKey:@"order"];

    // Tests
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
    [[[mockedMapper expect] andReturnValue:@(NO)] getBoolForKey:@"test"];
    [[[mockedMapper expect] andReturn:@"00009546321"] getStringForKey:@"mid"];

    [[[mockedMapper expect] andReturn:[NSURL URLWithString:[rawData objectForKey:@"forwardUrl"]]] getURLForKey:@"forwardUrl"];
    
    HPTHostedPaymentPage *object = mapper.mappedObject;
    
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
    
    XCTAssertEqualObjects(object.order, order);
    XCTAssertEqual(object.test, NO);
    XCTAssertEqualObjects(object.mid, @"00009546321");
    
    XCTAssertEqualObjects(object.forwardUrl, [NSURL URLWithString:[rawData objectForKey:@"forwardUrl"]]);
    
    [mockedMapper verify];
}


@end
