//
//  HPFPersonalInformationTests.m
//  HiPayFullservice
//
//  Created by HiPay on 10/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPFPersonalInformationTests : XCTestCase
{
    OCMockObject *mockedObject;
    HPFPersonalInformation *object;
}

@end

@implementation HPFPersonalInformationTests

- (void)setUp {
    [super setUp];

    mockedObject = [OCMockObject partialMockForObject:[[HPFPersonalInformation alloc] init]];
    object = (HPFPersonalInformation *)mockedObject;
}

@end
