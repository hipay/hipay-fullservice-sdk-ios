//
//  HPTPaymentProductMapperTests.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 20/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTPaymentProductMapperTests : XCTestCase

@end

@implementation HPTPaymentProductMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"resource": @"visa",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTPaymentProductMapper alloc] initWithRawData:rawData]];
    
    [[[mockedMapper expect] andReturn:@"visa"] getStringForKey:@"resource"];
    [[[mockedMapper expect] andReturn:@"VISA"] getStringForKey:@"paymentProductDescription"];
    [[[mockedMapper expect] andReturn:@"9874POAL"] getStringForKey:@"paymentProductId"];
    [[[mockedMapper expect] andReturnValue:@YES] getBoolForKey:@"tokenizable"];
    
    HPTPaymentProduct *paymentProduct = ((HPTPaymentProductMapper *)mockedMapper).mappedObject;

    XCTAssertEqualObjects(paymentProduct.resource, @"visa");
    XCTAssertEqualObjects(paymentProduct.paymentProductDescription, @"VISA");
    XCTAssertEqualObjects(paymentProduct.paymentProductId, @"9874POAL");
    XCTAssertEqual(paymentProduct.tokenizable, YES);
    
    [mockedMapper verify];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPTPaymentProductMapper alloc] initWithRawData:rawData]);
    
}


@end
