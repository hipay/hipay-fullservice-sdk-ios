//
//  HPTMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 01/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HiPayTPP.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>
#import <OCMock/OCMock.h>

@interface HPTMapperTests : XCTestCase

@end

@implementation HPTMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    NSDictionary *rawData = @{@"test": @(123)};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertEqualObjects(mapper.rawData, rawData);
}

- (void)testInitNilData {
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:nil];
    
    XCTAssertNil(mapper.rawData);
}

- (void)testShouldSuclass {
    NSDictionary *rawData = @{@"test": @(123)};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertThrows(mapper.mappedObject);
}

- (void)testValues {
    NSDictionary *rawData = @{
                              @"test": @"Hello World",
                              @"null": [NSNull null]
                              };
    
    HPTAbstractMapper *mapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:rawData]];
    
    [((HPTAbstractMapper *)[[(OCMockObject *)mapper expect] andReturn:rawData]) rawData];
    
    XCTAssertEqualObjects([mapper getObjectForKey:@"test"], @"Hello World");
    XCTAssertNil([mapper getObjectForKey:@"null"]);
    XCTAssertNil([mapper getObjectForKey:@"unknwon_value"]);
}

@end
