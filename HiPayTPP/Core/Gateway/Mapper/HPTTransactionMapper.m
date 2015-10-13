//
//  HPTTransactionMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTTransactionMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTTransaction.h"
#import "HPTTransactionRelatedItemMapper+Private.h"
#import "HPTThreeDSecureMapper.h"
#import "HPTFraudScreeningMapper.h"
#import "HPTOrderMapper.h"
#import "HPTPaymentCardTokenMapper.h"

@implementation HPTTransactionMapper

- (id _Nonnull)mappedObject
{
    HPTTransaction *object = [self mappedObjectWithTransactionRelatedItem:[[HPTTransaction alloc] init]];

    [object setValue:[[HPTThreeDSecureMapper mapperWithRawData:[self getDictionaryForKey:@"threeDSecure"]] mappedObject] forKey:@"threeDSecure"];
    
    [object setValue:[[HPTFraudScreeningMapper mapperWithRawData:[self getDictionaryForKey:@"fraudScreening"]] mappedObject] forKey:@"fraudScreening"];
    
    [object setValue:[[HPTOrderMapper mapperWithRawData:[self getDictionaryForKey:@"order"]] mappedObject] forKey:@"order"];
    
    [object setValue:[[HPTPaymentCardTokenMapper mapperWithRawData:[self getDictionaryForKey:@"paymentMethod"]] mappedObject] forKey:@"paymentMethod"];
    
    [object setValue:@([self getIntegerEnumValueWithKey:@"state" defaultEnumValue:HPTTransactionStateError allValues:[HPTTransactionMapper transactionStateMapping]]) forKey:@"state"];
    

    
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
    
    
    return object;
}

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"state"] != nil;
}

+ (NSDictionary *)transactionStateMapping
{
    return @{@"completed": @(HPTTransactionStateCompleted),
             @"forwarding": @(HPTTransactionStateForwarding),
             @"pending": @(HPTTransactionStatePending),
             @"declined": @(HPTTransactionStateDeclined),
             @"error": @(HPTTransactionStateError)};
}

@end
