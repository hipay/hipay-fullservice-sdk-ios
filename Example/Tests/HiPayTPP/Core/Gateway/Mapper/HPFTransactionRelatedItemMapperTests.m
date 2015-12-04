//
//  HPFTransactionRelatedItemMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPFAbstractMapper+Decode.h>
#import <HiPayTPP/HPFTransactionRelatedItemMapper+Private.h>

@interface HPFTransactionRelatedItemMapperTests : XCTestCase

@end

@implementation HPFTransactionRelatedItemMapperTests

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
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPFTransactionRelatedItemMapper alloc] initWithRawData:rawData]);
    
}

- (void)testMappinHighLevel
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416"};
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFTransactionRelatedItemMapper alloc] initWithRawData:rawData]];
    HPFTransactionRelatedItemMapper *mapper = (HPFTransactionRelatedItemMapper *)mockedMapper;
    
    __block HPFTransactionRelatedItem *transaction = [[HPFTransactionRelatedItem alloc] init];
    
    [[[mockedMapper expect] andReturn:transaction] mappedObjectWithTransactionRelatedItem:[OCMArg isKindOfClass:[HPFTransactionRelatedItem class]]];
    
    XCTAssertEqualObjects(mapper.mappedObject, transaction);
    
    [mockedMapper verify];
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416"};
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFTransactionRelatedItemMapper alloc] initWithRawData:rawData]];
    HPFTransactionRelatedItemMapper *mapper = (HPFTransactionRelatedItemMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturnValue:@(NO)] getBoolForKey:@"test"];
    [[[mockedMapper expect] andReturn:@"00009546321"] getStringForKey:@"mid"];
    [[[mockedMapper expect] andReturn:@"654789"] getStringForKey:@"authorizationCode"];
    [[[mockedMapper expect] andReturn:@"446780277416"] getStringForKey:@"transactionReference"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644207]] getDateForKey:@"dateCreated"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644237]] getDateForKey:@"dateUpdated"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644267]] getDateForKey:@"dateAuthorized"];
    [[[mockedMapper expect] andReturnValue:@(HPFTransactionStatusAuthorizationRequested)] getIntegerForKey:@"status"];
    [[[mockedMapper expect] andReturn:@"Capture Requested"] getStringForKey:@"message"];
    [[[mockedMapper expect] andReturn:@(12.56)] getNumberForKey:@"authorizedAmount"];
    [[[mockedMapper expect] andReturn:@(11.27)] getNumberForKey:@"capturedAmount"];
    [[[mockedMapper expect] andReturn:@(0.10)] getNumberForKey:@"refundedAmount"];
    [[[mockedMapper expect] andReturn:@(2)] getNumberForKey:@"decimals"];
    [[[mockedMapper expect] andReturn:@"EUR"] getStringForKey:@"currency"];
    
    HPFTransactionRelatedItem *object = [[HPFTransactionRelatedItem alloc] init];
    HPFTransactionRelatedItem *transaction = [mapper mappedObjectWithTransactionRelatedItem:object];
    
    XCTAssertEqualObjects(transaction, object);
    XCTAssertEqual(transaction.test, NO);
    XCTAssertEqualObjects(transaction.mid, @"00009546321");
    XCTAssertEqualObjects(transaction.authorizationCode, @"654789");
    XCTAssertEqualObjects(transaction.transactionReference, @"446780277416");
    XCTAssertEqualObjects(transaction.dateCreated, [NSDate dateWithTimeIntervalSince1970:1444644207]);
    XCTAssertEqualObjects(transaction.dateUpdated, [NSDate dateWithTimeIntervalSince1970:1444644237]);
    XCTAssertEqualObjects(transaction.dateAuthorized, [NSDate dateWithTimeIntervalSince1970:1444644267]);
    XCTAssertEqual(transaction.status, HPFTransactionStatusAuthorizationRequested);
    XCTAssertEqualObjects(transaction.message, @"Capture Requested");
    XCTAssertEqualObjects(transaction.authorizedAmount, @(12.56));
    XCTAssertEqualObjects(transaction.capturedAmount, @(11.27));
    XCTAssertEqualObjects(transaction.refundedAmount, @(0.10));
    XCTAssertEqualObjects(transaction.decimals, @(2));
    XCTAssertEqualObjects(transaction.currency, @"EUR");
    
    [mockedMapper verify];
}

@end
