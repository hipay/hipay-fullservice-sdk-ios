//
//  HPFReasonMapper.m
//  HiPayFullservice.common
//
//  Created by HiPay on 27/11/2017.
//

#import "HPFReasonMapper.h"
#import "HPFReason.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFReasonMapper

- (id _Nonnull)mappedObject
{
    HPFReason *object = [[HPFReason alloc] init];
    [object setValue:[self getStringForKey:@"message"] forKey:@"message"];
    [object setValue:[self getStringForKey:@"code"] forKey:@"code"];

    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"message"] != nil;
}

@end
