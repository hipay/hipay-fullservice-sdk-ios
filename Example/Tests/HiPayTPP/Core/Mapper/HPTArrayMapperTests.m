//
//  HPTArrayMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 21/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTArrayMapper.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTArrayMapperTests : XCTestCase

@end

@implementation HPTArrayMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
    XCTAssertNil([[HPTArrayMapper alloc] initWithRawData:@{} objectMapperClass:[NSObject class]]);
    XCTAssertNil([[HPTArrayMapper alloc] initWithRawData:@"" objectMapperClass:[HPTThreeDSecureMapper class]]);
    XCTAssertNotNil([[HPTArrayMapper alloc] initWithRawData:@{} objectMapperClass:[HPTThreeDSecureMapper class]]);
}

- (void)testMapping
{
    NSArray *inputRawData = @[@"whatever"];
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTArrayMapper alloc] initWithRawData:inputRawData objectMapperClass:[HPTThreeDSecureMapper class]]];
    HPTArrayMapper *mapper = (HPTArrayMapper *)mockedMapper;
    
    [[[mockedMapper expect] andReturn:@[]] getObjectsArrayForObject:inputRawData];
    XCTAssertEqualObjects(mapper.mappedObject, @[]);
    [mockedMapper verify];
    
    [[[mockedMapper expect] andReturn:@[@{}, @{}]] getObjectsArrayForObject:inputRawData];
    XCTAssertEqualObjects(mapper.mappedObject, @[]);
    [mockedMapper verify];

    NSDictionary *rawData1 = @{@"key1": @"val1"};
    NSDictionary *rawData2 = @{@"key2": @"val2"};
 
    NSObject *result1 = [[NSObject alloc] init];
    NSObject *result2 = [[NSObject alloc] init];

    OCMockObject *mockedObjectMapper1 = [OCMockObject mockForClass:[HPTAbstractMapper class]];
    OCMockObject *mockedObjectMapper2 = [OCMockObject mockForClass:[HPTAbstractMapper class]];
    
    [[[mockedObjectMapper1 expect] andReturn:result1] mappedObject];
    [[[mockedObjectMapper2 expect] andReturn:result2] mappedObject];
    
    id classMock = OCMClassMock([HPTThreeDSecureMapper class]);
    OCMStub([classMock mapperWithRawData:rawData1]).andReturn(mockedObjectMapper1);
    OCMStub([classMock mapperWithRawData:rawData2]).andReturn(mockedObjectMapper2);
    
    [[[mockedMapper expect] andReturn:@[rawData1, rawData2]] getObjectsArrayForObject:inputRawData];

    NSArray *finalArray = @[result1, result2];
    XCTAssertEqualObjects(mapper.mappedObject, finalArray);

    [mockedMapper verify];
    OCMVerify([classMock mapperWithRawData:rawData1]);
    OCMVerify([classMock mapperWithRawData:rawData2]);
}

@end
