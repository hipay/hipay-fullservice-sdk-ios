//
//  HPFSecureVaultClientTests.m
//  HiPayFullservice
//
//  Created by HiPay on 02/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPFSecureVaultClient+Testing.h"
#import <HiPayFullservice/HPFAbstractClient+Private.h>

@interface HPFSecureVaultClientTests : XCTestCase
{
    HPFHTTPClient *mockedHTTPClient;
    HPFSecureVaultClient *secureVaultClient;
    NSDictionary *parameters;
    NSString *cardNumber;
    NSString *month;
    NSString *year;
    NSString *holder;
    NSString *code;
    BOOL multiUse;
}

@end

@implementation HPFSecureVaultClientTests

- (void)setUp {
    [super setUp];

    mockedHTTPClient = [OCMockObject mockForClass:[HPFHTTPClient class]];
    
    secureVaultClient = [OCMockObject partialMockForObject:[[HPFSecureVaultClient alloc] initWithHTTPClient:mockedHTTPClient clientConfig:[HPFClientConfig sharedClientConfig]]];

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
                   @"multi_use": @(multiUse).stringValue
                   };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedClient
{
    XCTAssertTrue([[HPFSecureVaultClient sharedClient] isKindOfClass:[HPFSecureVaultClient class]]);
    XCTAssertEqual([HPFSecureVaultClient sharedClient], [HPFSecureVaultClient sharedClient]);
}

- (void)testClientConfig
{
    OCMockObject *clientConfigMock = [OCMockObject mockForClass:[HPFClientConfig class]];
    
    [((HPFClientConfig *)[[clientConfigMock expect] andReturnValue:@(HPFEnvironmentStage)]) environment];
    [((HPFClientConfig *)[[clientConfigMock expect] andReturn:@"user_id"]) username];
    [((HPFClientConfig *)[[clientConfigMock expect] andReturn:@"password"]) password];
    
    id clientConfigClassMock = OCMClassMock([HPFClientConfig class]);
    OCMStub([clientConfigClassMock sharedClientConfig]).andReturn(clientConfigMock);
    
    [HPFSecureVaultClient createClient];
    
    [clientConfigMock verify];
    OCMVerify([clientConfigClassMock sharedClientConfig]);
    
}

- (void)testEndpoints
{
    XCTAssertEqualObjects(HPFSecureVaultClientBaseURLStage, @"https://stage-secure-vault.hipay-tpp.com/rest/v1/");
    XCTAssertEqualObjects(HPFSecureVaultClientBaseURLProduction, @"https://secure-vault.hipay-tpp.com/rest/v1/");
}

- (void)testGenerateToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPFHTTPResponse *HTTPResponse = [[HPFHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPOther userInfo:@{}];
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPFSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPFPaymentCardToken *cardToken, NSError *error) {};
    
    HPFHTTPClientRequest *request = [[HPFHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPFHTTPMethodPost v2:YES path:@"token/create" parameters:parameters completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPFRequest> returnedRequest = [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:code multiUse:multiUse andCompletionHandler:tokenCompletionBlock];
    
    XCTAssertEqual(request, returnedRequest);
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testGenerateTokenWithoutSecurityCode
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPFHTTPResponse *HTTPResponse = [[HPFHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPOther userInfo:@{}];
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPFSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPFPaymentCardToken *cardToken, NSError *error) {};
    
    NSMutableDictionary *paramtersNoCVC = [parameters mutableCopy];
    [paramtersNoCVC setObject:@"" forKey:@"cvc"];
    
    // Generate token method should perform HTTP request
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] performRequestWithMethod:HPFHTTPMethodPost v2:YES path:@"token/create" parameters:paramtersNoCVC completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:nil multiUse:multiUse andCompletionHandler:tokenCompletionBlock];
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testUpdateToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPFHTTPResponse *HTTPResponse = [[HPFHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPOther userInfo:@{}];
    
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
    HPFSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPFPaymentCardToken *cardToken, NSError *error) {};
    
    HPFHTTPClientRequest *request = [[HPFHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPFHTTPMethodPost v2:YES path:@"token/update" parameters:HTTPParameters completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPFRequest> returnedRequest = [secureVaultClient updatePaymentCardWithToken:token requestID:requestID setCardExpiryMonth:month cardExpiryYear:year cardHolder:holder completionHandler:tokenCompletionBlock];
    
    XCTAssertEqual(request, returnedRequest);
    
    [((OCMockObject *)secureVaultClient) verify];
}

- (void)testLookupPaymentCardWithToken
{
    // We create dummy response and error, just to check these info are passed to the proper methods
    HPFHTTPResponse *HTTPResponse = [[HPFHTTPResponse alloc] init];
    NSError *error = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPOther userInfo:@{}];
    
    NSString *token = @"b57dad30b32a0026bd036b359cf70a80436a3b10";
    NSString *requestID = @"2U6YRQAWTGDXTAG6RZQ4RQX";
    
    // We don't do anything in this completion block, we just make sure the block is passed to the manageRequest method
    HPFSecureVaultClientCompletionBlock tokenCompletionBlock = ^(HPFPaymentCardToken *cardToken, NSError *error) {};
    
    HPFHTTPClientRequest *request = [[HPFHTTPClientRequest alloc] init];
    
    // Generate token method should perform HTTP request
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock(HTTPResponse, error);
        
    }] andReturn:request] performRequestWithMethod:HPFHTTPMethodGet v2:YES path:@"token/b57dad30b32a0026bd036b359cf70a80436a3b10" parameters:@{@"request_id": requestID} completionHandler:OCMOCK_ANY];
    
    // Once the method gets the HTTP response, it should call the manage request method
    [[((OCMockObject *)secureVaultClient) expect] manageRequestWithHTTPResponse:HTTPResponse error:error andCompletionHandler:tokenCompletionBlock];
    
    id<HPFRequest> returnedRequest = [secureVaultClient lookupPaymentCardWithToken:token requestID:requestID completionHandler:tokenCompletionBlock];
    
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
    
    HPFPaymentCardToken *paymentCardToken = [[HPFPaymentCardToken alloc] init];
    
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:paymentCardToken] paymentCardTokenWithData:rawData];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPFHTTPResponse alloc] initWithStatusCode:200 body:rawData] error:nil andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {
        
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
    
    NSError *HTTPError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    NSError *secureVaultError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeAPIOther userInfo:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:secureVaultError] errorForResponseBody:rawData andError:HTTPError];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPFHTTPResponse alloc] initWithStatusCode:400 body:rawData] error:HTTPError andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {
        
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
    
    NSError *HTTPError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];

    [secureVaultClient manageRequestWithHTTPResponse:[[HPFHTTPResponse alloc] initWithStatusCode:400 body:rawData] error:HTTPError andCompletionHandler:nil];
}

- (void)testManageRequestErrorMalformedResponse
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [secureVaultClient manageRequestWithHTTPResponse:[[HPFHTTPResponse alloc] initWithStatusCode:200 body:rawData] error:nil andCompletionHandler:^(HPFPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(cardToken);
        XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
        XCTAssertEqual(error.code, HPFErrorCodeAPIOther);
        XCTAssertEqualObjects([error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey], @"Malformed server response");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [((OCMockObject *)secureVaultClient) verify];
}

@end
