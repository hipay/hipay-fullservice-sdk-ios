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
    
    return object;
}

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"state"] != nil;
}

@end
