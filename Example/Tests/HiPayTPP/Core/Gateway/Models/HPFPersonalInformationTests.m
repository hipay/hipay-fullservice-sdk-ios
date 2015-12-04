//
//  HPFPersonalInformationTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 10/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFPersonalInformationTests : XCTestCase
{
    OCMockObject *mockedObject;
    HPFPersonalInformation *object;
}

@end

@implementation HPFPersonalInformationTests

- (void)setUp {
    [super setUp];

    mockedObject = [OCMockObject partialMockForObject:[[HPFPersonalInformation alloc] init]];
    object = (HPFPersonalInformation *)mockedObject;
}

- (void)testDisplayName
{
    [[[mockedObject expect] andReturn:@"Jean-Pierre"] firstname];
    [[[mockedObject expect] andReturn:@"Dupont"] lastname];
    XCTAssertEqualObjects(object.displayName, @"Jean-Pierre Dupont");
    [mockedObject verify];
    
    [[[mockedObject expect] andReturn:@""] firstname];
    [[[mockedObject expect] andReturn:@"Dupont"] lastname];
    XCTAssertEqualObjects(object.displayName, @"Dupont");
    [mockedObject verify];
    
    [[[mockedObject expect] andReturn:@"Jean-Pierre"] firstname];
    [[[mockedObject expect] andReturn:nil] lastname];
    XCTAssertEqualObjects(object.displayName, @"Jean-Pierre");
    [mockedObject verify];
    
    [[[mockedObject expect] andReturn:nil] firstname];
    [[[mockedObject expect] andReturn:@""] lastname];
    XCTAssertNil(object.displayName);
    [mockedObject verify];
    
    
}

@end
