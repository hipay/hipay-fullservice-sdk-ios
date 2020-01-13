//
//  HPFCustomerInfoRequestTests.m
//  HiPayFullservice
//
//  Created by HiPay on 15/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFCustomerInfoRequestTests : XCTestCase

@end

@implementation HPFCustomerInfoRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultValues
{
    HPFCustomerInfoRequest *object = [[HPFCustomerInfoRequest alloc] init];
    
    XCTAssertEqualObjects([object valueForKey:@"gender"], @(HPFGenderUndefined));
}

- (void)testKeyPaths
{
    HPFCustomerInfoRequest *object = [[HPFCustomerInfoRequest alloc] init];
    
    object.email = @"test1";
    object.phone = @"test2";
    object.birthDateDay = @(12);
    object.birthDateMonth = @(8);
    object.birthDateYear = @(1980);
    object.gender = HPFGenderFemale;
    
    XCTAssertEqualObjects([object valueForKey:@"email"], @"test1");
    XCTAssertEqualObjects([object valueForKey:@"phone"], @"test2");
    XCTAssertEqualObjects([object valueForKey:@"birthDateDay"], @(12));
    XCTAssertEqualObjects([object valueForKey:@"birthDateMonth"], @(8));
    XCTAssertEqualObjects([object valueForKey:@"birthDateYear"], @(1980));
    XCTAssertEqualObjects([object valueForKey:@"gender"], @(HPFGenderFemale));
}

@end
