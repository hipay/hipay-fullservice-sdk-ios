//
//  HPFFraudScreeningMapperTests.m
//  HiPayFullservice
//
//  Created by HiPay on 09/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>

@interface HPFFraudScreeningMapperTests : XCTestCase

@end

@implementation HPFFraudScreeningMapperTests

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
    
    XCTAssertNil([[HPFFraudScreeningMapper alloc] initWithRawData:rawData1]);
    XCTAssertNil([[HPFFraudScreeningMapper alloc] initWithRawData:rawData2]);
    XCTAssertNil([[HPFFraudScreeningMapper alloc] initWithRawData:rawData3]);
    
}

- (void)testEnumMapping
{
    NSDictionary *resultMapping = @{@"pending": @(HPFFraudScreeningResultPending),
                                    @"accepted": @(HPFFraudScreeningResultAccepted),
                                    @"challenged": @(HPFFraudScreeningResultChallenged),
                                    @"blocked": @(HPFFraudScreeningResultBlocked)};
    
    NSDictionary *reviewMapping = @{@"pending": @(HPFFraudScreeningReviewPending),
                                    @"allowed": @(HPFFraudScreeningReviewAllowed),
                                    @"denied": @(HPFFraudScreeningReviewDenied)};
    
    XCTAssertEqualObjects([HPFFraudScreeningMapper resultMapping], resultMapping);
    XCTAssertEqualObjects([HPFFraudScreeningMapper reviewMapping], reviewMapping);
}

- (void)testMapping
{
    NSDictionary *rawData = @{@"scoring": @(200),
                              @"result": @"CHALLENGED",
                              @"review": @"PENDING"
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFFraudScreeningMapper alloc] initWithRawData:rawData]];
    HPFFraudScreeningMapper *mapper = (HPFFraudScreeningMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturnValue:@(200)] getIntegerForKey:@"scoring"];
    [[[mockedMapper expect] andReturnValue:@(HPFFraudScreeningResultChallenged)] getIntegerEnumValueWithKey:@"result" defaultEnumValue:HPFFraudScreeningResultUnknown allValues:[HPFFraudScreeningMapper resultMapping]];
    [[[mockedMapper expect] andReturnValue:@(HPFFraudScreeningReviewPending)] getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPFFraudScreeningResultUnknown allValues:[HPFFraudScreeningMapper reviewMapping]];
    
    HPFFraudScreening *fraudScreening = mapper.mappedObject;
    
    XCTAssertEqual(fraudScreening.scoring, 200);
    XCTAssertEqual(fraudScreening.result, HPFFraudScreeningResultChallenged);
    XCTAssertEqual(fraudScreening.review, HPFFraudScreeningReviewPending);
    
    [mockedMapper verify];
}

@end
