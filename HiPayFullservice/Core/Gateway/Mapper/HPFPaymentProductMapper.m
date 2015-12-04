//
//  HPFPaymentProductMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import "HPFPaymentProductMapper.h"
#import "HPFPaymentProduct.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFPaymentProductMapper

- (id _Nonnull)mappedObject
{
    HPFPaymentProduct *object = [[HPFPaymentProduct alloc] init];
    
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
