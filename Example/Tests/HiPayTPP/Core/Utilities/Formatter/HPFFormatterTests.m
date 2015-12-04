//
//  HPFFormatterTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPFFormatter.h>

@interface HPFFormatterTests : XCTestCase

@end

@implementation HPFFormatterTests

- (void)testDigitsOnlyNumberForPlainTextNumber
{
    HPFFormatter *formatter = [[HPFFormatter alloc] init];
    
    XCTAssertEqualObjects([formatter digitsOnlyFromPlainText:@"4111 1111 1111 1111"], @"4111111111111111");
    XCTAssertEqualObjects([formatter digitsOnlyFromPlainText:@"4111"], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyFromPlainText:@" 4111 "], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyFromPlainText:@" 41 11 "], @"4111");
    XCTAssertEqualObjects([formatter digitsOnlyFromPlainText:@" 41a11 "], @"4111");
}

@end
