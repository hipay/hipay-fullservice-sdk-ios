//
//  HPTOrderRelatedRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTOrderRelatedRequestTests : XCTestCase

@end

@implementation HPTOrderRelatedRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultValues
{
    HPTOrderRelatedRequest *object = [[HPTOrderRelatedRequest alloc] init];
    
    XCTAssertEqualObjects([object valueForKey:@"operation"], @(HPTOrderRequestOperationUndefined));
}

- (HPTOrderRelatedRequest *)createOrderRelatedRequest
{
    HPTOrderRelatedRequest *object = [[HPTOrderRelatedRequest alloc] init];
    
    object.orderId = @"test1";
    object.shortDescription = @"test2";
    object.longDescription = @"test3";
    object.currency = @"test4";
    object.clientId = @"test5";
    object.ipAddress = @"test6";
    object.HTTPAccept = @"test7";
    object.HTTPUserAgent = @"test8";
    object.deviceFingerprint = @"test9";
    object.language = @"test10";
    
    object.amount = @(114.78);
    object.shipping = @(9.70);
    object.tax = @(25.98);
    object.operation = HPTOrderRequestOperationSale;
    
    object.acceptURL = [NSURL URLWithString:@"http://www.example.com/test1"];
    object.declineURL = [NSURL URLWithString:@"http://www.example.com/test2"];
    object.pendingURL = [NSURL URLWithString:@"http://www.example.com/test3"];
    object.exceptionURL = [NSURL URLWithString:@"http://www.example.com/test4"];
    object.cancelURL = [NSURL URLWithString:@"http://www.example.com/test5"];
    
    object.customData = @{@"hello": @"world"};
    
    object.cdata1 = @"test11";
    object.cdata2 = @"test12";
    object.cdata3 = @"test13";
    object.cdata4 = @"test14";
    object.cdata5 = @"test15";
    object.cdata6 = @"test16";
    object.cdata7 = @"test17";
    object.cdata8 = @"test18";
    object.cdata9 = @"test19";
    object.cdata10 = @"test20";
    
    return object;
}

- (void)testKeyPaths
{
    HPTOrderRelatedRequest *object = [self createOrderRelatedRequest];
    
    XCTAssertEqualObjects([object valueForKey:@"orderId"], @"test1");
    XCTAssertEqualObjects([object valueForKey:@"shortDescription"], @"test2");
    XCTAssertEqualObjects([object valueForKey:@"longDescription"], @"test3");
    XCTAssertEqualObjects([object valueForKey:@"currency"], @"test4");
    XCTAssertEqualObjects([object valueForKey:@"clientId"], @"test5");
    XCTAssertEqualObjects([object valueForKey:@"ipAddress"], @"test6");
    XCTAssertEqualObjects([object valueForKey:@"HTTPAccept"], @"test7");
    XCTAssertEqualObjects([object valueForKey:@"HTTPUserAgent"], @"test8");
    XCTAssertEqualObjects([object valueForKey:@"deviceFingerprint"], @"test9");
    XCTAssertEqualObjects([object valueForKey:@"language"], @"test10");
    XCTAssertEqualObjects([object valueForKey:@"amount"], @(114.78));
    XCTAssertEqualObjects([object valueForKey:@"shipping"], @(9.70));
    XCTAssertEqualObjects([object valueForKey:@"tax"], @(25.98));
    XCTAssertEqualObjects([object valueForKey:@"operation"], @(HPTOrderRequestOperationSale));
    XCTAssertEqualObjects([object valueForKey:@"acceptURL"], [NSURL URLWithString:@"http://www.example.com/test1"]);
    XCTAssertEqualObjects([object valueForKey:@"declineURL"], [NSURL URLWithString:@"http://www.example.com/test2"]);
    XCTAssertEqualObjects([object valueForKey:@"pendingURL"], [NSURL URLWithString:@"http://www.example.com/test3"]);
    XCTAssertEqualObjects([object valueForKey:@"exceptionURL"], [NSURL URLWithString:@"http://www.example.com/test4"]);
    XCTAssertEqualObjects([object valueForKey:@"cancelURL"], [NSURL URLWithString:@"http://www.example.com/test5"]);
    
    XCTAssertEqualObjects([object valueForKey:@"customData"], @{@"hello": @"world"});

    XCTAssertEqualObjects([object valueForKey:@"cdata1"], @"test11");
    XCTAssertEqualObjects([object valueForKey:@"cdata2"], @"test12");
    XCTAssertEqualObjects([object valueForKey:@"cdata3"], @"test13");
    XCTAssertEqualObjects([object valueForKey:@"cdata4"], @"test14");
    XCTAssertEqualObjects([object valueForKey:@"cdata5"], @"test15");
    XCTAssertEqualObjects([object valueForKey:@"cdata6"], @"test16");
    XCTAssertEqualObjects([object valueForKey:@"cdata7"], @"test17");
    XCTAssertEqualObjects([object valueForKey:@"cdata8"], @"test18");
    XCTAssertEqualObjects([object valueForKey:@"cdata9"], @"test19");
    XCTAssertEqualObjects([object valueForKey:@"cdata10"], @"test20");
    
    XCTAssertEqualObjects([object valueForKey:@"acceptURL"], [NSURL URLWithString:@"http://www.example.com/test1"]);
    XCTAssertEqualObjects([object valueForKey:@"declineURL"], [NSURL URLWithString:@"http://www.example.com/test2"]);
    XCTAssertEqualObjects([object valueForKey:@"pendingURL"], [NSURL URLWithString:@"http://www.example.com/test3"]);
    XCTAssertEqualObjects([object valueForKey:@"exceptionURL"], [NSURL URLWithString:@"http://www.example.com/test4"]);
    XCTAssertEqualObjects([object valueForKey:@"cancelURL"], [NSURL URLWithString:@"http://www.example.com/test5"]);

    OCMockObject *mockedClientConfig = [OCMockObject mockForClass:[HPTClientConfig class]];
    
    id classMock = OCMClassMock([HPTClientConfig class]);
    OCMExpect([classMock sharedClientConfig]).andReturn(mockedClientConfig);

    [[[mockedClientConfig expect] andReturn:[NSURL URLWithString:@"test://hipay"]] appRedirectionURL];
    
    object.orderId = @"MyOrder?Id";
    
    XCTAssertEqualObjects(object.acceptURL, [NSURL URLWithString:@"test://hipay/gateway/orders/MyOrder%3FId/accept"]);
    
    [mockedClientConfig verify];
    OCMVerify([classMock sharedClientConfig]);
}

- (void)testInitWithOrderRelatedRequest
{
    HPTOrderRelatedRequest *object = [self createOrderRelatedRequest];

    HPTOrderRelatedRequest *object2 = [[HPTOrderRelatedRequest alloc] initWithOrderRelatedRequest:object];

    XCTAssertEqualObjects(object.orderId, object2.orderId);
    XCTAssertEqualObjects(object.shortDescription, object2.shortDescription);
    XCTAssertEqualObjects(object.longDescription, object2.longDescription);
    XCTAssertEqualObjects(object.clientId, object2.clientId);
    XCTAssertEqualObjects(object.ipAddress, object2.ipAddress);
    XCTAssertEqualObjects(object.HTTPAccept, object2.HTTPAccept);
    XCTAssertEqualObjects(object.HTTPUserAgent, object2.HTTPUserAgent);
    XCTAssertEqualObjects(object.deviceFingerprint, object2.deviceFingerprint);
    XCTAssertEqualObjects(object.language, object2.language);
    XCTAssertEqualObjects(object.currency, object2.currency);
    
    XCTAssertEqualObjects(object.amount, object2.amount);
    XCTAssertEqualObjects(object.shipping, object2.shipping);
    XCTAssertEqualObjects(object.tax, object2.tax);
    XCTAssertEqual(object.operation, object2.operation);
    XCTAssertEqualObjects(object.acceptURL, object2.acceptURL);
    XCTAssertEqualObjects(object.declineURL, object2.declineURL);
    XCTAssertEqualObjects(object.pendingURL, object2.pendingURL);
    XCTAssertEqualObjects(object.exceptionURL, object2.exceptionURL);
    XCTAssertEqualObjects(object.cancelURL, object2.cancelURL);

    XCTAssertEqualObjects(object.customData, object2.customData);

    XCTAssertEqualObjects(object.cdata1, object2.cdata1);
    XCTAssertEqualObjects(object.cdata2, object2.cdata2);
    XCTAssertEqualObjects(object.cdata3, object2.cdata3);
    XCTAssertEqualObjects(object.cdata4, object2.cdata4);
    XCTAssertEqualObjects(object.cdata5, object2.cdata5);
    XCTAssertEqualObjects(object.cdata6, object2.cdata6);
    XCTAssertEqualObjects(object.cdata7, object2.cdata7);
    XCTAssertEqualObjects(object.cdata8, object2.cdata8);
    XCTAssertEqualObjects(object.cdata9, object2.cdata9);
    XCTAssertEqualObjects(object.cdata10, object2.cdata10);
}

@end
