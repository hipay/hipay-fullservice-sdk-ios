//
//  HPFThreeDSecureTests.m
//  HiPayFullservice
//
//  Created by HiPay on 09/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>

@interface HPFThreeDSecureMapperTests : XCTestCase

@end

@implementation HPFThreeDSecureMapperTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"enrollmentStatus": @"Y",
                              @"enrollmentMessage": @"Authentication Available",
                              @"authenticationMessage": @"Authentication Successful",
                              @"authenticationStatus": @"Y",
                              @"authenticationToken": @"thetoken",
                              @"xid": @"thexid",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFThreeDSecureMapper alloc] initWithRawData:rawData]];
    
    [([[mockedMapper expect] andReturn:[rawData objectForKey:@"enrollmentMessage"]]) getStringForKey:@"enrollmentMessage"];
    [([[mockedMapper expect] andReturn:[rawData objectForKey:@"authenticationMessage"]]) getStringForKey:@"authenticationMessage"];
    [([[mockedMapper expect] andReturn:[rawData objectForKey:@"authenticationToken"]]) getStringForKey:@"authenticationToken"];
    [([[mockedMapper expect] andReturn:[rawData objectForKey:@"xid"]]) getStringForKey:@"xid"];
    
    [([[mockedMapper expect] andReturn:[NSNumber numberWithChar:HPFThreeDSecureEnrollmentStatusAuthenticationAvailable]]) getEnumCharForKey:@"enrollmentStatus"];
    
    [([[mockedMapper expect] andReturn:[NSNumber numberWithChar:HPFThreeDSecureAuthenticationStatusSuccessful]]) getEnumCharForKey:@"authenticationStatus"];
    
    HPFThreeDSecure *threeDSecure = ((HPFThreeDSecureMapper *)mockedMapper).mappedObject;
    
    XCTAssertEqualObjects(threeDSecure.enrollmentMessage, [rawData objectForKey:@"enrollmentMessage"]);
    XCTAssertEqualObjects(threeDSecure.authenticationMessage, [rawData objectForKey:@"authenticationMessage"]);
    XCTAssertEqual(threeDSecure.enrollmentStatus, HPFThreeDSecureEnrollmentStatusAuthenticationAvailable);
    XCTAssertEqual(threeDSecure.authenticationStatus, HPFThreeDSecureAuthenticationStatusSuccessful);
    XCTAssertEqualObjects(threeDSecure.xid, [rawData objectForKey:@"xid"]);
    XCTAssertEqualObjects(threeDSecure.authenticationToken, [rawData objectForKey:@"authenticationToken"]);
    
    [mockedMapper verify];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPFThreeDSecureMapper alloc] initWithRawData:rawData]);
    
}

- (void)testEnrollmentStatus
{
    XCTAssertEqual(' ', HPFThreeDSecureEnrollmentStatusUnknown);
    XCTAssertEqual('Y', HPFThreeDSecureEnrollmentStatusAuthenticationAvailable);
    XCTAssertEqual('N', HPFThreeDSecureEnrollmentStatusCardholderNotEnrolled);
    XCTAssertEqual('U', HPFThreeDSecureEnrollmentStatusUnableToAuthenticate);
    XCTAssertEqual('E', HPFThreeDSecureEnrollmentStatusOtherError);
}

@end
