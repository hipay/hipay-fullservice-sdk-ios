//
//  HPFGatewayClientTests.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 13/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPFGatewayClient+Testing.h"
#import <HiPayFullservice/HPFAbstractClient+Private.h>
#import <HiPayFullservice/HPFPaymentPageRequestSerializationMapper.h>
#import <HiPayFullservice/HPFOrderRequestSerializationMapper.h>
#import <HiPayFullservice/HPFArrayMapper.h>
#import <HiPayFullservice/HPFTransactionCallbackMapper.h>

@interface HPFGatewayClientTests : XCTestCase
{
    HPFHTTPClient *mockedHTTPClient;
    HPFGatewayClient *gatewayClient;
    OCMockObject *mockedGatewayClient;
}

@end

@implementation HPFGatewayClientTests

- (void)setUp {
    [super setUp];
    
    mockedHTTPClient = [OCMockObject mockForClass:[HPFHTTPClient class]];
    
    gatewayClient = [OCMockObject partialMockForObject:[[HPFGatewayClient alloc] initWithHTTPClient:mockedHTTPClient clientConfig:[HPFClientConfig sharedClientConfig]]];
    mockedGatewayClient = (OCMockObject *)gatewayClient;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSharedClient
{
    XCTAssertTrue([[HPFGatewayClient sharedClient] isKindOfClass:[HPFGatewayClient class]]);
    XCTAssertEqual([HPFGatewayClient sharedClient], [HPFGatewayClient sharedClient]);
}

- (void)testClientConfig
{
    OCMockObject *clientConfigMock = [OCMockObject mockForClass:[HPFClientConfig class]];
    
    [((HPFClientConfig *)[[clientConfigMock expect] andReturnValue:@(HPFEnvironmentStage)]) environment];
    [((HPFClientConfig *)[[clientConfigMock expect] andReturn:@"user_id"]) username];
    [((HPFClientConfig *)[[clientConfigMock expect] andReturn:@"password"]) password];
    
    id clientConfigClassMock = OCMClassMock([HPFClientConfig class]);
    OCMStub([clientConfigClassMock sharedClientConfig]).andReturn(clientConfigMock);
    
    [HPFGatewayClient createClient];
    
    [clientConfigMock verify];
    OCMVerify([clientConfigClassMock sharedClientConfig]);
}

- (void)testEndpoints
{
    XCTAssertEqualObjects(HPFGatewayClientBaseURLStage, @"https://stage-secure-gateway.hipay-tpp.com/rest/v1/");
    XCTAssertEqualObjects(HPFGatewayClientBaseURLProduction, @"https://secure-gateway.hipay-tpp.com/rest/v1/");
}

- (void)testPerformRequestWihoutCompletionHandler
{
    
    NSError *HTTPError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPFHTTPResponse class]];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock((HPFHTTPResponse *) HTTPResponse, HTTPError);
        
    }] performRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPFAbstractMapper class] isArray:NO completionHandler:nil];
    
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    
}

- (void)testPerformRequestHTTPError
{
    NSError *HTTPError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeHTTPClient userInfo:@{}];
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPFHTTPResponse class]];
    
    NSError *gatewayError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:0 userInfo:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(object);
        XCTAssertEqual(error, gatewayError);
        [expectation fulfill];
    };
    
    
    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[(OCMockObject *)gatewayClient expect] andReturn:gatewayError] errorForResponseBody:body andError:HTTPError];
    
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock((HPFHTTPResponse *) HTTPResponse, HTTPError);
        
    }] performRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPFAbstractMapper class] isArray:NO completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
}

- (void)testPerformRequestMalformedResponse
{
    
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPFHTTPResponse class]];
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPFAbstractMapper class]];
    
    id mapperClassMock = OCMClassMock([HPFAbstractMapper class]);
    OCMStub([mapperClassMock mapperWithRawData:body]).andReturn(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(object);
        XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
        XCTAssertEqual(error.code, HPFErrorCodeAPIOther);
        XCTAssertEqualObjects(error.userInfo[NSLocalizedFailureReasonErrorKey], @"Malformed server response");
        [expectation fulfill];
    };

    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock((HPFHTTPResponse *) HTTPResponse, nil);
        
    }] performRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPFAbstractMapper class] isArray:NO completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    [mockedMapper verify];
    OCMVerify([mapperClassMock mapperWithRawData:body]);
    
}

- (void)testPerformRequestProperResponse
{
    
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPFHTTPResponse class]];
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPFAbstractMapper class]];
    id mappedObject = [[NSObject alloc] init];
    [[[mockedMapper expect] andReturn:mappedObject] mappedObject];
    
    id mapperClassMock = OCMClassMock([HPFAbstractMapper class]);
    OCMStub([mapperClassMock mapperWithRawData:body]).andReturn(mockedMapper);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(object, mappedObject);
        [expectation fulfill];
    };
    
    [[[HTTPResponse expect] andReturn:body] body];
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    
    [[[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock((HPFHTTPResponse *) HTTPResponse, nil);
        
    }] andReturn:clientRequest] performRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    id<HPFRequest> returnedRequest = [gatewayClient handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPFAbstractMapper class] isArray:NO completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    XCTAssertEqual(returnedRequest, clientRequest);
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    [mockedMapper verify];
    OCMVerify([mapperClassMock mapperWithRawData:body]);
    
}

- (void)testPerformRequestProperResponseWithArray
{
    
    NSDictionary *body = @{@"response": @(1)};
    OCMockObject *HTTPResponse = [OCMockObject mockForClass:[HPFHTTPResponse class]];
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPFAbstractMapper class]];
    id mappedObject = [[NSObject alloc] init];
    [[[mockedMapper expect] andReturn:mappedObject] mappedObject];
    
    id mapperClassMock = OCMClassMock([HPFArrayMapper class]);
    OCMStub([mapperClassMock mapperWithRawData:body objectMapperClass:([HPFAbstractMapper class])]).andReturn(mockedMapper);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(object, mappedObject);
        [expectation fulfill];
    };
    
    [[[HTTPResponse expect] andReturn:body] body];
    
    [[[((OCMockObject *)mockedHTTPClient) expect] andDo:^(NSInvocation *invocation) {
        
        HPFHTTPClientCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 6];
        
        passedCompletionBlock((HPFHTTPResponse *) HTTPResponse, nil);
        
    }] performRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"resource/item"] parameters:[OCMArg isEqual:@{@"hello": @"world"}] completionHandler:OCMOCK_ANY];
    
    [gatewayClient handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"resource/item" parameters:@{@"hello": @"world"} responseMapperClass:[HPFAbstractMapper class] isArray:YES completionHandler:completionBlock];
    
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    
    [HTTPResponse verify];
    [(OCMockObject *)gatewayClient verify];
    [(OCMockObject *)mockedHTTPClient verify];
    [mockedMapper verify];
    OCMVerify([mapperClassMock mapperWithRawData:body objectMapperClass:([HPFAbstractMapper class])]);
     
}

- (void)testInitiateHostedPaymentPage
{
    id request = [[NSObject alloc] init];
    OCMockObject *mockedSerializationMapper = [OCMockObject mockForClass:[HPFAbstractSerializationMapper class]];
    
    NSDictionary *parameters = @{HPFGatewayClientSignature:@"signature"};
    [[[mockedSerializationMapper expect] andReturn:parameters] serializedRequest];
    
    id mapperClassMock = OCMClassMock([HPFPaymentPageRequestSerializationMapper class]);
    OCMStub([mapperClassMock mapperWithRequest:request]).andReturn(mockedSerializationMapper);
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {};
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    [[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:[OCMArg isEqual:@"hpayment"] parameters:parameters responseMapperClass:[HPFHostedPaymentPageMapper class] isArray:NO completionHandler:completionBlock];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient initializeHostedPaymentPageRequest:request signature:@"signature" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);
    
    OCMVerify([mapperClassMock mapperWithRequest:request]);
    [(OCMockObject *)gatewayClient verify];
}

- (void)testTransactionWithReferenceOK
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    id theObject = [[NSObject alloc] init];
    NSArray *mappedArray = @[theObject];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertEqual(object, theObject);
        XCTAssertNil(error);
        [expectation fulfill];
    };
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    
    [[[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] andDo:^(NSInvocation *invocation) {
        
        HPFTransactionsCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 8];
        
        passedCompletionBlock(mappedArray, nil);
        
    }] handleRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"transaction/trId" parameters:@{HPFGatewayClientSignature:@"signature"} responseMapperClass:[HPFTransactionDetailsMapper class] isArray:NO completionHandler:OCMOCK_ANY];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient getTransactionWithReference:@"trId" signature:@"signature" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    [(OCMockObject *)gatewayClient verify];
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testTransactionWithReferenceError
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    NSError *theError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:0 userInfo:@{}];
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {
        XCTAssertEqual(error, theError);
        [expectation fulfill];
    };
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];

    [[[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] andDo:^(NSInvocation *invocation) {
        
        HPFTransactionsCompletionBlock passedCompletionBlock;
        [invocation getArgument: &passedCompletionBlock atIndex: 8];
        
        passedCompletionBlock(nil, theError);
        
    }] handleRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"transaction/trId" parameters:@{HPFGatewayClientSignature:@"signature"} responseMapperClass:[HPFTransactionDetailsMapper class] isArray:NO completionHandler:OCMOCK_ANY];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient getTransactionWithReference:@"trId" signature:@"signature" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    [(OCMockObject *)gatewayClient verify];
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
}

- (void)testTransactionDetailsWithOrderId
{
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {};
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    [[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] handleRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"transaction" parameters:@{@"orderid":@"orderId", HPFGatewayClientSignature:@"signature"} responseMapperClass:[HPFTransactionDetailsMapper class] isArray:NO completionHandler:completionBlock];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient getTransactionsWithOrderId:@"orderId" signature:@"signature" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    [(OCMockObject *)gatewayClient verify];
}

- (void)testOperationTypeValues
{
    XCTAssertThrowsSpecificNamed([gatewayClient operationValueForOperationType:HPFOperationTypeUnknown], NSException, NSInvalidArgumentException);
    
    XCTAssertEqualObjects([gatewayClient operationValueForOperationType:HPFOperationTypeCapture], @"capture");
    XCTAssertEqualObjects([gatewayClient operationValueForOperationType:HPFOperationTypeRefund], @"refund");
    XCTAssertEqualObjects([gatewayClient operationValueForOperationType:HPFOperationTypeAcceptChallenge], @"acceptChallenge");
    XCTAssertEqualObjects([gatewayClient operationValueForOperationType:HPFOperationTypeDenyChallenge], @"denyChallenge");
    XCTAssertEqualObjects([gatewayClient operationValueForOperationType:HPFOperationTypeCancel], @"cancel");
}

- (void)testPerformOperationWithoutAmount
{
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {};
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    [[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"maintenance/transaction/trId" parameters:@{@"operation": @"capture"} responseMapperClass:[HPFOperationMapper class] isArray:NO completionHandler:completionBlock];
    
    [[[(OCMockObject *)gatewayClient expect] andReturn:@"capture"] operationValueForOperationType:HPFOperationTypeCapture];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient performMaintenanceOperation:HPFOperationTypeCapture amount:nil onTransactionWithReference:@"trId" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    [(OCMockObject *)gatewayClient verify];
}

- (void)testPerformOperationWithAmount
{
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {};
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    [[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] handleRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"maintenance/transaction/trId" parameters:@{@"operation": @"capture", @"amount": @"15.00"} responseMapperClass:[HPFOperationMapper class] isArray:NO completionHandler:completionBlock];
    
    [[[(OCMockObject *)gatewayClient expect] andReturn:@"capture"] operationValueForOperationType:HPFOperationTypeCapture];

    id classMock = OCMClassMock([HPFAbstractSerializationMapper class]);
    OCMStub([classMock formatAmountNumber:@15]).andReturn(@"15.00");
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient performMaintenanceOperation:HPFOperationTypeCapture amount:@15 onTransactionWithReference:@"trId" withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    OCMVerify([classMock formatAmountNumber:@15]);
    
    [(OCMockObject *)gatewayClient verify];
}

- (void)testGetPaymentProducts
{
    id request = [[NSObject alloc] init];
    OCMockObject *mockedSerializationMapper = [OCMockObject mockForClass:[HPFAbstractSerializationMapper class]];
    
    NSDictionary *parameters = @{};
    [[[mockedSerializationMapper expect] andReturn:parameters] serializedRequest];
    
    id mapperClassMock = OCMClassMock([HPFPaymentPageRequestSerializationMapper class]);
    OCMStub([mapperClassMock mapperWithRequest:request]).andReturn(mockedSerializationMapper);
    
    void (^completionBlock)(id object, NSError *error) = ^void(id object, NSError *error) {};
    
    HPFHTTPClientRequest *clientRequest = [[HPFHTTPClientRequest alloc] init];
    [[[(OCMockObject *)gatewayClient expect] andReturn:clientRequest] handleRequestWithMethod:HPFHTTPMethodGet v2:YES path:@"available-payment-products" parameters:parameters responseMapperClass:[HPFPaymentProductMapper class] isArray:YES completionHandler:completionBlock];
    
    HPFHTTPClientRequest *returnedRequest = [gatewayClient getPaymentProductsForRequest:request withCompletionHandler:completionBlock];
    
    XCTAssertEqual(clientRequest, returnedRequest);

    OCMVerify([mapperClassMock mapperWithRequest:request]);
    [(OCMockObject *)gatewayClient verify];
}

- (void)testTransactionErrorIsFinal
{
    NSError *error1 = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeAPICheckout userInfo:@{HPFErrorCodeAPICodeKey: @(3010003)}];
    
    NSError *notFinalError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:HPFErrorCodeAPICheckout userInfo:@{HPFErrorCodeAPICodeKey: @(3010002)}];
    
    XCTAssertTrue([HPFGatewayClient isTransactionErrorFinal:error1]);
    
    XCTAssertFalse([HPFGatewayClient isTransactionErrorFinal:notFinalError]);
}

- (void)testIsRedirectURLComponentsPathValid
{
    NSArray *validPaths = @[
                            @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"accept"],
                            @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"decline"],
                            @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"cancel"],
                            @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"exception"],
                            @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"pending"]
                            ];
    
    NSArray *invalidPaths = @[
                              @[@"hipay-fullservice", @"gateway", @"orders", @"PO9898", @"unknown"],
                              @[@"hipay-fullservice", @"gatewa", @"orders", @"PO9898", @"accept"],
                              @[@"hipay-fullservice", @"gateway", @"ordrs", @"PO9898", @"decline"],
                              @[@"hipay-fullservice", @"gateway", @"orders", @"exception"],
                              @[@"gateway", @"orders", @"PO9898", @"pending"]
                            ];
    
    for (NSArray *path in validPaths) {
        XCTAssertTrue([gatewayClient isRedirectURLComponentsPathValid:path]);
    }
    
    for (NSArray *path in invalidPaths) {
        XCTAssertFalse([gatewayClient isRedirectURLComponentsPathValid:path]);
    }
}

- (void)testInvalidPath
{
    void (^notifBlock)(NSNotification *note) = ^(NSNotification * _Nonnull note) {
        XCTFail(@"Gateway should not post %@ notification in case of malformed URL", note.name);
    };

    [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectWithMappingErrorNotification object:nil queue:nil usingBlock:notifBlock];
    [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectSuccessfullyNotification object:nil queue:nil usingBlock:notifBlock];
    
    NSArray *path = @[@"hipay-fullservice", @"gateway", @"orders", @"TEST_SDK_IOS_1447858566", @"unknown"];
    
    [[[mockedGatewayClient expect] andReturnValue:@(NO)] isRedirectURLComponentsPathValid:path];

    XCTAssertFalse([gatewayClient handleOpenURL:[NSURL URLWithString:@"hipayexample://hipay-fullservice/gateway/orders/TEST_SDK_IOS_1447858566/unknown"]]);
}

- (void)testHandleOpenURLSuccessWithMapping
{
    NSURL *URL = [NSURL URLWithString:@"hipayexample://hipay-fullservice/gateway/orders/TEST_SDK_IOS_1447858566.325105/decline?orderid=TEST_SDK_IOS_1447858566.325105&cid=&state=declined&reason=4000011&status=113&test=1&reference=851483651903&approval=&authorized=&ip=0.0.0.0&country=&lang=fr_FR&email=support%40hipay.com&cdata1=dt1&cdata2=&cdata3=&cdata4=&cdata5=&cdata6=&cdata7=&cdata8=&cdata9=&cdata10=&score=190&fraud=CHALLENGED&review=pending&avscheck=&cvccheck=&pp=visa&eci3ds=7&veres=Y&pares=N&cardtoken=ce5f096fa6bc05989c170pamq8a94432660491bd&cardbrand=VISA&cardpan=XXXXXXXXXXXX0002&cardexpiry=201912&cardcountry=US&hash="];
    
    
    NSDictionary *expectedParams = @{@"orderid": @"TEST_SDK_IOS_1447858566.325105", @"cid": @"", @"state": @"declined", @"reason": @"4000011", @"status": @"113", @"test": @"1", @"reference": @"851483651903", @"approval": @"", @"authorized": @"", @"ip": @"0.0.0.0", @"country": @"", @"lang": @"fr_FR", @"email": @"support@hipay.com", @"cdata1": @"dt1", @"cdata2": @"", @"cdata3": @"", @"cdata4": @"", @"cdata5": @"", @"cdata6": @"", @"cdata7": @"", @"cdata8": @"", @"cdata9": @"", @"cdata10": @"", @"score": @"190", @"fraud": @"CHALLENGED", @"review": @"pending", @"avscheck": @"", @"cvccheck": @"", @"pp": @"visa", @"eci3ds": @"7", @"veres": @"Y", @"pares": @"N", @"cardtoken": @"ce5f096fa6bc05989c170pamq8a94432660491bd", @"cardbrand": @"VISA", @"cardpan": @"XXXXXXXXXXXX0002", @"cardexpiry": @"201912", @"cardcountry": @"US", @"hash": @""};
    
    
    OCMockObject *mockedMapper = [OCMockObject mockForClass:[HPFTransactionCallbackMapper class]];
    
    id classMock = OCMClassMock([HPFTransactionCallbackMapper class]);
    OCMStub([classMock mapperWithRawData:[OCMArg isEqual:expectedParams]]).andReturn(mockedMapper);
    
    HPFTransaction *transaction = [[HPFTransaction alloc] init];
    
    [[[mockedMapper expect] andReturn:transaction] mappedObject];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Gateway notification"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectWithMappingErrorNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        XCTFail(@"Gateway should not post %@ notification in this case.", note.name);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectSuccessfullyNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        XCTAssertEqualObjects(note.userInfo[@"orderId"], @"TEST_SDK_IOS_1447858566.325105");
        XCTAssertEqualObjects(note.userInfo[@"path"], @"decline");
        XCTAssertEqual(note.userInfo[@"transaction"], transaction);
        
        [expectation fulfill];
    }];
    
    
    // Path validity mock
    
    NSArray *path = @[@"hipay-fullservice", @"gateway", @"orders", @"TEST_SDK_IOS_1447858566.325105", @"decline"];
    [[[mockedGatewayClient expect] andReturnValue:@(YES)] isRedirectURLComponentsPathValid:path];
    
    
    BOOL handled = [gatewayClient handleOpenURL:URL];
    
    XCTAssertTrue(handled);
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    
    [mockedMapper verify];
}

- (void)testHandleOpenURLMappingError
{
    NSURL *URL = [NSURL URLWithString:@"hipayexample://hipay-fullservice/gateway/orders/TEST_SDK_IOS_1447858566.325105/accept"];
    
    NSDictionary *expectedParams = @{};
    
    id classMock = OCMClassMock([HPFTransactionCallbackMapper class]);
    OCMStub([classMock mapperWithRawData:[OCMArg isEqual:expectedParams]]).andReturn(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Gateway notification"];
    
    __block id errorNotification;
    __block id successNotification;
    
    successNotification = [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectSuccessfullyNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[NSNotificationCenter defaultCenter] removeObserver:errorNotification];

        XCTFail(@"Gateway should not post %@ notification in this case.", note.name);
    }];
    
    errorNotification = [[NSNotificationCenter defaultCenter] addObserverForName:HPFGatewayClientDidRedirectWithMappingErrorNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[NSNotificationCenter defaultCenter] removeObserver:successNotification];

        XCTAssertEqualObjects(note.userInfo[@"orderId"], @"TEST_SDK_IOS_1447858566.325105");
        XCTAssertEqualObjects(note.userInfo[@"path"], @"accept");
        XCTAssertNil(note.userInfo[@"transaction"]);
        
        [expectation fulfill];
    }];
    
    NSArray *path = @[@"hipay-fullservice", @"gateway", @"orders", @"TEST_SDK_IOS_1447858566.325105", @"accept"];
    [[[mockedGatewayClient expect] andReturnValue:@(YES)] isRedirectURLComponentsPathValid:path];
    
    BOOL handled = [gatewayClient handleOpenURL:URL];
    
    XCTAssertTrue(handled);
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

@end
