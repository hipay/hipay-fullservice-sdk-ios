//
//  HPTHostedPaymentPageMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 13/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTHostedPaymentPageMapperTests : XCTestCase

@end

@implementation HPTHostedPaymentPageMapperTests

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
    NSDictionary *rawData = @{
                              @"anything": @"whatever",
                              };
    
    XCTAssertNil([[HPTHostedPaymentPageMapper alloc] initWithRawData:rawData]);
}

@end
