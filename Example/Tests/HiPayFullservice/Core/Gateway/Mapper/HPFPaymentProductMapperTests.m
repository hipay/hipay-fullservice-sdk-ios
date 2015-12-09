//
//  HPFPaymentProductMapperTests.m
//  HiPayFullservice
//
//  Created by Jonathan TIRET on 20/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>

@interface HPFPaymentProductMapperTests : XCTestCase

@end

@implementation HPFPaymentProductMapperTests

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
                              @"code": @"visa",
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFPaymentProductMapper alloc] initWithRawData:rawData]];
    
    [[[mockedMapper expect] andReturn:@"visa"] getStringForKey:@"code"];
    [[[mockedMapper expect] andReturn:@"VISA"] getStringForKey:@"description"];
    [[[mockedMapper expect] andReturn:@"9874POAL"] getStringForKey:@"id"];
    [[[mockedMapper expect] andReturn:@"credit-card"] getStringForKey:@"paymentProductCategoryCode"];
    [[[mockedMapper expect] andReturnValue:@YES] getBoolForKey:@"tokenizable"];
    
    HPFPaymentProduct *paymentProduct = ((HPFPaymentProductMapper *)mockedMapper).mappedObject;
    
    XCTAssertEqualObjects(paymentProduct.code, @"visa");
    XCTAssertEqualObjects(paymentProduct.paymentProductDescription, @"VISA");
    XCTAssertEqualObjects(paymentProduct.paymentProductId, @"9874POAL");
    XCTAssertEqualObjects(paymentProduct.paymentProductCategoryCode, @"credit-card");
    XCTAssertEqual(paymentProduct.tokenizable, YES);
    
    [mockedMapper verify];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPFPaymentProductMapper alloc] initWithRawData:rawData]);
    
}


@end
