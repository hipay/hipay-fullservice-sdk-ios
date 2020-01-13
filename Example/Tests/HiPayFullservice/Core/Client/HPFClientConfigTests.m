//
//  HPFClientConfigTests.m
//  HiPayFullservice
//
//  Created by HiPay on 01/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFClientConfigTests : XCTestCase

@end

@implementation HPFClientConfigTests

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
    XCTAssertNotNil([HPFClientConfig sharedClientConfig]);
    XCTAssertTrue([[HPFClientConfig sharedClientConfig] isKindOfClass:[HPFClientConfig class]]);
    XCTAssertEqualObjects([HPFClientConfig sharedClientConfig], [HPFClientConfig sharedClientConfig]);
}

- (void)testSettingValues
{
    [[HPFClientConfig sharedClientConfig] setEnvironment:HPFEnvironmentProduction username:@"username" password:@"passwd" appURLscheme:@"hipayexample" paymentCardStorageEnabled:true];

    XCTAssertEqualObjects([HPFClientConfig sharedClientConfig].username, @"username");
    XCTAssertEqualObjects([HPFClientConfig sharedClientConfig].password, @"passwd");
    XCTAssertTrue([HPFClientConfig sharedClientConfig].environment == HPFEnvironmentProduction);
    XCTAssertEqualObjects([HPFClientConfig sharedClientConfig].appRedirectionURL, [NSURL URLWithString:@"hipayexample://hipay-fullservice"]);
    XCTAssertNotNil([HPFClientConfig sharedClientConfig].userAgent);
    XCTAssertTrue([HPFClientConfig sharedClientConfig].isPaymentCardStorageEnabled);
    XCTAssertFalse([[HPFClientConfig sharedClientConfig] isEqual:@""]);
}

- (void)testInitSchemeError
{
    XCTAssertThrows([[HPFClientConfig sharedClientConfig] setEnvironment:HPFEnvironmentProduction username:@"username" password:@"passwd" appURLscheme:@"hello-test" paymentCardStorageEnabled:true] );
    XCTAssertThrows([[HPFClientConfig sharedClientConfig] setEnvironment:HPFEnvironmentProduction username:@"username" password:@"passwd" appURLscheme:@"test1" paymentCardStorageEnabled:true]);
    XCTAssertThrows([[HPFClientConfig sharedClientConfig] setEnvironment:HPFEnvironmentProduction username:@"username" password:@"passwd" appURLscheme:@"donotexist" paymentCardStorageEnabled:true]);
}

@end
