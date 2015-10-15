//
//  HPTPersonalInfoRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTPersonalInfoRequestTests : XCTestCase

@end

@implementation HPTPersonalInfoRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testKeyPaths
{
    HPTPersonalInfoRequest *object = [[HPTPersonalInfoRequest alloc] init];
    
    object.firstname = @"test1";
    object.lastname = @"test2";
    object.streetAddress = @"test3";
    object.streetAddress2 = @"test4";
    object.recipientInfo = @"test5";
    object.city = @"test6";
    object.state = @"test7";
    object.zipCode = @"test8";
    object.country = @"test9";

    XCTAssertEqualObjects([object valueForKey:@"firstname"], @"test1");
    XCTAssertEqualObjects([object valueForKey:@"lastname"], @"test2");
    XCTAssertEqualObjects([object valueForKey:@"streetAddress"], @"test3");
    XCTAssertEqualObjects([object valueForKey:@"streetAddress2"], @"test4");
    XCTAssertEqualObjects([object valueForKey:@"recipientInfo"], @"test5");
    XCTAssertEqualObjects([object valueForKey:@"city"], @"test6");
    XCTAssertEqualObjects([object valueForKey:@"state"], @"test7");
    XCTAssertEqualObjects([object valueForKey:@"zipCode"], @"test8");
    XCTAssertEqualObjects([object valueForKey:@"country"], @"test9");
}

@end
