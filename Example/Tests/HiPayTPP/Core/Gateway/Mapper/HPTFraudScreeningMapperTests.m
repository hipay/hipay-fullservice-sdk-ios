//
//  HPTFraudScreeningMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTFraudScreeningMapperTests : XCTestCase

@end

@implementation HPTFraudScreeningMapperTests

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
    NSDictionary *rawData1 = @{
                              @"wrongData": @"anything",
                              };
    
    NSDictionary *rawData2 = @{
                              @"scoring": @(200),
                              };
    
    NSDictionary *rawData3 = @{
                              @"result": @"ACCEPTED",
                              };
    
    XCTAssertNil([[HPTFraudScreeningMapper alloc] initWithRawData:rawData1]);
    XCTAssertNil([[HPTFraudScreeningMapper alloc] initWithRawData:rawData2]);
    XCTAssertNil([[HPTFraudScreeningMapper alloc] initWithRawData:rawData3]);
    
}

- (void)testEnumMapping
{
    NSDictionary *resultMapping = @{@"pending": @(HPTFraudScreeningReviewPending),
                                    @"accepted": @(HPTFraudScreeningResultAccepted),
                                    @"challenged": @(HPTFraudScreeningResultChallenged),
                                    @"blocked": @(HPTFraudScreeningResultBlocked)};
    
    NSDictionary *reviewMapping = @{@"pending": @(HPTFraudScreeningReviewPending),
                                    @"allowed": @(HPTFraudScreeningReviewAllowed),
                                    @"denied": @(HPTFraudScreeningReviewDenied)};
    
    XCTAssertEqualObjects([HPTFraudScreeningMapper resultMapping], resultMapping);
    XCTAssertEqualObjects([HPTFraudScreeningMapper reviewMapping], reviewMapping);
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"scoring": @(200),
                              @"result": @"CHALLENGED",
                              @"review": @"PENDING"
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTFraudScreeningMapper alloc] initWithRawData:rawData]];
    HPTFraudScreeningMapper *mapper = (HPTFraudScreeningMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturnValue:@(200)] getIntegerForKey:@"scoring"];
    [[[mockedMapper expect] andReturnValue:@(HPTFraudScreeningResultChallenged)] getIntegerEnumValueWithKey:@"result" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper resultMapping]];
    [[[mockedMapper expect] andReturnValue:@(HPTFraudScreeningReviewPending)] getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper reviewMapping]];
    
    HPTFraudScreening *fraudScreening = mapper.mappedObject;
    
    XCTAssertEqual(fraudScreening.scoring, 200);
    XCTAssertEqual(fraudScreening.result, HPTFraudScreeningResultChallenged);
    XCTAssertEqual(fraudScreening.review, HPTFraudScreeningReviewPending);
    
    [mockedMapper verify];
}

@end
