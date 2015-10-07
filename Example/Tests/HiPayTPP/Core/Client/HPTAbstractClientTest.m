//
//  HPTAbstractClient.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 05/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractClient+Private.h>

@interface HPTAbstractClientTest : XCTestCase
{
    HPTAbstractClient *client;
    OCMockObject *mockedClient;
}

@end

@implementation HPTAbstractClientTest

- (void)setUp {
    [super setUp];

    client = [OCMockObject partialMockForObject:[[HPTAbstractClient alloc] init]];
    mockedClient = (OCMockObject *)client;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRange
{
    XCTAssertEqual([client errorCodeForNumber:@"1000001"], HPTErrorCodeAPIConfiguration);
    XCTAssertEqual([client errorCodeForNumber:@"1000009"], HPTErrorCodeAPIConfiguration);
    XCTAssertEqual([client errorCodeForNumber:@"1010001"], HPTErrorCodeAPIValidation);
    XCTAssertEqual([client errorCodeForNumber:@"1010301"], HPTErrorCodeAPIValidation);
    XCTAssertEqual([client errorCodeForNumber:@"1020001"], HPTErrorCodeAPICheckout);
    XCTAssertEqual([client errorCodeForNumber:@"3010008"], HPTErrorCodeAPICheckout);
    XCTAssertEqual([client errorCodeForNumber:@"3020001"], HPTErrorCodeAPIMaintenance);
    XCTAssertEqual([client errorCodeForNumber:@"3020403"], HPTErrorCodeAPIMaintenance);
    XCTAssertEqual([client errorCodeForNumber:@"4000001"], HPTErrorCodeAPIAcquirer);
    XCTAssertEqual([client errorCodeForNumber:@"4010309"], HPTErrorCodeAPIAcquirer);
    
    // Other
    XCTAssertEqual([client errorCodeForNumber:@"40103090"], HPTErrorCodeAPIOther);
    XCTAssertEqual([client errorCodeForNumber:@"401030"], HPTErrorCodeAPIOther);
    XCTAssertEqual([client errorCodeForNumber:@"XXXXXXX"], HPTErrorCodeAPIOther);
}

- (void)testError
{
    [[[mockedClient expect] andReturnValue:OCMOCK_VALUE(HPTErrorCodeAPIConfiguration)] errorCodeForNumber:@"1000001"];
    
    NSError *underlyingError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @"1000001",
                                                    @"message": @"Incorrect Credentials",
                                                    @"description": @"Username and/or password is incorrect."}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
    XCTAssertEqual(error.code, HPTErrorCodeAPIConfiguration);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSLocalizedDescriptionKey], @"Username and/or password is incorrect.");
    XCTAssertEqual([[error.userInfo objectForKey:HPTErrorCodeAPICodeKey] integerValue], HPTErrorAPIIncorrectCredentials);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
    
    [mockedClient verify];
}

- (void)testErrorMalformedResponse1
{
    NSError *underlyingError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @"1000001",
                                                    @"message": @"Incorrect Credentials"}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
    XCTAssertEqual(error.code, HPTErrorCodeAPIOther);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
}

- (void)testErrorMalformedResponse2
{
    NSError *underlyingError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    
    NSError *error = [client errorForResponseBody:@{@"code": @11111111,
                                                    @"message": @"Incorrect Credentials",
                                                    @"description": @"Username and/or password is incorrect."}
                                         andError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
    XCTAssertEqual(error.code, HPTErrorCodeAPIOther);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
}

@end
