//
//  HPFTransactionDetailsMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 19/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPFAbstractMapper+Decode.h>

@interface HPFTransactionDetailsMapper ()

- (BOOL)isRawDataArray;
- (BOOL)isRawDataSingleObject;
- (BOOL)isRawDataDictionaryArray;
- (id)transactionData;
- (BOOL)isEmpty;

@end

@interface HPFTransactionDetailsMapperTests : XCTestCase
{
    OCMockObject *mockedMapper;
    HPFTransactionDetailsMapper *mapper;
    
    OCMockObject *mockedTransactionMapper1;
    HPFTransactionMapper *transactionMapper1;
    
    OCMockObject *mockedTransactionMapper2;
    HPFTransactionMapper *transactionMapper2;
}

@end

@implementation HPFTransactionDetailsMapperTests

- (void)setUp {
    [super setUp];

    mockedMapper = [OCMockObject partialMockForObject:[[HPFTransactionDetailsMapper alloc] init]];
    mapper = (HPFTransactionDetailsMapper *)mockedMapper;
    
    mockedTransactionMapper1 = [OCMockObject partialMockForObject:[[HPFTransactionMapper alloc] init]];
    transactionMapper1 = (HPFTransactionMapper *)mockedTransactionMapper1;
    
    mockedTransactionMapper2 = [OCMockObject partialMockForObject:[[HPFTransactionMapper alloc] init]];
    transactionMapper2 = (HPFTransactionMapper *)mockedTransactionMapper2;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitDataValidityTransactionParam
{
    NSDictionary *rawData1 = @{@"transaction": @{@"wrongData": @"anything"}};
    NSDictionary *rawData2 = @{@"transaction": @{@"0": @"anything"}};
    NSDictionary *rawData3 = @{@"transaction": @{@"0": @{}, @"1": @{}}};
    NSDictionary *rawData4 = @{@"transaction": @[]};
    NSDictionary *rawData5 = @{@"transaction": @[@(1), @"test"]};
    NSDictionary *rawData6 = @{@"transaction": @{}};
    NSDictionary *rawData7 = @{@"transaction": @[@{}, @{}]};
    
    NSDictionary *rawData8 = @{@"0": @{}, @"1": @{}};
    NSArray *rawData9 = @[];
    NSDictionary *rawData10 = @{};
    NSArray *rawData11 = @[@{}, @{}];
    
    XCTAssertNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData1]);
    XCTAssertNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData2]);
    XCTAssertNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData5]);
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData8]);
    XCTAssertNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData9]);
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData10]);
    XCTAssertNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData11]);
    
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData3]);
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData4]);
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData6]);
    XCTAssertNotNil([[HPFTransactionDetailsMapper alloc] initWithRawData:rawData7]);
}

- (void)testIsValid1
{
    [[[mockedMapper stub] andReturnValue:@YES] isClassValid];
    
    [[[mockedMapper stub] andReturnValue:@YES] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@NO] isEmpty];
    [[[mockedMapper stub] andReturn:nil] getObjectsArrayForObject:OCMOCK_ANY];
    XCTAssertTrue([mapper isValid]);
}

- (void)testIsValid2
{
    [[[mockedMapper stub] andReturnValue:@YES] isClassValid];
    

    [[[mockedMapper stub] andReturnValue:@NO] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@YES] isEmpty];
    [[[mockedMapper stub] andReturn:nil] getObjectsArrayForObject:OCMOCK_ANY];
    XCTAssertTrue([mapper isValid]);

}

- (void)testIsValid3
{
    [[[mockedMapper stub] andReturnValue:@YES] isClassValid];
    
    [[[mockedMapper stub] andReturnValue:@NO] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@NO] isEmpty];
    [[[mockedMapper stub] andReturn:@[]] getObjectsArrayForObject:OCMOCK_ANY];
    XCTAssertTrue([mapper isValid]);

}

- (void)testIsValid4
{
    [[[mockedMapper stub] andReturnValue:@YES] isClassValid];
    
    [[[mockedMapper expect] andReturnValue:@NO] isRawDataSingleObject];
    [[[mockedMapper expect] andReturnValue:@NO] isEmpty];
    [[[mockedMapper expect] andReturn:nil] getObjectsArrayForObject:OCMOCK_ANY];
    XCTAssertFalse([mapper isValid]);
    [mockedMapper verify];
}

- (void)testRawDataType
{
    NSDictionary *transactionData1 = @{@"state": @"completed"};
    NSArray *transactionData2 = @[@{@"state": @"completed"}, @{@"state": @"pending"}];
    NSDictionary *transactionData3 = @{@"0": @{@"state": @"completed"}, @"1": @{@"state": @"pending"}};
    NSDictionary *transactionData4 = @{};
    
    [[[mockedMapper expect] andReturn:transactionData1] transactionData];
    XCTAssertTrue([mapper isRawDataSingleObject]);
    [mockedMapper verify];
    
    [[[mockedMapper expect] andReturn:transactionData2] transactionData];
    XCTAssertFalse([mapper isRawDataSingleObject]);
    [mockedMapper verify];
    
    [[[mockedMapper expect] andReturn:transactionData3] transactionData];
    XCTAssertFalse([mapper isRawDataSingleObject]);
    [mockedMapper verify];

    [[[mockedMapper expect] andReturn:transactionData4] rawData];
    XCTAssertTrue([mapper isEmpty]);
    [mockedMapper verify];
}

- (void)testMappedObjectSingle
{
    NSDictionary *transactionData = @{@"state": @"completed"};
    id mappedTransaction = [[NSObject alloc] init];
    
    [[[mockedMapper stub] andReturnValue:@(YES)] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@(NO)] isEmpty];
    
    [[[mockedMapper expect] andReturn:transactionData] transactionData];
    
    id transactionMapperClassMock = OCMClassMock([HPFTransactionMapper class]);
    OCMStub([transactionMapperClassMock mapperWithRawData:transactionData]).andReturn(mockedTransactionMapper1);
    
    [[[mockedTransactionMapper1 expect] andReturn:mappedTransaction] mappedObject];
    
    XCTAssertEqualObjects(mapper.mappedObject, @[mappedTransaction]);
    
    OCMVerify([transactionMapperClassMock mapperWithRawData:transactionData]);
    [mockedTransactionMapper1 verify];
    [mockedMapper verify];
}

- (void)testMappedObjectEmpty
{
    [[[mockedMapper stub] andReturnValue:@(NO)] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@(YES)] isEmpty];
    
    XCTAssertEqualObjects(mapper.mappedObject, @[]);
    
    [mockedTransactionMapper1 verify];
    [mockedMapper verify];
}

- (void)testMappedObjectArray
{
    NSArray *transactionData = @[@{@"state": @"completed"}, @{@"state": @"pending"}];
    id mappedTransaction1 = [[NSObject alloc] init];
    id mappedTransaction2 = [[NSObject alloc] init];
    NSArray *response = @[mappedTransaction1, mappedTransaction2];
    NSArray *sortedResponse = @[mappedTransaction2, mappedTransaction1];
    
    [[[mockedMapper stub] andReturnValue:@(NO)] isRawDataSingleObject];
    [[[mockedMapper stub] andReturnValue:@(NO)] isEmpty];
    [[[mockedMapper expect] andReturn:transactionData] transactionData];
    [[[mockedMapper expect] andReturn:transactionData] getObjectsArrayForObject:transactionData];
    
    id transactionMapperClassMock = OCMClassMock([HPFTransactionMapper class]);
    OCMStub([transactionMapperClassMock mapperWithRawData:@{@"state": @"completed"}]).andReturn(mockedTransactionMapper1);
    OCMStub([transactionMapperClassMock mapperWithRawData:@{@"state": @"pending"}]).andReturn(mockedTransactionMapper2);
    
    id classMock = OCMClassMock([HPFTransaction class]);
    OCMStub([classMock sortTransactionsByRelevance:response]).andReturn(sortedResponse);
    
    
    [[[mockedTransactionMapper1 expect] andReturn:mappedTransaction1] mappedObject];
    [[[mockedTransactionMapper2 expect] andReturn:mappedTransaction2] mappedObject];
    
    XCTAssertEqualObjects(mapper.mappedObject, sortedResponse);
    
    OCMVerify([transactionMapperClassMock mapperWithRawData:@{@"state": @"completed"}]);
    OCMVerify([transactionMapperClassMock mapperWithRawData:@{@"state": @"pending"}]);
    
    [mockedTransactionMapper1 verify];
    [mockedTransactionMapper2 verify];
    [mockedMapper verify];
}

@end
