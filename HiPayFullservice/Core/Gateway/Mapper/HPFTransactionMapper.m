//
//  HPFTransactionMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFTransactionMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFTransaction.h"
#import "HPFTransactionRelatedItemMapper+Private.h"
#import "HPFThreeDSecureMapper.h"
#import "HPFFraudScreeningMapper.h"
#import "HPFOrderMapper.h"
#import "HPFPaymentCardTokenMapper.h"

@implementation HPFTransactionMapper

- (id _Nonnull)mappedObject
{
    HPFTransaction *object = [self mappedObjectWithTransactionRelatedItem:[[HPFTransaction alloc] init]];

    [object setValue:[[HPFThreeDSecureMapper mapperWithRawData:[self getDictionaryForKey:@"threeDSecure"]] mappedObject] forKey:@"threeDSecure"];
    
    [object setValue:[[HPFFraudScreeningMapper mapperWithRawData:[self getDictionaryForKey:@"fraudScreening"]] mappedObject] forKey:@"fraudScreening"];
    
    [object setValue:[[HPFOrderMapper mapperWithRawData:[self getDictionaryForKey:@"order"]] mappedObject] forKey:@"order"];
    
    [object setValue:[[HPFPaymentCardTokenMapper mapperWithRawData:[self getDictionaryForKey:@"paymentMethod"]] mappedObject] forKey:@"paymentMethod"];
    
    [object setValue:@([self getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPFTransactionStateError allValues:[HPFTransactionMapper transactionStateMapping]]) forKey:@"state"];
    
    [object setValue:[self getStringForKey:@"cdata1"] forKey:@"cdata1"];
    [object setValue:[self getStringForKey:@"cdata2"] forKey:@"cdata2"];
    [object setValue:[self getStringForKey:@"cdata3"] forKey:@"cdata3"];
    [object setValue:[self getStringForKey:@"cdata4"] forKey:@"cdata4"];
    [object setValue:[self getStringForKey:@"cdata5"] forKey:@"cdata5"];
    [object setValue:[self getStringForKey:@"cdata6"] forKey:@"cdata6"];
    [object setValue:[self getStringForKey:@"cdata7"] forKey:@"cdata7"];
    [object setValue:[self getStringForKey:@"cdata8"] forKey:@"cdata8"];
    [object setValue:[self getStringForKey:@"cdata9"] forKey:@"cdata9"];
    [object setValue:[self getStringForKey:@"cdata10"] forKey:@"cdata10"];
    
    [object setValue:[self getStringForKey:@"reason"] forKey:@"reason"];
    [object setValue:[self getStringForKey:@"attemptId"] forKey:@"attemptId"];
    [object setValue:[self getStringForKey:@"referenceToPay"] forKey:@"referenceToPay"];
    [object setValue:[self getStringForKey:@"ipAddress"] forKey:@"ipAddress"];
    [object setValue:[self getStringForKey:@"ipCountry"] forKey:@"ipCountry"];
    [object setValue:[self getStringForKey:@"deviceId"] forKey:@"deviceId"];
    [object setValue:[self getStringForKey:@"paymentProduct"] forKey:@"paymentProduct"];

    [object setValue:[self getURLForKey:@"forwardUrl"] forKey:@"forwardUrl"];
    
    [object setValue:[self getEnumCharForKey:@"avsResult"] forKey:@"avsResult"];
    [object setValue:[self getEnumCharForKey:@"cvcResult"] forKey:@"cvcResult"];
    
    [object setValue:@([self getIntegerForKey:@"eci"]) forKey:@"eci"];
    
    return object;
}

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"state"] != nil;
}

+ (NSDictionary *)transactionStateMapping
{
    return @{@"completed": @(HPFTransactionStateCompleted),
             @"forwarding": @(HPFTransactionStateForwarding),
             @"pending": @(HPFTransactionStatePending),
             @"declined": @(HPFTransactionStateDeclined),
             @"error": @(HPFTransactionStateError)};
}

@end
