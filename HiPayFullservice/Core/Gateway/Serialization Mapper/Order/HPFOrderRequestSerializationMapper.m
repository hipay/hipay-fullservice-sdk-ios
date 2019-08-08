//
//  HPFOrderRequestSerializationMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFOrderRequestSerializationMapper.h"
#import "HPFOrderRequest.h"
#import "NSMutableDictionary+Serialization.h"
#import "HPFAbstractSerializationMapper+Encode.h"
#import "HPFOrderRelatedRequestSerializationMapper_Private.h"
#import "HPFCardTokenPaymentMethodRequestSerializationMapper.h"
#import "HPFQiwiWalletPaymentMethodRequestSerializationMapper.h"
#import "HPFIDealPaymentMethodRequestSerializationMapper.h"
#import "HPFSepaDirectDebitPaymentMethodRequestSerializationMapper.h"
#import "HPFCardTokenPaymentMethodRequest.h"
#import "HPFQiwiWalletPaymentMethodRequest.h"
#import "HPFIDealPaymentMethodRequest.h"
#import "HPFSepaDirectDebitPaymentMethodRequest.h"
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFLogger.h"

@implementation HPFOrderRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];
    
    [result setNullableObject:[self getStringForKey:@"paymentProductCode"] forKey:@"payment_product"];
    
    [result mergeDictionary:[self paymentMethodSerializedRequest] withPrefix:nil];
    
    [self addCardStored24hIfNeeded:result];
    
    // if recurring payment, we add "enrollment_date" var in result
    NSNumber *eci = result[@"eci"];
    if (eci && eci.intValue == HPFECIRecurringECommerce) {
        [self addEnrollmentDateIfNeeded:result];
    }

    return [self createImmutableDictionary:result];
}

- (NSDictionary *)paymentMethodSerializedRequest
{
    HPFAbstractPaymentMethodRequest *paymentMethodRequest = [self.request valueForKey:@"paymentMethod"];

    if ([paymentMethodRequest isKindOfClass:[HPFCardTokenPaymentMethodRequest class]]) {
        return [HPFCardTokenPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    else if ([paymentMethodRequest isKindOfClass:[HPFQiwiWalletPaymentMethodRequest class]]) {
        return [HPFQiwiWalletPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    else if ([paymentMethodRequest isKindOfClass:[HPFIDealPaymentMethodRequest class]]) {
        return [HPFIDealPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    else if ([paymentMethodRequest isKindOfClass:[HPFSepaDirectDebitPaymentMethodRequest class]]) {
        return [HPFSepaDirectDebitPaymentMethodRequestSerializationMapper mapperWithRequest:paymentMethodRequest].serializedRequest;
    }
    
    return nil;
}

-(void) addCardStored24hIfNeeded:(NSMutableDictionary *)dictionary {
    
    NSDictionary *accountInfo = dictionary[@"account_info"];
    NSDictionary *purchase = accountInfo[@"purchase"];
    NSNumber *cardStored24h = purchase[@"card_stored_24h"];
    
    if (!cardStored24h) {
        id tokenDatabase = NSClassFromString(@"HPFPaymentCardTokenDatabase");
        
        if ([tokenDatabase respondsToSelector:@selector(numberOfCardSavedInLast24HoursForCurrency:)]) {
            NSString *currency = dictionary[@"currency"];
            NSUInteger numberOfCardSavedInLast24Hours =  [(Class)tokenDatabase numberOfCardSavedInLast24HoursForCurrency:currency];
            
            NSMutableDictionary *purchaseMut = [purchase mutableCopy] ? [purchase mutableCopy] : [NSMutableDictionary new];
            purchaseMut[@"card_stored_24h"] = @(numberOfCardSavedInLast24Hours);

            NSMutableDictionary *accountInfoMut = [accountInfo mutableCopy] ? [accountInfo mutableCopy] : [NSMutableDictionary new];
            dictionary[@"account_info"] = accountInfoMut;
            dictionary[@"account_info"][@"purchase"] = purchaseMut;
            
            [[HPFLogger sharedLogger] debug:@"<Order> card_stored_24 attribute added to Order Request with value \"%d\"", numberOfCardSavedInLast24Hours];
        }
    }
}

-(void) addEnrollmentDateIfNeeded:(NSMutableDictionary *)dictionary {
    
    NSDictionary *accountInfo = dictionary[@"account_info"];
    NSDictionary *payment = accountInfo[@"payment"];
    NSNumber *enrollmentDate = payment[@"enrollment_date"];
    NSString *token = dictionary[@"cardtoken"];

    if (!enrollmentDate && token) {
        
        id tokenDatabase = NSClassFromString(@"HPFPaymentCardTokenDatabase");
        
        if ([tokenDatabase respondsToSelector:@selector(enrollmentDateForToken:forCurrency:)]) {
            NSString *currency = dictionary[@"currency"];
            NSDate *enrollmentDate =  [(Class)tokenDatabase enrollmentDateForToken:token forCurrency:currency];
            
            if (enrollmentDate) {
                NSMutableDictionary *paymentMut = [payment mutableCopy] ? [payment mutableCopy] : [NSMutableDictionary new];

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"YYYYMMdd";
                dateFormatter.timeZone = [NSTimeZone localTimeZone];
                
                NSString *enrollmentDateString = [dateFormatter stringFromDate:enrollmentDate];
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterNoStyle;
                paymentMut[@"enrollment_date"] = [formatter numberFromString:enrollmentDateString];
                
                NSMutableDictionary *accountInfoMut = [accountInfo mutableCopy] ? [accountInfo mutableCopy] : [NSMutableDictionary new];
                dictionary[@"account_info"] = accountInfoMut;
                dictionary[@"account_info"][@"payment"] = paymentMut;
                
                [[HPFLogger sharedLogger] debug:@"<Order> enrollment_date attribute added to Order Request with value \"%@\"", enrollmentDateString];
            }
        }

    }
}

@end
