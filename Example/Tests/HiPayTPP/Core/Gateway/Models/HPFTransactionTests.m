//
//  HPFTransactionTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 18/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFTransactionTests : XCTestCase
{
    OCMockObject *mockedObject;
    HPFTransaction *object;
}

@end

@implementation HPFTransactionTests

- (void)setUp {
    [super setUp];

    mockedObject = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    object = (HPFTransaction *)mockedObject;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsHandledCompleted
{
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(HPFTransactionStateCompleted)] state];
    XCTAssertTrue(object.handled);
}

- (void)testIsHandledPending
{
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(HPFTransactionStatePending)] state];
    XCTAssertTrue(object.handled);
}

- (void)testIsHandledDeclined
{
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(HPFTransactionStateDeclined)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsHandledError
{
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(HPFTransactionStateError)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsHandledForwarding
{
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(HPFTransactionStateForwarding)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsRelevant
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object2 = (HPFTransaction *)mockedObject2;
    

    [(HPFTransaction *)[[mockedObject expect] andReturnValue:@(YES)] isHandled];
    [(HPFTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    XCTAssertTrue([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

- (void)testIsRelevant2
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object2 = (HPFTransaction *)mockedObject2;
    
    [(HPFTransaction *)[[mockedObject stub] andReturnValue:@(NO)] isHandled];
    [(HPFTransaction *)[[mockedObject2 expect] andReturnValue:@(YES)] isHandled];
    
    XCTAssertFalse([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

- (void)testIsRelevant3
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object2 = (HPFTransaction *)mockedObject2;
    
    [(HPFTransaction *)[[mockedObject expect] andReturnValue:@(NO)] isHandled];
    [(HPFTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    [(HPFTransaction *)[[mockedObject expect] andReturn:[NSDate dateWithTimeIntervalSince1970:500.0]] dateCreated];
    [(HPFTransaction *)[[mockedObject2 expect] andReturn:[NSDate dateWithTimeIntervalSince1970:5000.0]] dateCreated];
    
    XCTAssertFalse([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
}

- (void)testIsRelevant4
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object2 = (HPFTransaction *)mockedObject2;
    
    [(HPFTransaction *)[[mockedObject expect] andReturnValue:@(NO)] isHandled];
    [(HPFTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    [(HPFTransaction *)[[mockedObject expect] andReturn:[NSDate dateWithTimeIntervalSince1970:5000.0]] dateCreated];
    [(HPFTransaction *)[[mockedObject2 expect] andReturn:[NSDate dateWithTimeIntervalSince1970:500.0]] dateCreated];
    
    XCTAssertTrue([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
}

- (void)testSortByRelevance
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object2 = (HPFTransaction *)mockedObject2;
    
    OCMockObject *mockedObject3 = [OCMockObject partialMockForObject:[[HPFTransaction alloc] init]];
    HPFTransaction *object3 = (HPFTransaction *)mockedObject3;
    
    [[[mockedObject stub] andReturnValue:@(YES)] isMoreRelevantThan:object2];
    [[[mockedObject stub] andReturnValue:@(YES)] isMoreRelevantThan:object3];
    
    [[[mockedObject2 stub] andReturnValue:@(NO)] isMoreRelevantThan:object];
    [[[mockedObject2 stub] andReturnValue:@(YES)] isMoreRelevantThan:object3];
    
    [[[mockedObject3 stub] andReturnValue:@(NO)] isMoreRelevantThan:object];
    [[[mockedObject3 stub] andReturnValue:@(NO)] isMoreRelevantThan:object2];
    
    NSArray *input = @[object3, object, object2];
    NSArray *expectedResult = @[object, object2, object3];
    
    XCTAssertEqualObjects([HPFTransaction sortTransactionsByRelevance:input], expectedResult);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

@end
