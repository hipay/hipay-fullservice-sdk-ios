//
//  HPFMutableDictionarySerialization.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 15/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <NSMutableDictionary+Serialization.h>

@interface HPFMutableDictionarySerialization : XCTestCase

@end

@implementation HPFMutableDictionarySerialization

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetNullable
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setNullableObject:nil forKey:@"nilkey"];
    XCTAssertNil([dictionary objectForKey:@"nilkey"]);
    
    [dictionary setNullableObject:@"hello" forKey:@"string"];
    XCTAssertEqualObjects([dictionary objectForKey:@"string"], @"hello");
}

- (void)testMerge
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary mergeDictionary:@{@"hello": @"world", @"test": @"ok"} withPrefix:nil];
    [dictionary mergeDictionary:@{@"test2": @"val2", @"test3": @"val3"} withPrefix:@"pref_"];
    [dictionary mergeDictionary:nil withPrefix:@"pref_"];
    
    XCTAssertEqualObjects([dictionary objectForKey:@"hello"], @"world");
    XCTAssertEqualObjects([dictionary objectForKey:@"test"], @"ok");
    XCTAssertEqualObjects([dictionary objectForKey:@"pref_test2"], @"val2");
    XCTAssertEqualObjects([dictionary objectForKey:@"pref_test3"], @"val3");
    
}

@end
