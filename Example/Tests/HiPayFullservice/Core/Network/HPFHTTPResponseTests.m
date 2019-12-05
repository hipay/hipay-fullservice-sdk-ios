//
//  HPFHTTPResponseTests.m
//  HiPayFullservice
//
//  Created by HiPay on 28/09/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFHTTPResponseTests : XCTestCase

@end

@implementation HPFHTTPResponseTests

- (void)testInit {
    
    HPFHTTPResponse *response = [[HPFHTTPResponse alloc] initWithStatusCode:200 body:@{@"key":@"value"}];
   
    XCTAssertTrue([response isKindOfClass:[HPFHTTPResponse class]]);
    XCTAssertTrue(response.statusCode == 200);
    XCTAssertEqualObjects(response.body, @{@"key":@"value"});
}

@end
