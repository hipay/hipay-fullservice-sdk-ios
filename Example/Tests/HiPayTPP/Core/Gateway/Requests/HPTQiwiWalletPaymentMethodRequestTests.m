//
//  HPTQiwiWalletPaymentMethodRequestTests.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 29/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTQiwiWalletPaymentMethodRequestTests : XCTestCase

@end

@implementation HPTQiwiWalletPaymentMethodRequestTests

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
    HPTQiwiWalletPaymentMethodRequest *object = [[HPTQiwiWalletPaymentMethodRequest alloc] init];
    
    object.username = @"test1";
    
    XCTAssertEqualObjects([object valueForKey:@"username"], @"test1");
}

- (void)testInit
{
    HPTQiwiWalletPaymentMethodRequest *result = [HPTQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestWithUsername:@"+789"];
    
    XCTAssertEqualObjects(result.username, @"+789");
}

@end
