//
//  HPFHTTPClientTests.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 28/09/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HiPayFullservice.h>
#import "HPFHTTPClient+Testing.h"
#import <OCMock/OCMock.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface HPFHTTPClientTests : XCTestCase
{
    OCMockObject *mockedClient;
    HPFHTTPClient *client;
    NSURL *baseURL;
    NSURL *newBaseURL;
}

@end

@implementation HPFHTTPClientTests

- (void)setUp {
    [super setUp];
    
    baseURL = [NSURL URLWithString:@"https://api.example.org/"];
    newBaseURL = [NSURL URLWithString:@"https://api.example.org/"];
    [self resetClient];
}

- (void)resetClient
{
    client = [[HPFHTTPClient alloc] initWithBaseURL:baseURL username:@"api_login" password:@"api_passwd"];
    mockedClient = [OCMockObject partialMockForObject:client];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testInit {
    XCTAssertTrue([client isKindOfClass:[HPFHTTPClient class]]);
    XCTAssertEqual(client.baseURL, baseURL);
}

- (void)testQueryString
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"value"] URLEncodeString:@"value" usingEncoding:NSUTF8StringEncoding];
    [[[mockedClient expect] andReturn:@"value2"] URLEncodeString:@"value2" usingEncoding:NSUTF8StringEncoding];
    [[[mockedClient expect] andForwardToRealObject] queryStringForDictionary:params];
    NSString *queryString = [client queryStringForDictionary:params];
    XCTAssertEqualObjects(queryString, @"param=value&param2=value2");
    [mockedClient verify];
}

- (NSString *)authHeaderValue
{
    return @"Basic YXBpX2xvZ2luOmFwaV9wYXNzd2Q=";
}

- (void)testAuthHeaderCreation
{
    //XCTAssertEqualObjects([self authHeaderValue], [client createAuthHeaderWithSignature:@"signature"]);
    XCTAssertNotNil([client createAuthHeaderWithSignature:@"signature"]);
}

- (void)testRequestMetadata
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    //[[[mockedClient expect] andReturn:[self authHeaderValue]] createAuthHeaderWithSignature:@"signature"];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Accept"], @"application/json");
    //XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Authorization"], [self authHeaderValue]);
    
}

- (void)testGETURLRequest
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertTrue([URLRequest isKindOfClass:[NSMutableURLRequest class]]);
    XCTAssertEqualObjects(URLRequest.URL.absoluteString, @"https://api.example.org/items/1?param=value&param2=value2");
}

- (void)testPOSTURLRequest
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPFHTTPMethodPost v2:NO path:@"items" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertTrue([URLRequest isKindOfClass:[NSMutableURLRequest class]]);
    XCTAssertEqualObjects(URLRequest.URL.absoluteString, @"https://api.example.org/items");
    XCTAssertEqualObjects(URLRequest.HTTPBody, [@"param=value&param2=value2" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testClientReturnsRequest
{
    NSURLRequest *URLRequest = [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = OHPathForFile(@"example_dictionary.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    HPFHTTPClientRequest *clientRequest = [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    
    XCTAssertEqualObjects(clientRequest.URLSessionTask.originalRequest.HTTPMethod, URLRequest.HTTPMethod);
    XCTAssertEqualObjects(clientRequest.URLSessionTask.originalRequest.URL, URLRequest.URL);
    
    [mockedClient verify];
}

- (NSURLRequest *)createRequestAndExpectItsCreationWithStubResponse:(OHHTTPStubsResponseBlock)stubResponse
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.example.org/items/1?param=value&param2=value2"]];
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [URLRequest setValue:[self authHeaderValue] forHTTPHeaderField:@"Authorisation"];

    [[[mockedClient expect] andReturn:URLRequest] createURLRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"}];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:URLRequest.URL.absoluteString] && [request.HTTPMethod isEqualToString:request.HTTPMethod];
    } withStubResponse:stubResponse];
    
    return URLRequest;
}

- (void)testURLEncodeString
{
    XCTAssertEqualObjects([((HPFHTTPClient *)mockedClient) URLEncodeString:@"Hello + World" usingEncoding:NSUTF8StringEncoding], @"Hello%20%2B%20World");
}

- (void)testPerformRequestDictionary
{
    
    [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = OHPathForFile(@"example_dictionary.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString* fixture = OHPathForFile(@"example_dictionary.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        NSDictionary *body = @{
                               @"array": @[@1, @2, @3],
                               @"boolean": @YES,
                               @"number": @123,
                               @"null": [NSNull null],
                               @"object": @{@"a": @"b", @"c": @"d"},
                               @"string": @"Hello world"
                               };
        
        XCTAssertEqualObjects(response.body, body);
        XCTAssertNil(error);
        XCTAssertTrue(response.statusCode == 200);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    
    [mockedClient verify];
}

- (void)testPerformRequestArray
{
    [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *fixture = OHPathForFile(@"example_array.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        NSArray *body = @[
                          @{
                              @"boolean": @YES,
                              @"number": @123
                              },
                          @{
                              @"boolean": @NO,
                              @"number": @124
                              },
                          @{
                              @"boolean": @YES,
                              @"number": @125
                              }
                          ];
        
        XCTAssertEqualObjects(response.body, body);
        XCTAssertNil(error);
        XCTAssertTrue(response.statusCode == 200);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    
    [mockedClient verify];
}

- (void)doTestErrorFromURLConnectionErrorWithCode:(NSInteger)code  expectedCode:(NSInteger)expectedCode
{
    NSError *underlyingError = [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{}];
    NSError *error = [client errorFromURLConnectionError:underlyingError];
    
    XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
    XCTAssertTrue([error isKindOfClass:[NSError class]]);
    XCTAssertEqual(error.code, expectedCode);
    XCTAssertEqualObjects([error.userInfo objectForKey:NSUnderlyingErrorKey], underlyingError);
}

- (NSDictionary *)generatedErrorCodesForConnectionErrors
{
    NSDictionary *errors = @{
                             @(HPFErrorCodeHTTPNetworkUnavailable): @[
                                     @(NSURLErrorNotConnectedToInternet),
                                     @(NSURLErrorInternationalRoamingOff),
                                     @(NSURLErrorCallIsActive),
                                     @(NSURLErrorDataNotAllowed),
                                     ],
                             
                             @(HPFErrorCodeHTTPConnectionFailed): @[
                                     @(NSURLErrorTimedOut),
                                     @(NSURLErrorNetworkConnectionLost),
                                     @(NSURLErrorHTTPTooManyRedirects),
                                     @(NSURLErrorCannotDecodeRawData),
                                     @(NSURLErrorCannotDecodeContentData),
                                     @(NSURLErrorDataLengthExceedsMaximum),
                                     @(NSURLErrorRedirectToNonExistentLocation),
                                     @(NSURLErrorUserAuthenticationRequired),
                                     @(NSURLErrorUserCancelledAuthentication),
                                     @(NSURLErrorBadServerResponse),
                                     @(NSURLErrorCannotParseResponse),
                                     @(NSURLErrorResourceUnavailable),
                                     @(NSURLErrorZeroByteResource),
                                     @(NSURLErrorCannotLoadFromNetwork),
                                     ],
                             
                             @(HPFErrorCodeHTTPConfig): @[
                                     @(NSURLErrorSecureConnectionFailed),
                                     @(NSURLErrorServerCertificateHasBadDate),
                                     @(NSURLErrorServerCertificateUntrusted),
                                     @(NSURLErrorServerCertificateHasUnknownRoot),
                                     @(NSURLErrorServerCertificateNotYetValid),
                                     @(NSURLErrorClientCertificateRejected),
                                     @(NSURLErrorClientCertificateRequired),
                                     @(NSURLErrorUnsupportedURL),
                                     @(NSURLErrorCannotFindHost),
                                     @(NSURLErrorBadURL),
                                     @(NSURLErrorCannotConnectToHost),
                                     @(NSURLErrorDNSLookupFailed),
                                     @(NSURLErrorAppTransportSecurityRequiresSecureConnection),
                                     @(NSURLErrorBackgroundSessionRequiresSharedContainer),
                                     ],
                             
                             @(HPFErrorCodeHTTPOther): @[
                                     @(NSURLErrorCannotOpenFile),
                                     @(NSURLErrorCannotRemoveFile),
                                     @(NSURLErrorCannotMoveFile),
                                     ],
                             };
    
    return errors;
}

- (void)testErrorFromURLConnectionError
{
    NSDictionary *errors = [self generatedErrorCodesForConnectionErrors];
    
    for (NSNumber *finalErrorCode in [errors allKeys]) {
        for (NSNumber *code in [errors objectForKey:finalErrorCode]) {
            [self doTestErrorFromURLConnectionErrorWithCode:[code integerValue] expectedCode:finalErrorCode.integerValue];
        }
    }
}

- (void)doTestPerformRequestWithError:(NSError *)error expectedCode:(HPFErrorCode)code
{
    [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithError:error];
    }];
    
    NSError *FullserviceError = [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:code userInfo:@{NSUnderlyingErrorKey: error}];
    
    [[[mockedClient expect] andReturn:FullserviceError] errorFromURLConnectionError:error];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        XCTAssertNil(response);
        XCTAssertEqualObjects(error, FullserviceError);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:0.5 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    [mockedClient verify];
}

- (void)testPerformRequestError
{
    NSDictionary *errors = [self generatedErrorCodesForConnectionErrors];
    
    for (NSNumber *finalErrorCode in [errors allKeys]) {
        for (NSNumber *code in [errors objectForKey:finalErrorCode]) {
            [self doTestPerformRequestWithError:[NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{}] expectedCode:finalErrorCode.integerValue];
        }
    }
}

- (void)testPerformRequestWithMalformedJSONResponse
{
    [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:@"plain_text_response.txt" statusCode:200 headers:@{}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        XCTAssertNil(response);
        XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
        XCTAssertEqual(error.code, HPFErrorCodeHTTPServer);
        XCTAssertEqualObjects([error.userInfo objectForKey:NSLocalizedDescriptionKey], HPFErrorCodeHTTPServerDescription);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    [mockedClient verify];
}

- (void)doTestPerformRequestWithClientError:(NSInteger)errorCode
{
    [self createRequestAndExpectItsCreationWithStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = OHPathForFile(@"example_error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:(int)errorCode headers:@{}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPFHTTPMethodGet v2:NO path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPFHTTPResponse *response, NSError *error) {
        
        NSDictionary *body = @{@"error": @"error_key", @"description": @"Something bad."};
        
        XCTAssertEqualObjects(response.body, body);
        XCTAssertEqual(response.statusCode, errorCode);
        XCTAssertEqualObjects(error.domain, HPFHiPayFullserviceErrorDomain);
        XCTAssertEqual(error.code, HPFErrorCodeHTTPClient);
        XCTAssertEqual([error.userInfo objectForKey:NSLocalizedDescriptionKey], HPFErrorCodeHTTPClientDescription);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:0.2 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"Expectations error: %@", error);
        }
    }];
    [mockedClient verify];
}

- (void)testPerformRequestWithClientError
{
    [self doTestPerformRequestWithClientError:400];
    [self doTestPerformRequestWithClientError:401];
    [self doTestPerformRequestWithClientError:402];
    [self doTestPerformRequestWithClientError:403];
    [self doTestPerformRequestWithClientError:404];
}

- (void)testRequest
{
    OCMockObject *mockedTask = [OCMockObject mockForClass:[NSURLSessionTask class]];
    [[mockedTask expect] cancel];
        
    HPFHTTPClientRequest *request = [[HPFHTTPClientRequest alloc] initWithURLSessionTask:((NSURLSessionTask *)mockedTask)];

    [request cancel];

    [mockedTask verify];
}

@end
