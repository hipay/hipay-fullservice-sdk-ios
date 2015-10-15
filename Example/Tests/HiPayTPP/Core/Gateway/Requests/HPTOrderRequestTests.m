//
//  HPTOrderRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTOrderRequestTests : XCTestCase

@end

@implementation HPTOrderRequestTests

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
    HPTOrderRequest *object = [[HPTOrderRequest alloc] init];
    
    object.paymentProduct = @"test1";
    
    XCTAssertEqualObjects([object valueForKey:@"paymentProduct"], @"test1");
}

@end
