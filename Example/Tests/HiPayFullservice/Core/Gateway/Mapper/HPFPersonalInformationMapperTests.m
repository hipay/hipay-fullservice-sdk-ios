//
//  HPFPersonalInformationMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 09/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>
#import <HiPayFullservice/HPFPersonalInformationMapper+Private.h>

@interface HPFPersonalInformationMapperTests : XCTestCase

@end

@implementation HPFPersonalInformationMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416"};
    
    XCTAssertNil([[HPFOperationMapper alloc] initWithRawData:rawData]);
}

- (void)testMappinHighLevel
{
    NSDictionary *rawData = @{@"email": @"john@doe.com",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFPersonalInformationMapper alloc] initWithRawData:rawData]];
    HPFPersonalInformationMapper *mapper = (HPFPersonalInformationMapper *)mockedMapper;
    
    __block HPFPersonalInformationMapper *object = [[HPFPersonalInformationMapper alloc] init];
    
    [[[mockedMapper expect] andReturn:object] mappedObjectWithPersonalInformation:[OCMArg isKindOfClass:[HPFPersonalInformation class]]];
    
    XCTAssertEqualObjects(mapper.mappedObject, object);
    
    [mockedMapper verify];
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"firstname": @"John",
                              @"lastname": @"Doe",
                              @"streetAddress": @"45 Bd Arago",
                              @"locality": @"Paris",
                              @"postalCode": @"75013",
                              @"country": @"France",
                              @"msisdn": @"0611111111",
                              @"phone": @"0211111111",
                              @"phoneOperator": @"FT",
                              @"email": @"john.doe@hello.com",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFPersonalInformationMapper alloc] initWithRawData:rawData]];
    HPFPersonalInformationMapper *mapper = (HPFPersonalInformationMapper *)mockedMapper;
    
    for (id key in [rawData allKeys]) {
        [[[mockedMapper expect] andReturn:[rawData objectForKey:key]] getStringForKey:key];
    }
    
    HPFPersonalInformation *personalInfo = [[HPFPersonalInformation alloc] init];
    
    XCTAssertEqualObjects([mapper mappedObjectWithPersonalInformation:personalInfo], personalInfo);
    XCTAssertEqualObjects(personalInfo.firstname, [rawData objectForKey:@"firstname"]);
    XCTAssertEqualObjects(personalInfo.lastname, [rawData objectForKey:@"lastname"]);
    XCTAssertEqualObjects(personalInfo.streetAddress, [rawData objectForKey:@"streetAddress"]);
    XCTAssertEqualObjects(personalInfo.locality, [rawData objectForKey:@"locality"]);
    XCTAssertEqualObjects(personalInfo.postalCode, [rawData objectForKey:@"postalCode"]);
    XCTAssertEqualObjects(personalInfo.country, [rawData objectForKey:@"country"]);
    XCTAssertEqualObjects(personalInfo.msisdn, [rawData objectForKey:@"msisdn"]);
    XCTAssertEqualObjects(personalInfo.phone, [rawData objectForKey:@"phone"]);
    XCTAssertEqualObjects(personalInfo.phoneOperator, [rawData objectForKey:@"phoneOperator"]);
    XCTAssertEqualObjects(personalInfo.email, [rawData objectForKey:@"email"]);
    
    [mockedMapper verify];
}

@end
