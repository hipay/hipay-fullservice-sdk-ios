//
//  HPTTransactionCallbackMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 18/11/2015.
//
//

#import "HPTTransactionCallbackMapper.h"
#import "HPTTransaction.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTTransactionMapper.h"
#import "HPTFraudScreeningMapper.h"
#import "HPTPaymentCardTokenMapper.h"

@implementation HPTTransactionCallbackMapper

- (id _Nonnull)mappedObject
{
    HPTTransaction *transaction = [[HPTTransaction alloc] init];
    
    [transaction setValue:[self getStringForKey:@"reference"] forKey:@"transactionReference"];
    
    [transaction setValue:@([self getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPTTransactionStateError allValues:[HPTTransactionMapper transactionStateMapping]]) forKey:@"state"];
    
    [transaction setValue:@([self getIntegerForKey:@"status"]) forKey:@"status"];
    [transaction setValue:@([self getBoolForKey:@"test"]) forKey:@"test"];

    [transaction setValue:[self getStringForKey:@"ip"] forKey:@"ipAddress"];
    [transaction setValue:[self getStringForKey:@"country"] forKey:@"ipCountry"];

    [transaction setValue:[self getEnumCharForKey:@"avscheck"] forKey:@"avsResult"];
    [transaction setValue:[self getEnumCharForKey:@"cvccheck"] forKey:@"cvcResult"];

    [transaction setValue:[self getStringForKey:@"pp"] forKey:@"paymentProduct"];
    [transaction setValue:[self getStringForKey:@"reason"] forKey:@"reason"];
    
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
        HPTOrder *order = [[HPTOrder alloc] init];
        
        [order setValue:orderId forKey:@"orderId"];
        [order setValue:[self getStringForKey:@"lang"] forKey:@"language"];
        [order setValue:[self getStringForKey:@"email"] forKey:@"email"];
        [order setValue:[self getStringForKey:@"cid"] forKey:@"customerId"];

        [transaction setValue:order forKey:@"order"];
    }
    
    // Fraud screening

    if ([self getObjectForKey:@"score"] != nil) {
        HPTFraudScreening *fraudScreening = [[HPTFraudScreening alloc] init];
        
        [fraudScreening setValue:@([self getIntegerForKey:@"score"]) forKey:@"scoring"];
        [fraudScreening setValue:@([self getIntegerEnumValueWithKey:@"fraud" defaultEnumValue:HPTFraudScreeningResultUnknown allValues:[HPTFraudScreeningMapper resultMapping]]) forKey:@"result"];
        [fraudScreening setValue:@([self getIntegerEnumValueWithKey:@"review" defaultEnumValue:HPTFraudScreeningReviewNone allValues:[HPTFraudScreeningMapper reviewMapping]]) forKey:@"review"];
        
        [transaction setValue:fraudScreening forKey:@"fraudScreening"];
    }
    
    // 3-D Secure info
    NSNumber *enrollmentStatus = [self getEnumCharForKey:@"veres"];
    
    if (enrollmentStatus != nil) {
        HPTThreeDSecure *threeDSecure = [[HPTThreeDSecure alloc] init];
        
        [threeDSecure setValue:enrollmentStatus forKey:@"enrollmentStatus"];
        [threeDSecure setValue:[self getEnumCharForKey:@"pares"] forKey:@"authenticationStatus"];
        
        [transaction setValue:threeDSecure forKey:@"threeDSecure"];
    }
    
    // Card token payment method
    NSString *cardToken = [self getStringForKey:@"cardtoken"];
    
    if (cardToken != nil) {
        HPTPaymentCardToken *paymentMethod = [[HPTPaymentCardToken alloc] init];
        
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
