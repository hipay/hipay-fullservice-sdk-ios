//
//  HPTSecureVaultClientTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 02/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPTSecureVaultClient+Testing.h"
#import <HiPayTPP/HPTAbstractClient+Private.h>

@interface HPTSecureVaultClientTests : XCTestCase
{
    HPTHTTPClient *mockedHTTPClient;
    HPTSecureVaultClient *secureVaultClient;
    NSDictionary *parameters;
    NSString *cardNumber;
    NSString *month;
    NSString *year;
    NSString *holder;
    NSString *code;
    BOOL multiUse;
}

@end

@implementation HPTSecureVaultClientTests

- (void)setUp {
    [super setUp];

    mockedHTTPClient = [OCMockObject mockForClass:[HPTHTTPClient class]];
    
    secureVaultClient = [OCMockObject partialMockForObject:[[HPTSecureVaultClient alloc] initWithHTTPClient:mockedHTTPClient clientConfig:[HPTClientConfig sharedClientConfig]]];

    cardNumber = @"4111111111111111";
    month = @"12";
    year = @"2016";
    holder = @"John Doe";
    code = @"456";
    multiUse = NO;
    
    parameters = @{
                   @"card_number": cardNumber,
                   @"card_expiry_month": month,
                   @"card_expiry_year": year,
                   @"card_holder": holder,
                   @"cvc": code,
                   @"multi_use": @(multiUse).stringValue,
                   };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedClient
{
    XCTAssertTrue([[HPTSecureVaultClient sharedClient] isKindOfClass:[HPTSecureVaultClient class]]);
    XCTAssertEqual([HPTSecureVaultClient sharedClient], [HPTSecureVaultClient sharedClient]);
}

- (void)testClientConfig
{
    OCMockObject *clientConfigMock = [OCMockObject mockForClass:[HPTClientConfig class]];
    
    [((HPTClientConfig *)[[clientConfigMock expect] andReturnValue:@(HPTEnvironmentStage)]) environment];
    [((HPTClientConfig *)[[clientConfigMock expect] andReturn:@"user_id"]) username];
    [((HPTClientConfig *)[[clientConfigMock expect] andReturn:@"password"]) password];
    
    id clientConfigClassMock = OCMClassMock([HPTClientConfig class]);
    OCMStub([clientConfigClassMock sharedClientConfig]).andReturn(clientConfigMock);
    
    [HPTSecureVaultClient createClient];
    
    [clientConfigMock verify];
    OCMVerify([clientConfigClassMock sharedClientConfig]);
    
}

- (void)testEndpoints
{
    XCTAssertEqualObjects(HPTSecureVaultClientBaseURLStage, @"https://stage-secure-vault.hipay-tpp.com/rest/v1/");
    XCTAssertEqualObjects(HPTSecureVaultClientBaseURLProduction, @"https://secure-vault.hipay-tpp.com/rest/v1/");
}

- (void)testGenerateToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPTHTTPResponse *HTTPResponse = [[HPTHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{}];
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPTSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPTPaymentCardToken *cardToken, NSError *error) {};
    
    HPTHTTPClientRequest *request = [[HPTHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPTRequest> returnedRequest = [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:code multiUse:multiUse andCompletionHandler:tokenCompletionBlock];
    
    XCTAssertEqual(request, returnedRequest);
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testGenerateTokenWithoutSecurityCode
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPTHTTPResponse *HTTPResponse = [[HPTHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{}];
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPTSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPTPaymentCardToken *cardToken, NSError *error) {};
    
    NSMutableDictionary *paramtersNoCVC = [parameters mutableCopy];
    [paramtersNoCVC setObject:@"" forKey:@"cvc"];
    
    // Generate token method should perform HTTP request
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:paramtersNoCVC completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:nil multiUse:multiUse andCompletionHandler:tokenCompletionBlock];
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testUpdateToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPTHTTPResponse *HTTPResponse = [[HPTHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{}];
    
    NSString *token = @"b57dad30b32a0026bd036b359cf70a80436a3b10";
    NSString *requestID = @"2U6YRQAWTGDXTAG6RZQ4RQX";
    
    NSDictionary *HTTPParameters = @{
                                 @"request_id": requestID,
                                 @"token": token,
                                 @"card_expiry_month": month,
                                 @"card_expiry_year": year,
                                 @"card_holder": holder,
                                 };
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPTSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPTPaymentCardToken *cardToken, NSError *error) {};
    
    HPTHTTPClientRequest *request = [[HPTHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPTHTTPMethodPost path:@"token/update" parameters:HTTPParameters completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPTRequest> returnedRequest = [secureVaultClient updatePaymentCardWithToken:token requestID:requestID setCardExpiryMonth:month cardExpiryYear:year cardHolder:holder completionHandler:tokenCompletionBlock];
    
    XCTAssertEqual(request, returnedRequest);
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testLookupPaymentCardWithToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPTHTTPResponse *HTTPResponse = [[HPTHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPOther userInfo:@{}];
    
    NSString *token = @"b57dad30b32a0026bd036b359cf70a80436a3b10";
    NSString *requestID = @"2U6YRQAWTGDXTAG6RZQ4RQX";
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPTSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPTPaymentCardToken *cardToken, NSError *error) {};
    
    HPTHTTPClientRequest *request = [[HPTHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPTHTTPMethodGet path:@"token/b57dad30b32a0026bd036b359cf70a80436a3b10" parameters:@{@"request_id": requestID} completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPTRequest> returnedRequest = [secureVaultClient lookupPaymentCardWithToken:token requestID:requestID andCompletionHandler:tokenCompletionBlock];
    
    XCTAssertEqual(request, returnedRequest);
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testManageRequestSuccess
{
    NSDictionary *rawData = @{@"token":@"b57dad30b32a0026bd036b359cf70a80436a3b10",
                              @"requestId":@"2U6YRQAWTGDXTAG6RZQ4RQX",
                              @"brand":@"visa",
                              @"pan":@"************1111",
                              @"cardHolder":holder,
                              @"cardExpiryMonth":month,
                              @"cardExpiryYear":year,
                              @"issuer":@"CARD SERVICES FOR CREDIT UNIONS, INC.",
                              @"country":@"US",
                              @"domesticNetwork":@"cb"};
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    HPTPaymentCardToken *paymentCardToken = [[HPTPaymentCardToken alloc] init];
    
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:paymentCardToken] paymentCardTokenWithData:rawData];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPTHTTPResponse alloc] initWithStatusCode:200 body:rawData] error:nil andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertEqualObjects(cardToken, paymentCardToken);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testManageRequestError
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    NSError *HTTPError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    NSError *secureVaultError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeAPIOther userInfo:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:secureVaultError] errorForResponseBody:rawData andError:HTTPError];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPTHTTPResponse alloc] initWithStatusCode:400 body:rawData] error:HTTPError andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(cardToken);
        XCTAssertEqualObjects(error, secureVaultError);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testManageRequestWithoutCompletionHandler
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    NSError *HTTPError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];

    [secureVaultClient manageRequestWithHTTPResponse:[[HPTHTTPResponse alloc] initWithStatusCode:400 body:rawData] error:HTTPError andCompletionHandler:nil];
}

- (void)testManageRequestErrorMalformedResponse
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPTHTTPResponse alloc] initWithStatusCode:200 body:rawData] error:nil andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(cardToken);
        XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
        XCTAssertEqual(error.code, HPTErrorCodeAPIOther);
        XCTAssertEqualObjects([error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey], @"Malformed server response");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [((OCMockObject *)secureVaultClient) verify];
}

@end
