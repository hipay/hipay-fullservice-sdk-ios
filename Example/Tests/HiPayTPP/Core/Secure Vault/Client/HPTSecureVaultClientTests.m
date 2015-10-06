//
//  HPTSecureVaultClientTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 02/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPTSecureVaultClient+Testing.h"

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
    [clientConfigClassMock verify];
    
}

- (void)testEndpoints
{
    XCTAssertEqualObjects(HPTSecureVaultClientBaseURLStage, @"https://stage-secure-vault.hipay-tpp.com/rest/v1/");
    XCTAssertEqualObjects(HPTSecureVaultClientBaseURLProduction, @"https://secure-vault.hipay-tpp.com/rest/v1/");
}

- (void)testGenerateToken
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
    
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 5];
        
        passedCompletionBlock([[HPTHTTPResponse alloc] initWithStatusCode:200 body:rawData], nil);
    };
    
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: proxyBlock] performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];

    HPTPaymentCardToken *paymentCardToken = [[HPTPaymentCardToken alloc] init];
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:paymentCardToken] paymentCardTokenWithData:rawData];
    
    [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:code multiUse:multiUse andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertEqualObjects(paymentCardToken, cardToken);
        [expectation fulfill];

    }];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];

}

- (void)testError
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    NSError *HTTPError = [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:HPTErrorCodeHTTPClient userInfo:@{}];
    NSError *secureVaultError = [[NSError alloc] init];
    
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex:5];
        
        passedCompletionBlock([[HPTHTTPResponse alloc] initWithStatusCode:400 body:rawData], HTTPError);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:OCMOCK_ANY];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [[[((OCMockObject *)secureVaultClient) expect] andReturn:secureVaultError] errorForResponseBody:rawData andError:HTTPError];
    
    [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:code multiUse:multiUse andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(cardToken);
        XCTAssertEqualObjects(error, secureVaultError);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    
}

- (void)testErrorMalformedResponse
{
    NSDictionary *rawData = @{@"whatever": @"anything"};
    
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo: ^(NSInvocation *invocation) {
        
        HPTHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex:5];
        
        passedCompletionBlock([[HPTHTTPResponse alloc] initWithStatusCode:200 body:rawData], nil);
        
    }] performRequestWithMethod:HPTHTTPMethodPost path:@"token/create" parameters:parameters completionHandler:OCMOCK_ANY];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [secureVaultClient generateTokenWithCardNumber:cardNumber cardExpiryMonth:month cardExpiryYear:year cardHolder:holder securityCode:code multiUse:multiUse andCompletionHandler:^(HPTPaymentCardToken *cardToken, NSError *error) {
        
        XCTAssertNil(cardToken);
        XCTAssertEqualObjects(error.domain, HPTHiPayTPPErrorDomain);
        XCTAssertEqual(error.code, HPTErrorCodeAPIOther);
        XCTAssertEqualObjects([error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey], @"Malformed server response");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    
}

@end
