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
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testInitArrayData {
    
    id rawData = @[];
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testInitStringData {
    
    id rawData = @"";
    
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertNil(mapper);
    XCTAssertNil(mapper.rawData);
}

- (void)testShouldSuclass {
    NSDictionary *rawData = @{@"test": @(123)};
    HPTAbstractMapper *mapper = [[HPTAbstractMapper alloc] initWithRawData:rawData];
    
    XCTAssertThrows(mapper.mappedObject);
}

- (void)testValues {
    NSDictionary *rawData = @{
                              @"charValue": @"U",
                              @"wrongCharValue": @"UO",
                              @"stringNumber": @"25.89",
                              @"number": @(25.89),
                              @"test": @"Hello World",
                              @"null": [NSNull null]
                              };
    
    HPTAbstractMapper *mapper = [OCMockObject partialMockForObject:[[HPTAbstractMapper alloc] initWithRawData:rawData]];
    
    [((HPTAbstractMapper *)[[(OCMockObject *)mapper expect] andReturn:rawData]) rawData];
    
    // Strings
    XCTAssertEqualObjects([mapper getObjectForKey:@"test"], @"Hello World");
    XCTAssertEqualObjects([mapper getStringForKey:@"test"], @"Hello World");
    XCTAssertNil([mapper getStringForKey:@"number"]);
    
    // Undefined values
    XCTAssertNil([mapper getObjectForKey:@"null"]);
    XCTAssertNil([mapper getObjectForKey:@"unknwon_value"]);

    // Chars
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"charValue"], @('U'));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"wrongCharValue"], @(-1));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"number"], @(-1));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"test"], @(-1));
    XCTAssertEqualObjects([mapper getEnumCharForKey:@"null"], @(-1));
}

@end
