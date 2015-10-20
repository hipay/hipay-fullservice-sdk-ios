//
//  HPTPaymentProductMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import "HPTPaymentProductMapper.h"
#import "HPTPaymentProduct.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTPaymentProductMapper

- (id _Nonnull)mappedObject
{
    HPTPaymentProduct *object = [[HPTPaymentProduct alloc] init];
    
    [object setValue:[self getStringForKey:@"resource"] forKey:@"resource"];
    [object setValue:[self getStringForKey:@"paymentProductDescription"] forKey:@"paymentProductDescription"];
    [object setValue:[self getStringForKey:@"paymentProductId"] forKey:@"paymentProductId"];
    [object setValue:@([self getBoolForKey:@"tokenizable"]) forKey:@"tokenizable"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"resource"] != nil;
}

@end
