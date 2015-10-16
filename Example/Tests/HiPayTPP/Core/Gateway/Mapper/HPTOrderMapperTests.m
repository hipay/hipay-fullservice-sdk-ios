//
//  HPTOrderMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <HiPayTPP/HPTPersonalInformationMapper+Private.h>

@interface HPTOrderMapperTests : XCTestCase

@end

@implementation HPTOrderMapperTests

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
    NSDictionary *rawData = @{
                              @"email": @"test@example.com",
                              };
    
    XCTAssertNil([[HPTOrderMapper alloc] initWithRawData:rawData]);
    
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"firstname": @"John",
                              @"lastname": @"Doe",
                              @"id": @"ORDERWE_1444293883_714",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTOrderMapper alloc] initWithRawData:rawData]];
    HPTOrderMapper *mapper = (HPTOrderMapper *)mockedMapper;
    
    OCMockObject *addressMockedMapper = [OCMockObject partialMockForObject:[[HPTPersonalInformationMapper alloc] initWithRawData:rawData]];
    
    HPTOrder *object = [[HPTOrder alloc] init];
    HPTPersonalInformation *address = [[HPTPersonalInformation alloc] init];
    NSDictionary *addressPayload = @{
                                    @"firstname": @"Linda",
                                    @"lastname": @"Doe",
                                    @"streetAddress": @"14 Boulevard Arago",
                                    @"postalCode": @"75013",
                                    @"locality": @"Paris",
                                    @"country": @"France",
                                    };
    
    [[[mockedMapper expect] andReturn:object] mappedObjectWithPersonalInformation:[OCMArg isKindOfClass:[HPTOrder class]]];
 
    [[[mockedMapper expect] andReturn:@"EUR"] getStringForKey:@"currency"];
    [[[mockedMapper expect] andReturn:@"65478978"] getStringForKey:@"customerId"];
    [[[mockedMapper expect] andReturn:@"fr_FR"] getStringForKey:@"language"];
    [[[mockedMapper expect] andReturn:@"ORDERWE_1444293883_714"] getStringForKey:@"id"];
    [[[mockedMapper expect] andReturnValue:@(1)] getIntegerForKey:@"attempts"];
    [[[mockedMapper expect] andReturn:@(276.15)] getNumberForKey:@"amount"];
    [[[mockedMapper expect] andReturn:@(7.99)] getNumberForKey:@"shipping"];
    [[[mockedMapper expect] andReturn:@(25.84)] getNumberForKey:@"tax"];
    [[[mockedMapper expect] andReturn:@(2)] getNumberForKey:@"decimals"];
    [[[mockedMapper expect] andReturn:@(HPTGenderFemale)] getEnumCharForKey:@"gender"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444732372]] getDateForKey:@"dateCreated"];
    [[[mockedMapper expect] andReturn:addressPayload] getDictionaryForKey:@"shippingAddress"];
    
    id classMock = OCMClassMock([HPTPersonalInformationMapper class]);
    OCMStub([classMock mapperWithRawData:addressPayload]).andReturn(addressMockedMapper);
    [[[addressMockedMapper expect] andReturn:address] mappedObject];
    
    XCTAssertEqualObjects(mapper.mappedObject, object);
    
    XCTAssertEqualObjects(object.currency, @"EUR");
    XCTAssertEqualObjects(object.customerId, @"65478978");
    XCTAssertEqualObjects(object.language, @"fr_FR");
    XCTAssertEqualObjects(object.orderId, @"ORDERWE_1444293883_714");
    XCTAssertEqual(object.attempts, 1);
    XCTAssertEqualObjects(object.amount, @(276.15));
    XCTAssertEqualObjects(object.shipping, @(7.99));
    XCTAssertEqualObjects(object.tax, @(25.84));
    XCTAssertEqualObjects(object.decimals, @(2));
    XCTAssertEqual(object.gender, HPTGenderFemale);
    XCTAssertEqualObjects(object.dateCreated, [NSDate dateWithTimeIntervalSince1970:1444732372]);
    XCTAssertEqual(object.shippingAddress, address);
    
    [mockedMapper verify];
}

@end
