//
//  HPTPaymentCardTokenMapper.m
//  HiPayTPP
//
//  Created by Jonathan TIRET on 01/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayTPP/HiPayTPP.h>
#import <OCMock/OCMock.h>
#import <HiPayTPP/HPTAbstractMapper+Decode.h>

@interface HPTPaymentCardTokenMapperTests : XCTestCase

@end

@implementation HPTPaymentCardTokenMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithWrongData
{
    NSDictionary *rawData = @{
                              @"wrongData": @"anything",
                              };
    
    XCTAssertNil([[HPTPaymentCardTokenMapper alloc] initWithRawData:rawData]);
    
}

- (void)testMapping
{
    NSDictionary *rawData = @{
                              @"token": @"mqlakjgbag985654apskamqpakfjf8bbloaproi",
                              @"brand": @"American Express",
                              @"request_id":@"2U6YRQAWTGDXTAG6RZQ4RQX",
                              @"pan": @"549619******4769",
                              @"card_holder": @"John Doe",
                              @"card_expiry_month": @"05",
                              @"card_expiry_year": @"2018",
                              @"issuer": @"ACME Bank",
                              @"country": @"FR",
                              @"domesticNetwork": @"cb"
                              };
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPTPaymentCardTokenMapper alloc] initWithRawData:rawData]];
    
    for (id key in [rawData allKeys]) {
        [((HPTPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:[rawData objectForKey:key]]) getStringForKey:key];
    }
    
    HPTPaymentCardToken *paymentCardToken = ((HPTPaymentCardTokenMapper *)mockedMapper).mappedObject;
    
    XCTAssertEqualObjects([rawData objectForKey:@"token"], paymentCardToken.token);
    XCTAssertEqualObjects([rawData objectForKey:@"brand"], paymentCardToken.brand);
    XCTAssertEqualObjects([rawData objectForKey:@"pan"], paymentCardToken.pan);
    XCTAssertEqualObjects([rawData objectForKey:@"request_id"], paymentCardToken.requestID);
    XCTAssertEqualObjects([rawData objectForKey:@"card_holder"], paymentCardToken.cardHolder);
    XCTAssertEqualObjects([rawData objectForKey:@"card_expiry_month"], paymentCardToken.cardExpiryMonth);
    XCTAssertEqualObjects([rawData objectForKey:@"card_expiry_year"], paymentCardToken.cardExpiryYear);
    XCTAssertEqualObjects([rawData objectForKey:@"issuer"], paymentCardToken.issuer);
    XCTAssertEqualObjects([rawData objectForKey:@"country"], paymentCardToken.country);
    XCTAssertEqualObjects([rawData objectForKey:@"domesticNetwork"], paymentCardToken.domesticNetwork);
    
    [mockedMapper verify];
}

@end
