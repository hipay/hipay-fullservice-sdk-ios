//
//  HPTHTTPResponseTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 28/09/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTHTTPResponseTests : XCTestCase

@end

@implementation HPTHTTPResponseTests

- (void)testInit {
    
    HPTHTTPResponse *response = [[HPTHTTPResponse alloc] initWithStatusCode:200 body:@{@"key":@"value"}];
   
    XCTAssertTrue([response isKindOfClass:[HPTHTTPResponse class]]);
    XCTAssertTrue(response.statusCode == 200);
    XCTAssertEqualObjects(response.body, @{@"key":@"value"});
}

@end
