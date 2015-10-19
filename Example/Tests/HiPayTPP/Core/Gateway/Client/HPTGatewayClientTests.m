//
//  HPTGatewayClientTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 13/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPTGatewayClient+Testing.h"
#import <HiPayTPP/HPTAbstractClient+Private.h>

@interface HPTGatewayClientTests : XCTestCase
{
    HPTHTTPClient *mockedHTTPClient;
    HPTGatewayClient *gatewayClient;
}

@end

@implementation HPTGatewayClientTests

- (void)setUp {
    [super setUp];
    
    mockedHTTPClient = [OCMockObject mockForClass:[HPTHTTPClient class]];
    
    gatewayClient = [OCMockObject partialMockForObject:[[HPTGatewayClient alloc] initWithHTTPClient:mockedHTTPClient clientConfig:[HPTClientConfig sharedClientConfig]]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testClientConfig
{
    OCMockObject *clientConfigMock = [OCMockObject mockForClass:[HPTClientConfig class]];
    
    [((HPTClientConfig *)[[clientConfigMock expect] andReturnValue:@(HPTEnvironmentStage)]) environment];
    [((HPTClientConfig *)[[clientConfigMock expect] andReturn:@"user_id"]) username];
    [((HPTClientConfig *)[[clientConfigMock expect] andReturn:@"password"]) password];
    
    id clientConfigClassMock = OCMClassMock([HPTClientConfig class]);
    OCMStub([clientConfigClassMock sharedClientConfig]).andReturn(clientConfigMock);
    
    [HPTGatewayClient createClient];
    
    [clientConfigMock verify];
    [clientConfigClassMock verify];
    
}

- (void)testEndpoints
{
    XCTAssertEqualObjects(HPTGatewayClientBaseURLStage, @"https://stage-secure-gateway.hipay-tpp.com/rest/v1/");
    XCTAssertEqualObjects(HPTGatewayClientBaseURLProduction, @"https://secure-gateway.hipay-tpp.com/rest/v1/");
}

- (void)testPerformRequestHTTPError
{
    NSError *HTTPError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPTHTTPResponse class]];
    
    NSError *gatewayError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:0 userInfo:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(object);
        XCTAssertEqual(error, gatewayError);
        [expectation fulfill];
    };
    
    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[(OCMockObject *)gatewayClient expect] andReturn:gatewayError] errorForResponseBody:body andError:HTTPError];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock((HPTHTTPResponse *) HTTPResponse, HTTPError);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPTHTTPMethodPost path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPTAbstractMapper class] completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
}

- (void)testPerformRequestMalformedResponse
{
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPTHTTPResponse class]];
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPTAbstractMapper class]];
    
    id mapperClassMock = OCMClassMock([HPTAbstractMapper class]);
    OCMStub([mapperClassMock mapperWithRawData:body]).andReturn(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(object);
        XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
        XCTAssertEqual(error.code, HPTErrorCodeAPIOther);
        XCTAssertEqualObjects(error.userInfo[NSLocalizedFailureReasonErrorKey], @"Malformed server response");
        [expectation fulfill];
    };

    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock((HPTHTTPResponse *) HTTPResponse, nil);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPTHTTPMethodPost path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPTAbstractMapper class] completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    [mockedMapper verify];
    [mapperClassMock verify];
}

- (void)testPerformRequestProperResponse
{
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPTHTTPResponse class]];
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPTAbstractMapper class]];
    id mappedObject = [[NSObject alloc] init];
    [[[mockedMapper expect] andReturn:mappedObject] mappedObject];
    
    id mapperClassMock = OCMClassMock([HPTAbstractMapper class]);
    OCMStub([mapperClassMock mapperWithRawData:body]).andReturn(mockedMapper);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(object, mappedObject);
        [expectation fulfill];
    };
    
    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock((HPTHTTPResponse *) HTTPResponse, nil);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPTHTTPMethodPost path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPTAbstractMapper class] completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    [mockedMapper verify];
    [mapperClassMock verify];
}

//- (void)testInitiateHostedPaymentPage
//{
//    // We create dummy response and error, just to check these info are passed to the proper methods
//    HPTHTTPResponse *HTTPResponse = [[HPTHTTPResponse alloc] init];
//    NSError *error = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{}];
//    
//    NSString *token = @"b57dad30b32a0026bd036b359cf70a80436a3b10";
//    NSString *requestID = @"2U6YRQAWTGDXTAG6RZQ4RQX";
//    
//    NSDictionary *HTTPParameters = @{
//                                     @"request_id": requestID,
//                                     @"token": token,
//                                     @"card_expiry_month": month,
//                                     @"card_expiry_year": year,
//                                     @"card_holder": holder,
//                                     };
//    
//    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
//    HPTSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPTPaymentCardToken *cardToken, NSError *error) {};
//    
//    // Generate token method should perform HTTP request
//    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
//        
//        HPTHTTPClientCompletionBlock passedCompletionBlock;
//        [invocation getArgument: &passedCompletionBlock atIndex: 5];
//        
//        passedCompletionBlock(HTTPResponse, error);
//        
//    }] performRequestWithMethod:HPTHTTPMethodPost path:@"token/update" parameters:HTTPParameters completionHandler:OCMOCK_ANY];
//    
//    // Once the method gets the HTTP response, it should call the manage request method
//    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
//    
//    [secureVaultClient updatePaymentCardWithToken:token requestID:requestID setCardExpiryMonth:month cardExpiryYear:year cardHolder:holder completionHandler:tokenCompletionBlock];
//    
//    [((OCMockObject *)secureVaultClient) verify];
//}


@end
