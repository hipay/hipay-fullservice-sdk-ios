//
//  HPFOperationMapperTests.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>
#import <HiPayFullservice/HPFTransactionRelatedItemMapper+Private.h>

@interface HPFOperationMapperTests : XCTestCase

@end

@implementation HPFOperationMapperTests

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
    
    XCTAssertNil([[HPFOperationMapper alloc] initWithRawData:rawData]);
    
}

- (void)testEnumMapping
{

    NSDictionary *operationMapping = @{@"capture": @(HPFOperationTypeCapture),
                                       @"refund": @(HPFOperationTypeRefund),
                                       @"cancel": @(HPFOperationTypeCancel),
                                       @"acceptChallenge": @(HPFOperationTypeAcceptChallenge),
                                       @"denyChallenge": @(HPFOperationTypeDenyChallenge)};
    
    
    XCTAssertEqualObjects([HPFOperationMapper operationTypeMapping], operationMapping);
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"transactionReference": @"446780277416", @"operation": @"capture"};
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFOperationMapper alloc] initWithRawData:rawData]];
    HPFOperationMapper *mapper = (HPFOperationMapper *)mockedMapper;
    
    HPFOperation *operation = [[HPFOperation alloc] init];
    
    [[[mockedMapper expect] andReturn:operation] mappedObjectWithTransactionRelatedItem:[OCMArg isKindOfClass:[HPFOperation class]]];
    [[[mockedMapper expect] andReturnValue:@(HPFOperationTypeCapture)] getIntegerEnumValueWithKey:@"operation" defaultEnumValue:HPFOperationTypeUnknown allValues:[HPFOperationMapper operationTypeMapping]];

    XCTAssertEqualObjects(mapper.mappedObject, operation);
    XCTAssertEqual(operation.operation, HPFOperationTypeCapture);
    
    [mockedMapper verify];
}

@end
