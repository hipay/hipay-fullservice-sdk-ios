//
//  HPTGatewayClientTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 13/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPTGatewayClient+Testing.h"

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
