//
//  HPFOrderMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFOrderMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFOrder.h"
#import "HPFPersonalInformationMapper+Private.h"

@implementation HPFOrderMapper

- (BOOL)isValid
{
    return [super isValid] && [self.rawData objectForKey:@"id"] != nil;
}

- (id _Nonnull)mappedObject
{
    HPFOrder *object = [self mappedObjectWithPersonalInformation:[[HPFOrder alloc] init]];
    
    [object setValue:[self getStringForKey:@"currency"] forKey:@"currency"];
    [object setValue:[self getStringForKey:@"customerId"] forKey:@"customerId"];
    [object setValue:[self getStringForKey:@"language"] forKey:@"language"];
    [object setValue:[self getStringForKey:@"id"] forKey:@"orderId"];
    [object setValue:@([self getIntegerForKey:@"attempts"]) forKey:@"attempts"];
    [object setValue:[self getNumberForKey:@"amount"] forKey:@"amount"];
    [object setValue:[self getNumberForKey:@"shipping"] forKey:@"shipping"];
    [object setValue:[self getNumberForKey:@"tax"] forKey:@"tax"];
    [object setValue:[self getNumberForKey:@"decimals"] forKey:@"decimals"];
    [object setValue:[self getEnumCharForKey:@"gender"] forKey:@"gender"];
    [object setValue:[self getDateForKey:@"dateCreated"] forKey:@"dateCreated"];
    [object setValue:[[HPFPersonalInformationMapper mapperWithRawData:[self getDictionaryForKey:@"shippingAddress"]] mappedObject] forKey:@"shippingAddress"];
    
    return object;
}

@end
