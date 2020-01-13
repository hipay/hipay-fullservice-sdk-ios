//
//  HPFAbstractClient.m
//  HiPayFullservice
//
//  Created by HiPay on 05/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractClient+Private.h>

@interface HPFAbstractClientTest : XCTestCase
{
    HPFAbstractClient *client;
    OCMockObject *mockedClient;
}

@end

@implementation HPFAbstractClientTest

- (void)setUp {
    [super setUp];

    client = [OCMockObject partialMockForObject:[[HPFAbstractClient alloc] init]];
    mockedClient = (OCMockObject *)client;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRange
{
    XCTAssertEqual([client errorCodeForNumber:@"1000001"], HPFErrorCodeAPIConfiguration);
    XCTAssertEqual([client errorCodeForNumber:@"1000009"], HPFErrorCodeAPIConfiguration);
    XCTAssertEqual([client errorCodeForNumber:@"1010001"], HPFErrorCodeAPIValidation);
    XCTAssertEqual([client errorCodeForNumber:@"1010301"], HPFErrorCodeAPIValidation);
    XCTAssertEqual([client errorCodeForNumber:@"1020001"], HPFErrorCodeAPICheckout);
    XCTAssertEqual([client errorCodeForNumber:@"3010008"], HPFErrorCodeAPICheckout);
    XCTAssertEqual([client errorCodeForNumber:@"3020001"], HPFErrorCodeAPIMaintenance);
    XCTAssertEqual([client errorCodeForNumber:@"3020403"], HPFErrorCodeAPIMaintenance);
    XCTAssertEqual([client errorCodeForNumber:@"4000001"], HPFErrorCodeAPIAcquirer);
    XCTAssertEqual([client errorCodeForNumber:@"4010309"], HPFErrorCodeAPIAcquirer);
    
    // Other
    XCTAssertEqual([client errorCodeForNumber:@"40103090"], HPFErrorCodeAPIOther);
    XCTAssertEqual([client errorCodeForNumber:@"401030"], HPFErrorCodeAPIOther);
    XCTAssertEqual([client errorCodeForNumber:@"XXXXXXX"], HPFErrorCodeAPIOther);
}

- (void)testError
{
    [[[mockedClient expect] andReturnValue:OCMOCK_VALUE(HPFErrorCodeAPIConfiguration)] errorCodeForNumber:@"1000001"];
    
    NSError *underlyingError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @"1000001",
                                                    @"message": @"Incorrect Credentials",
                                                    @"description": @"Username and/or password is incorrect."}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
    XCTAssertEqual(error.code, HPFErrorCodeAPIConfiguration);
    XCTAssertEqualObjects([error.userInfo objectForKey:HPFErrorCodeAPIDescriptionKey], @"Username and/or password is incorrect.");
    XCTAssertEqual([[error.userInfo objectForKey:HPFErrorCodeAPICodeKey] integerValue], HPFErrorAPIIncorrectCredentials);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
    
    [mockedClient verify];
}

- (void)testErrorMalformedResponse1
{
    NSError *underlyingError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @"1000001",
                                                    @"message": @"Incorrect Credentials"}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
    XCTAssertEqual(error.code, HPFErrorCodeAPIConfiguration);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
    XCTAssertNil([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
}

- (void)testErrorMalformedResponse2
{
    NSError *underlyingError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @1000001,
                                                    @"message": @"Incorrect Credentials",
                                                    @"description": @"Username and/or password is incorrect."}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
    XCTAssertEqual(error.code, HPFErrorCodeAPIConfiguration);
    XCTAssertEqualObjects([error.userInfo objectForKey:HPFErrorCodeAPIDescriptionKey], @"Username and/or password is incorrect.");
    XCTAssertEqual([[error.userInfo objectForKey:HPFErrorCodeAPICodeKey] integerValue], HPFErrorAPIIncorrectCredentials);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
}

@end
