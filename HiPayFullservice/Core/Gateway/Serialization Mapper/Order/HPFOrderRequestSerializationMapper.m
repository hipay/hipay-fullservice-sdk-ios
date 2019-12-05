//
//  HPFOrderRequestSerializationMapper.m
//  Pods
//
//  Created by HiPay on 14/10/2015.
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
#import "HPFPaymentProduct.h"

@implementation HPFOrderRequestSerializationMapper

- (NSDictionary *)serializedRequest
{
    NSMutableDictionary *result = [self orderRelatedSerializedRequest];
    
    [result setNullableObject:[self getStringForKey:@"paymentProductCode"] forKey:@"payment_product"];
    [result mergeDictionary:[self paymentMethodSerializedRequest] withPrefix:nil];
    
    NSString *paymentProductCode = [self getStringForKey:@"paymentProductCode"];
    
    if ([HPFPaymentProduct isDSP2CompatiblePaymentProductCode:paymentProductCode]) {
        [result setNullableObject:[self.request valueForKey:@"merchantRiskStatement"] forKey:@"merchant_risk_statement"];
        [result setNullableObject:[self.request valueForKey:@"previousAuthInfo"] forKey:@"previous_auth_info"];
        [result setNullableObject:[self.request valueForKey:@"accountInfo"] forKey:@"account_info"];
        [result setNullableObject:[self.request valueForKey:@"browserInfo"] forKey:@"browser_info"];
        [result setNullableObject:[self.request valueForKey:@"deviceChannel"] forKey:@"device_channel"];
        
        [self addCardStored24hIfNeeded:result];
        [self addNameIndicatorIfNeeded:result];
        
        // if recurring payment, we add "enrollment_date" var in result
        NSNumber *eci = result[@"eci"];
        if (eci && eci.intValue == HPFECIRecurringECommerce) {
            [self addEnrollmentDateIfNeeded:result];
        }

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
    
    if (cardStored24h == nil) {
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

    if (enrollmentDate == nil && token) {
        
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

- (void)addNameIndicatorIfNeeded:(NSMutableDictionary *)dictionary
{
    if ([self.request isKindOfClass:[HPFOrderRelatedRequest class]]) {
        HPFOrderRelatedRequest *myRequest = (HPFOrderRelatedRequest *)self.request;
        NSDictionary *accountInfo = dictionary[@"account_info"];
        NSDictionary *shipping = accountInfo[@"shipping"];
        NSNumber *currentNameIndicator = shipping[@"name_indicator"];
        BOOL currentNameIndicatorEmpty = [currentNameIndicator isKindOfClass:[NSString class]] && ((NSString *)currentNameIndicator).length == 0;
        
        if (currentNameIndicator == nil || currentNameIndicatorEmpty) {
            HPFCustomerInfoRequest *customer = myRequest.customer;
            NSString *firstNameCustomer = customer.firstname;
            NSString *lastNameCustomer = customer.lastname;
            
            HPFPersonalInfoRequest *shippingAddress = myRequest.shippingAddress;
            NSString *firstNameShipping = shippingAddress.firstname;
            NSString *lastNameShipping = shippingAddress.lastname;
            
            // Do not add name_indicator property if firstname or lastname empty
            if (!firstNameShipping || !lastNameShipping) {
                return;
            }
            
            NSNumber *nameIndicator = @2;
            
            if (firstNameCustomer.length > 0 &&
                lastNameCustomer.length > 0 &&
                [firstNameCustomer.lowercaseString isEqualToString:firstNameShipping.lowercaseString] &&
                [lastNameCustomer.lowercaseString isEqualToString:lastNameShipping.lowercaseString]) {
                
                nameIndicator = @1;
            }
            
            NSMutableDictionary *shippingMut = [shipping mutableCopy] ? [shipping mutableCopy] : [NSMutableDictionary new];
            shippingMut[@"name_indicator"] = nameIndicator;
            
            NSMutableDictionary *accountInfoMut = [accountInfo mutableCopy] ? [accountInfo mutableCopy] : [NSMutableDictionary new];
            dictionary[@"account_info"] = accountInfoMut;
            dictionary[@"account_info"][@"shipping"] = shippingMut;
            
            [[HPFLogger sharedLogger] debug:@"<Order> name_indicator attribute added to Order Request with value \"%d\"", nameIndicator];
        }
    }
}


@end
