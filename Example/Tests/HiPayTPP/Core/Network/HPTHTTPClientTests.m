//
//  HPTHTTPClientTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 28/09/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HiPayTPP.h>
#import "HPTHTTPClient+Testing.h"
#import <OCMock/OCMock.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface HPTHTTPClientTests : XCTestCase
{
    OCMockObject *mockedClient;
    HPTHTTPClient *client;
    NSURL *baseURL;
}

@end

@implementation HPTHTTPClientTests

- (void)setUp {
    [super setUp];

    baseURL = [NSURL URLWithString:@"https://api.example.org/"];
    client = [[HPTHTTPClient alloc] initWithBaseURL:baseURL login:@"api_login" password:@"api_passwd"];
    mockedClient = [OCMockObject partialMockForObject:client];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testInit {
    XCTAssertTrue([client isKindOfClass:[HPTHTTPClient class]]);
    XCTAssertEqual(client.baseURL, baseURL);
}

- (void)testQueryString
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andForwardToRealObject] queryStringForDictionary:params];
    NSString *queryString = [client queryStringForDictionary:params];
    XCTAssertEqualObjects(queryString, @"param=value&param2=value2");
    [mockedClient verify];
}

- (NSString *)authHeaderValue
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", @"api_login", @"api_passwd"];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return authHeaderValue;
}

- (void)testAuthHeaderCreation
{
    XCTAssertEqualObjects([self authHeaderValue], [client createAuthHeader]);
}

- (void)testRequestMetadata
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    [[[mockedClient expect] andReturn:[self authHeaderValue]] createAuthHeader];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPTHTTPMethodGet path:@"items/1" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Accept"], @"application/json");
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Authorization"], [self authHeaderValue]);
    
}

- (void)testGETURLRequest
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPTHTTPMethodGet path:@"items/1" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertTrue([URLRequest isKindOfClass:[NSMutableURLRequest class]]);
    XCTAssertEqualObjects(URLRequest.URL.absoluteString, @"https://api.example.org/items/1?param=value&param2=value2");
}

- (void)testPOSTURLRequest
{
    NSDictionary *params = @{@"param": @"value", @"param2": @"value2"};
    [[[mockedClient expect] andReturn:@"param=value&param2=value2"] queryStringForDictionary:params];
    
    NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPTHTTPMethodPost path:@"items" parameters:params];
    
    [mockedClient verify];
    
    XCTAssertTrue([URLRequest isKindOfClass:[NSMutableURLRequest class]]);
    XCTAssertEqualObjects(URLRequest.URL.absoluteString, @"https://api.example.org/items");
    XCTAssertEqualObjects(URLRequest.HTTPBody, [@"param=value&param2=value2" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testPerformRequest
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.example.org/items/1?param=value&param2=value2"]];
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [URLRequest setValue:[self authHeaderValue] forHTTPHeaderField:@"Authorisation"];

    [[[mockedClient expect] andReturn:URLRequest] createURLRequestWithMethod:HPTHTTPMethodGet path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"}];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
        NSString* fixture = OHPathForFile(@"example.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loading request"];
    
    [client performRequestWithMethod:HPTHTTPMethodGet path:@"items/1" parameters:@{@"param": @"value", @"param2": @"value2"} completionHandler:^(HPTHTTPResponse *response, NSError *error) {
        
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
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
    [mockedClient verify];
}

@end
