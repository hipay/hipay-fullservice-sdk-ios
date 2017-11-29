//
//  HPFTransactionCallbackMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 18/11/2015.
//
//

#import "HPFTransactionCallbackMapper.h"
#import "HPFTransaction.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFTransactionMapper.h"
#import "HPFFraudScreeningMapper.h"
#import "HPFPaymentCardTokenMapper.h"
#import "HPFReasonMapper.h"
#import "HPFReason.h"

@implementation HPFTransactionCallbackMapper

- (id _Nonnull)mappedObject
{
    HPFTransaction *transaction = [[HPFTransaction alloc] init];
    
    [transaction setValue:[self getStringForKey:@"reference"] forKey:@"transactionReference"];
    
    [transaction setValue:@([self getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPFTransactionStateError allValues:[HPFTransactionMapper transactionStateMapping]]) forKey:@"state"];
    
    [transaction setValue:@([self getIntegerForKey:@"status"]) forKey:@"status"];
    [transaction setValue:@([self getBoolForKey:@"test"]) forKey:@"test"];

    [transaction setValue:[self getStringForKey:@"ip"] forKey:@"ipAddress"];
    [transaction setValue:[self getStringForKey:@"country"] forKey:@"ipCountry"];

    [transaction setValue:[self getEnumCharForKey:@"avscheck"] forKey:@"avsResult"];
    [transaction setValue:[self getEnumCharForKey:@"cvccheck"] forKey:@"cvcResult"];

    [transaction setValue:[self getStringForKey:@"pp"] forKey:@"paymentProduct"];
    [transaction setValue:[self getStringForKey:@"reason"] forKey:@"reasonCode"];
    
    [transaction setValue:[self getStringForKey:@"cdata1"] forKey:@"cdata1"];
    [transaction setValue:[self getStringForKey:@"cdata2"] forKey:@"cdata2"];
    [transaction setValue:[self getStringForKey:@"cdata3"] forKey:@"cdata3"];
    [transaction setValue:[self getStringForKey:@"cdata4"] forKey:@"cdata4"];
    [transaction setValue:[self getStringForKey:@"cdata5"] forKey:@"cdata5"];
    [transaction setValue:[self getStringForKey:@"cdata6"] forKey:@"cdata6"];
    [transaction setValue:[self getStringForKey:@"cdata7"] forKey:@"cdata7"];
    [transaction setValue:[self getStringForKey:@"cdata8"] forKey:@"cdata8"];
    [transaction setValue:[self getStringForKey:@"cdata9"] forKey:@"cdata9"];
    [transaction setValue:[self getStringForKey:@"cdata10"] forKey:@"cdata10"];
    
    // Order
    NSString *orderId = [self getStringForKey:@"orderid"];
    
    if (orderId != nil) {
        HPFOrder *order = [[HPFOrder alloc] init];
        
        [order setValue:orderId forKey:@"orderId"];
        [order setValue:[self getStringForKey:@"lang"] forKey:@"language"];
        [order setValue:[self getStringForKey:@"email"] forKey:@"email"];
        [order setValue:[self getStringForKey:@"cid"] forKey:@"customerId"];

        [transaction setValue:order forKey:@"order"];
    }

    // Fraud screening

    if ([self getObjectForKey:@"score"] != nil) {
        HPFFraudScreening *fraudScreening = [[HPFFraudScreening alloc] init];
        
        [fraudScreening setValue:@([self getIntegerForKey:@"score"]) forKey:@"scoring"];
        [fraudScreening setValue:@([self getIntegerEnumValueWithKey:@"fraud" defaultEnumValue:HPFFraudScreeningResultUnknown allValues:[HPFFraudScreeningMapper resultMapping]]) forKey:@"result"];
        [fraudScreening setValue:@([self getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPFFraudScreeningReviewNone allValues:[HPFFraudScreeningMapper reviewMapping]]) forKey:@"review"];
        
        [transaction setValue:fraudScreening forKey:@"fraudScreening"];
    }
    
    // 3-D Secure info
    NSNumber *enrollmentStatus = [self getEnumCharForKey:@"veres"];
    
    if (enrollmentStatus != nil) {
        HPFThreeDSecure *threeDSecure = [[HPFThreeDSecure alloc] init];
        
        [threeDSecure setValue:enrollmentStatus forKey:@"enrollmentStatus"];
        [threeDSecure setValue:[self getEnumCharForKey:@"pares"] forKey:@"authenticationStatus"];
        
        [transaction setValue:threeDSecure forKey:@"threeDSecure"];
    }
    
    // Card token payment method
    NSString *cardToken = [self getStringForKey:@"cardtoken"];
    
    if (cardToken != nil) {
        HPFPaymentCardToken *paymentMethod = [[HPFPaymentCardToken alloc] init];
        
        [paymentMethod setValue:cardToken forKey:@"token"];
        [paymentMethod setValue:[self getStringForKey:@"cardpan"] forKey:@"pan"];
        [paymentMethod setValue:[self getStringForKey:@"cardbrand"] forKey:@"brand"];
        [paymentMethod setValue:[self getStringForKey:@"cardcountry"] forKey:@"country"];

        NSDateComponents *expiryDate = [self getYearAndMonthForKey:@"cardexpiry"];
        
        if (expiryDate != nil) {
            [paymentMethod setValue:@(expiryDate.month) forKey:@"cardExpiryMonth"];
            [paymentMethod setValue:@(expiryDate.year) forKey:@"cardExpiryYear"];
        }

        [transaction setValue:paymentMethod forKey:@"paymentMethod"];
    }
    
    return transaction;
}

- (BOOL)isValid
{
    return ([self.rawData objectForKey:@"reference"] != nil) && ([self.rawData objectForKey:@"state"] != nil);
}


@end
