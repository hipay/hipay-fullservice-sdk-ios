//
//  HPFOrderRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFOrderRequestTests : XCTestCase

@end

@implementation HPFOrderRequestTests

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
    HPFOrderRequest *object = [[HPFOrderRequest alloc] init];
    
    object.paymentProductCode = @"test1";
    
    XCTAssertEqualObjects([object valueForKey:@"paymentProductCode"], @"test1");
}

@end
