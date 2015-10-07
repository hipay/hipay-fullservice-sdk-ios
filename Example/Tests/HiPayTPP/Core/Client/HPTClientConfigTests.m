//
//  HPTClientConfigTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 01/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPTClientConfigTests : XCTestCase

@end

@implementation HPTClientConfigTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClientInit
{
    XCTAssertNotNil([HPTClientConfig sharedClientConfig]);
    XCTAssertTrue([[HPTClientConfig sharedClientConfig] isKindOfClass:[HPTClientConfig class]]);
    XCTAssertEqualObjects([HPTClientConfig sharedClientConfig], [HPTClientConfig sharedClientConfig]);
}

- (void)testSettingValues
{
    [[HPTClientConfig sharedClientConfig] setEnvironment:HPTEnvironmentProduction username:@"username" password:@"passwd"];
    
    XCTAssertEqualObjects([HPTClientConfig sharedClientConfig].username, @"username");
    XCTAssertEqualObjects([HPTClientConfig sharedClientConfig].password, @"passwd");
    XCTAssertTrue([HPTClientConfig sharedClientConfig].environment == HPTEnvironmentProduction);

}

@end
