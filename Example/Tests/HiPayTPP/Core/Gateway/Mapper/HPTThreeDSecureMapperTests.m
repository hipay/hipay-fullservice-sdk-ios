//
//  HPTThreeDSecureTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTThreeDSecureMapperTests : XCTestCase

@end

@implementation HPTThreeDSecureMapperTests

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
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTThreeDSecureMapper alloc] initWithRawData:rawData]];
    
    [((HPTPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:[rawData objectForKey:@"enrollmentMessage"]]) getStringForKey:@"enrollmentMessage"];
    
    [((HPTPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:[NSNumber numberWithChar:HPTThreeDSecureEnrollmentStatusAuthenticationAvailable]]) getEnumCharForKey:@"enrollmentStatus"];
    
    HPTThreeDSecure *threeDSecure = ((HPTThreeDSecureMapper *)mockedMapper).mappedObject;
    
    XCTAssertEqualObjects(threeDSecure.enrollmentMessage, [rawData objectForKey:@"enrollmentMessage"]);
    XCTAssertEqualObjects(threeDSecure.authenticationMessage, [rawData objectForKey:@"authenticationMessage"]);
    XCTAssertEqual(threeDSecure.enrollmentStatus, HPTThreeDSecureEnrollmentStatusAuthenticationAvailable);
    XCTAssertEqual(threeDSecure.authenticationStatus, HPTThreeDSecureAuthenticationStatusSuccessful);
    XCTAssertEqualObjects(threeDSecure.xid, [rawData objectForKey:@"xid"]);
    XCTAssertEqualObjects(threeDSecure.authenticationToken, [rawData objectForKey:@"authenticationToken"]);
    
    [mockedMapper verify];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPTThreeDSecureMapper alloc] initWithRawData:rawData]);
    
}

- (void)testEnrollmentStatus
{
    XCTAssertEqual(' ', HPTThreeDSecureEnrollmentStatusUnknown);
    XCTAssertEqual('Y', HPTThreeDSecureEnrollmentStatusAuthenticationAvailable);
    XCTAssertEqual('N', HPTThreeDSecureEnrollmentStatusCardholderNotEnrolled);
    XCTAssertEqual('U', HPTThreeDSecureEnrollmentStatusUnableToAuthenticate);
    XCTAssertEqual('E', HPTThreeDSecureEnrollmentStatusOtherError);
}

@end
