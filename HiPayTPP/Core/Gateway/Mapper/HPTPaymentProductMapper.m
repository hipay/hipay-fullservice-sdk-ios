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
    
    [object setValue:[self getStringForKey:@"code"] forKey:@"code"];
    [object setValue:[self getStringForKey:@"description"] forKey:@"paymentProductDescription"];
    [object setValue:[self getStringForKey:@"id"] forKey:@"paymentProductId"];
    [object setValue:[self getStringForKey:@"paymentProductCategoryCode"] forKey:@"paymentProductCategoryCode"];
    [object setValue:@([self getBoolForKey:@"tokenizable"]) forKey:@"tokenizable"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"code"] != nil;
}

@end
