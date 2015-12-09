//
//  HPFHostedPaymentPageMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import "HPFHostedPaymentPageMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFHostedPaymentPage.h"

@implementation HPFHostedPaymentPageMapper

- (id _Nonnull)mappedObject
{
    HPFHostedPaymentPage *object = [[HPFHostedPaymentPage alloc] init];
    
    [object setValue:[[HPFOrderMapper mapperWithRawData:[self getDictionaryForKey:@"order"]] mappedObject] forKey:@"order"];
    
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
    
    [object setValue:[self getURLForKey:@"forwardUrl"] forKey:@"forwardUrl"];
    [object setValue:@([self getBoolForKey:@"test"]) forKey:@"test"];
    [object setValue:[self getStringForKey:@"mid"] forKey:@"mid"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"forwardUrl"] != nil;
}

@end
