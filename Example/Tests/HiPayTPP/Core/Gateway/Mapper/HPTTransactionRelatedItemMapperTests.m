//
//  HPTTransactionRelatedItemMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <HiPayTPP/HPTTransactionRelatedItemMapper+Private.h>

@interface HPTTransactionRelatedItemMapperTests : XCTestCase

@end

@implementation HPTTransactionRelatedItemMapperTests

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
    
    XCTAssertNil([[HPTTransactionRelatedItemMapper alloc] initWithRawData:rawData]);
    
}

- (void)testMappinHighLevel
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416"};
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTTransactionRelatedItemMapper alloc] initWithRawData:rawData]];
    HPTTransactionRelatedItemMapper *mapper = (HPTTransactionRelatedItemMapper *)mockedMapper;
    
    __block HPTTransactionRelatedItem *transaction = [[HPTTransactionRelatedItem alloc] init];
    
    [[[mockedMapper expect] andReturn:transaction] mappedObjectWithTransactionRelatedItem:[OCMArg isKindOfClass:[HPTTransactionRelatedItem class]]];
    
    XCTAssertEqualObjects(mapper.mappedObject, transaction);
    
    [mockedMapper verify];
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416"};
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTTransactionRelatedItemMapper alloc] initWithRawData:rawData]];
    HPTTransactionRelatedItemMapper *mapper = (HPTTransactionRelatedItemMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturnValue:@(NO)] getBoolForKey:@"test"];
    [[[mockedMapper expect] andReturn:@"00009546321"] getStringForKey:@"mid"];
    [[[mockedMapper expect] andReturn:@"654789"] getStringForKey:@"authorizationCode"];
    [[[mockedMapper expect] andReturn:@"446780277416"] getStringForKey:@"transactionReference"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644207]] getDateForKey:@"dateCreated"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644237]] getDateForKey:@"dateUpdated"];
    [[[mockedMapper expect] andReturn:[NSDate dateWithTimeIntervalSince1970:1444644267]] getDateForKey:@"dateAuthorized"];
    [[[mockedMapper expect] andReturnValue:@(HPTTransactionStatusAuthorizationRequested)] getIntegerForKey:@"status"];
    [[[mockedMapper expect] andReturn:@"Capture Requested"] getStringForKey:@"message"];
    [[[mockedMapper expect] andReturn:@(12.56)] getNumberForKey:@"authorizedAmount"];
    [[[mockedMapper expect] andReturn:@(11.27)] getNumberForKey:@"capturedAmount"];
    [[[mockedMapper expect] andReturn:@(0.10)] getNumberForKey:@"refundedAmount"];
    [[[mockedMapper expect] andReturn:@(2)] getNumberForKey:@"decimals"];
    [[[mockedMapper expect] andReturn:@"EUR"] getStringForKey:@"currency"];
    
    HPTTransactionRelatedItem *object = [[HPTTransactionRelatedItem alloc] init];
    HPTTransactionRelatedItem *transaction = [mapper mappedObjectWithTransactionRelatedItem:object];
    
    XCTAssertEqualObjects(transaction, object);
    XCTAssertEqual(transaction.test, NO);
    XCTAssertEqualObjects(transaction.mid, @"00009546321");
    XCTAssertEqualObjects(transaction.authorizationCode, @"654789");
    XCTAssertEqualObjects(transaction.transactionReference, @"446780277416");
    XCTAssertEqualObjects(transaction.dateCreated, [NSDate dateWithTimeIntervalSince1970:1444644207]);
    XCTAssertEqualObjects(transaction.dateUpdated, [NSDate dateWithTimeIntervalSince1970:1444644237]);
    XCTAssertEqualObjects(transaction.dateAuthorized, [NSDate dateWithTimeIntervalSince1970:1444644267]);
    XCTAssertEqual(transaction.status, HPTTransactionStatusAuthorizationRequested);
    XCTAssertEqualObjects(transaction.message, @"Capture Requested");
    XCTAssertEqualObjects(transaction.authorizedAmount, @(12.56));
    XCTAssertEqualObjects(transaction.capturedAmount, @(11.27));
    XCTAssertEqualObjects(transaction.refundedAmount, @(0.10));
    XCTAssertEqualObjects(transaction.decimals, @(2));
    XCTAssertEqualObjects(transaction.currency, @"EUR");
    
    [mockedMapper verify];
}

@end
