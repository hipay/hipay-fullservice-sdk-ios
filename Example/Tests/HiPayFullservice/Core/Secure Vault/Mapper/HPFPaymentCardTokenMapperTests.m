//
//  HPFPaymentCardTokenMapper.m
//  HiPayFullservice
//
//  Created by HiPay on 01/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HiPayFullservice/HiPayFullservice.h>
#import <OCMock/OCMock.h>
#import <HiPayFullservice/HPFAbstractMapper+Decode.h>

@interface HPFPaymentCardTokenMapperTests : XCTestCase

@end

@implementation HPFPaymentCardTokenMapperTests

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
    
    XCTAssertNil([[HPFPaymentCardTokenMapper alloc] initWithRawData:rawData]);
    
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
    
    OCMockObject *mockedMapper = [OCMockObject partialMockForObject:[[HPFPaymentCardTokenMapper alloc] initWithRawData:rawData]];
    
    for (id key in [rawData allKeys]) {
        if (![key isEqualToString:@"card_expiry_month"] && ![key isEqualToString:@"card_expiry_year"]) {
            [((HPFPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:[rawData objectForKey:key]]) getStringForKey:key];
        }
    }
    
    [((HPFPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:@(2018)]) getNumberForKey:@"card_expiry_year"];
    [((HPFPaymentCardTokenMapper *)[[mockedMapper expect] andReturn:@(5)]) getNumberForKey:@"card_expiry_month"];
    
    HPFPaymentCardToken *paymentCardToken = ((HPFPaymentCardTokenMapper *)mockedMapper).mappedObject;
    
    XCTAssertEqualObjects([rawData objectForKey:@"token"], paymentCardToken.token);
    XCTAssertEqualObjects([rawData objectForKey:@"brand"], paymentCardToken.brand);
    XCTAssertEqualObjects([rawData objectForKey:@"pan"], paymentCardToken.pan);
    XCTAssertEqualObjects([rawData objectForKey:@"request_id"], paymentCardToken.requestID);
    XCTAssertEqualObjects([rawData objectForKey:@"card_holder"], paymentCardToken.cardHolder);
    XCTAssertEqualObjects(@5, paymentCardToken.cardExpiryMonth);
    XCTAssertEqualObjects(@2018, paymentCardToken.cardExpiryYear);
    XCTAssertEqualObjects([rawData objectForKey:@"issuer"], paymentCardToken.issuer);
    XCTAssertEqualObjects([rawData objectForKey:@"country"], paymentCardToken.country);
    XCTAssertEqualObjects([rawData objectForKey:@"domesticNetwork"], paymentCardToken.domesticNetwork);
    
    [mockedMapper verify];
}

@end
