//
//  HPTTransactionTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 18/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTTransactionTests : XCTestCase
{
    OCMockObject *mockedObject;
    HPTTransaction *object;
}

@end

@implementation HPTTransactionTests

- (void)setUp {
    [super setUp];

    mockedObject = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    object = (HPTTransaction *)mockedObject;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsHandledCompleted
{
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(HPTTransactionStateCompleted)] state];
    XCTAssertTrue(object.handled);
}

- (void)testIsHandledPending
{
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(HPTTransactionStatePending)] state];
    XCTAssertTrue(object.handled);
}

- (void)testIsHandledDeclined
{
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(HPTTransactionStateDeclined)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsHandledError
{
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(HPTTransactionStateError)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsHandledForwarding
{
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(HPTTransactionStateForwarding)] state];
    XCTAssertFalse(object.handled);
}

- (void)testIsRelevant
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object2 = (HPTTransaction *)mockedObject2;
    

    [(HPTTransaction *)[[mockedObject expect] andReturnValue:@(YES)] isHandled];
    [(HPTTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    XCTAssertTrue([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

- (void)testIsRelevant2
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object2 = (HPTTransaction *)mockedObject2;
    
    [(HPTTransaction *)[[mockedObject stub] andReturnValue:@(NO)] isHandled];
    [(HPTTransaction *)[[mockedObject2 expect] andReturnValue:@(YES)] isHandled];
    
    XCTAssertFalse([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

- (void)testIsRelevant3
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object2 = (HPTTransaction *)mockedObject2;
    
    [(HPTTransaction *)[[mockedObject expect] andReturnValue:@(NO)] isHandled];
    [(HPTTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    [(HPTTransaction *)[[mockedObject expect] andReturn:[NSDate dateWithTimeIntervalSince1970:500.0]] dateCreated];
    [(HPTTransaction *)[[mockedObject2 expect] andReturn:[NSDate dateWithTimeIntervalSince1970:5000.0]] dateCreated];
    
    XCTAssertFalse([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
}

- (void)testIsRelevant4
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object2 = (HPTTransaction *)mockedObject2;
    
    [(HPTTransaction *)[[mockedObject expect] andReturnValue:@(NO)] isHandled];
    [(HPTTransaction *)[[mockedObject2 expect] andReturnValue:@(NO)] isHandled];
    
    [(HPTTransaction *)[[mockedObject expect] andReturn:[NSDate dateWithTimeIntervalSince1970:5000.0]] dateCreated];
    [(HPTTransaction *)[[mockedObject2 expect] andReturn:[NSDate dateWithTimeIntervalSince1970:500.0]] dateCreated];
    
    XCTAssertTrue([object isMoreRelevantThan:object2]);
    
    [mockedObject verify];
    [mockedObject2 verify];
}

- (void)testSortByRelevance
{
    OCMockObject *mockedObject2 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object2 = (HPTTransaction *)mockedObject2;
    
    OCMockObject *mockedObject3 = [OCMockObject partialMockForObject:[[HPTTransaction alloc] init]];
    HPTTransaction *object3 = (HPTTransaction *)mockedObject3;
    
    [[[mockedObject stub] andReturnValue:@(YES)] isMoreRelevantThan:object2];
    [[[mockedObject stub] andReturnValue:@(YES)] isMoreRelevantThan:object3];
    
    [[[mockedObject2 stub] andReturnValue:@(NO)] isMoreRelevantThan:object];
    [[[mockedObject2 stub] andReturnValue:@(YES)] isMoreRelevantThan:object3];
    
    [[[mockedObject3 stub] andReturnValue:@(NO)] isMoreRelevantThan:object];
    [[[mockedObject3 stub] andReturnValue:@(NO)] isMoreRelevantThan:object2];
    
    NSArray *input = @[object3, object, object2];
    NSArray *expectedResult = @[object, object2, object3];
    
    XCTAssertEqualObjects([HPTTransaction sortTransactionsByRelevance:input], expectedResult);
    
    [mockedObject verify];
    [mockedObject2 verify];
    
}

@end
