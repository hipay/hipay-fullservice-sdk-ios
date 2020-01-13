//
//  HPFStats.m
//  HiPayFullservice_Example
//
//  Created by HiPay on 02/09/2019.
//  Copyright © 2019 HiPay. All rights reserved.
//

#import "HPFStats.h"
#import <CommonCrypto/CommonDigest.h>
#import "HPFClientConfig.h"

#define kIdentifierKey @"id"
#define kDomainKey @"domain"
#define kStatusKey @"status"
#define kPaymentMethodKey @"payment_method"
#define kCardCountryKey @"card_country"
#define kAmountKey @"amount"
#define kCurrencyKey @"currency"
#define kOrderIDKey @"order_id"
#define kTransactionIDKey @"transaction_id"
#define kEventKey @"event"

#define kMonitoringKey @"monitoring"
#define kComponentsKey @"components"

@interface HPFStats()

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *domain;

@property (nonatomic, strong) HPFComponent *component;

@end

@implementation HPFStats

static HPFStats *_current = nil;

+ (HPFStats *)current {
    return _current;
}

+ (void)setCurrent:(HPFStats *)current {
    _current = current;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Get Bundle Identifier
        self.domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
        
        //Generate a random 128-bits identifier
        NSString *uuid = [[NSUUID UUID] UUIDString];
        
        
        if (uuid && self.domain) {
            self.identifier = [self sha256:[NSString stringWithFormat:@"%@:%@", uuid, self.domain]];
        }
        
        self.component = [HPFComponent new];
    }
    return self;
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.identifier) {
        [dict setValue:self.identifier forKey:kIdentifierKey];
    }
    if (self.domain) {
        [dict setValue:self.domain forKey:kDomainKey];
    }
    if (self.status != nil) {
        [dict setValue:self.status forKey:kStatusKey];
    }
    if (self.paymentMethod) {
        [dict setValue:self.paymentMethod forKey:kPaymentMethodKey];
    }
    if (self.cardCountry) {
        [dict setValue:self.cardCountry forKey:kCardCountryKey];
    }
    
    if (self.amount.floatValue > 0.0) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        f.maximumFractionDigits = 2;
        f.minimumFractionDigits = 2;
        f.decimalSeparator = @".";
        NSString *formattedAmount = [f stringFromNumber:self.amount];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:formattedAmount];
        [dict setValue:amount forKey:kAmountKey];
    }

    if (self.currency) {
        [dict setValue:self.currency forKey:kCurrencyKey];
    }
    
    if (self.orderID) {
        [dict setValue:self.orderID forKey:kOrderIDKey];
    }
    
    if (self.transactionID) {
        [dict setValue:self.transactionID forKey:kTransactionIDKey];
    }

    [dict setValue:[self eventToString] forKey:kEventKey];
    
    if (self.monitoring) {
        [dict setObject:self.monitoring.toJSON forKey:kMonitoringKey];
    }
    
    if (self.component) {
        [dict setObject:self.component.toJSON forKey:kComponentsKey];
    }
    
    return dict;
}

- (NSString *)eventToString {
    switch (self.event) {
        case HPFEventInit:
            return @"init";
            break;
        case HPFEventTokenize:
            return @"tokenize";
            break;
        case HPFEventRequest:
            return @"request";
            break;
        default:
            break;
    }
}

- (NSString *)sha256:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSData *hash = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    NSString *hashString = [hash description];
    hashString = [hashString stringByReplacingOccurrencesOfString:@" " withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hashString;
}

- (void)send {
    NSString *statsUrlStage = @"https://stage-data.hipay.com/checkout-data";
    NSString *statsUrlProd = @"https://data.hipay.com/checkout-data";
    
    NSString *urlString = @"";
    
    switch ([HPFClientConfig sharedClientConfig].environment) {
        case HPFEnvironmentStage:
            urlString = statsUrlStage;
            break;
        case HPFEnvironmentProduction:
            urlString = statsUrlProd;
            break;
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"sdk-ios-hipay" forHTTPHeaderField:@"X-Who-Api"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toJSON] options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return;
    }
    request.HTTPBody = jsonData;
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [downloadTask resume];
}

@end
